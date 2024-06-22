import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:users_app/global/global.dart';

class DatabaseService {
  final String databaseUrl =
      'https://friendly-folio-425114-v9-default-rtdb.firebaseio.com/';

  Future<void> scheduleRide(Map<String, dynamic> rideData) async {
    final url = Uri.parse('$databaseUrl/rides.json');
    await http.post(url, body: json.encode(rideData));
  }

  Future<List<Map<String, dynamic>>> getScheduledRides() async {
    final url = Uri.parse('$databaseUrl/rides.json');
    final response = await http.get(url);
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    List<Map<String, dynamic>> rides = [];
    extractedData.forEach((rideId, rideData) {
      rides.add({
        'id': rideId,
        ...rideData,
      });
    });
    return rides;
  }

  Future<void> sendProposal(
      String rideId, Map<String, dynamic> proposalData) async {
    final url = Uri.parse('$databaseUrl/rides/$rideId/proposals.json');
    await http.post(url, body: json.encode(proposalData));
  }

  Future<void> confirmDriver(String rideId, String driverId) async {
    final url = Uri.parse('$databaseUrl/rides/$rideId.json');
    await http.patch(url,
        body: json.encode({
          'confirmedDriver': driverId,
          'status': 'confirmed',
        }));
  }
}

class UpCommingTripScreen extends StatefulWidget {
  @override
  _UpCommingTripScreenState createState() => _UpCommingTripScreenState();
}

class _UpCommingTripScreenState extends State<UpCommingTripScreen> {
  final DatabaseService database = DatabaseService();
  Future<List<Map<String, dynamic>>>? _ridesFuture;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchRides();
  }

  void _fetchRides() {
    setState(() {
      _ridesFuture = database.getScheduledRides();
    });
  }

  void _confirmDriver(String rideId, String driverId) async {
    setState(() {
      _isLoading = true;
    });
    try {
      await database.confirmDriver(rideId, driverId);
      _fetchRides();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Driver confirmed successfully'),
      ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to confirm driver: $e'),
      ));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Up Comming Trips'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 20),
            Expanded(
              child: FutureBuilder(
                future: _ridesFuture,
                builder: (context,
                    AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No rides available'));
                  }

                  final data = snapshot.data!;
                  final rides = data.where((element) => element['uid']==currentUid).toList();

                  return ListView.builder(
                    itemCount: rides.length,
                    itemBuilder: (context, index) {
                      final ride = rides[index];
                      final proposals = ride['proposals'] ?? {};

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${ride['rideType']}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Scheduled Time: ${DateTime.parse(ride['scheduledTime']).toLocal()}',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Status: ${ride['status']}',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Pickup Location: ${ride['pickupLocation']}',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Dropping Point: ${ride['droppingPoint']}',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 16),
                              if (proposals.isNotEmpty)
                                SizedBox(
                                  height: 140,
                                  child: SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Proposals:',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        ...proposals.entries.map<Widget>((entry) {
                                          final proposal = entry.value;
                                          return ListTile(
                                            contentPadding: EdgeInsets.zero,
                                            title: Text(
                                              'Proposal from Driver ${proposal['driverId']}',
                                            ),
                                            trailing: ElevatedButton(
                                              onPressed: _isLoading
                                                  ? null
                                                  : () => _confirmDriver(
                                                        ride['id'],
                                                        proposal['driverId'],
                                                      ),
                                              child: _isLoading
                                                  ? const CircularProgressIndicator()
                                                  : const Text('Confirm Driver'),
                                            ),
                                          );
                                        }).toList(),
                                      ],
                                    ),
                                  ),
                                ),
                              if (proposals.isEmpty)
                                const Text(
                                  'No proposals available',
                                  style: TextStyle(
                                    color: Colors.redAccent,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
