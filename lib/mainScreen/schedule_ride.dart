import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class DatabaseService {
  final String databaseUrl = 'https://friendly-folio-425114-v9-default-rtdb.firebaseio.com/';

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

  Future<void> sendProposal(String rideId, Map<String, dynamic> proposalData) async {
    final url = Uri.parse('$databaseUrl/rides/$rideId/proposals.json');
    await http.post(url, body: json.encode(proposalData));
  }

  Future<void> confirmDriver(String rideId, String driverId) async {
    final url = Uri.parse('$databaseUrl/rides/$rideId.json');
    await http.patch(url, body: json.encode({
      'confirmedDriver': driverId,
      'status': 'confirmed',
    }));
  }
}

class DriverPanel extends StatefulWidget {
  @override
  _DriverPanelState createState() => _DriverPanelState();
}

class _DriverPanelState extends State<DriverPanel> {
  final DatabaseService database = DatabaseService();
  Future<List<Map<String, dynamic>>>? _ridesFuture;

  @override
  void initState() {
    super.initState();
    _ridesFuture = database.getScheduledRides();
  }

  void _sendProposal(String rideId) async {
    await database.sendProposal(rideId, {
      'driverId': 'driver123', // This should be dynamic
      'proposalTime': DateTime.now().toIso8601String(),
      'status': 'pending'
    });
    setState(() {
      _ridesFuture = database.getScheduledRides();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Driver Panel'),
      ),
      body: FutureBuilder(
        future: _ridesFuture,
        builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No rides available'));
          }

          final rides = snapshot.data!;

          return ListView.builder(
            itemCount: rides.length,
            itemBuilder: (context, index) {
              final ride = rides[index];

              return ListTile(
                title: Text('${ride['rideType']} at ${DateTime.parse(ride['scheduledTime']).toLocal()}'),
                subtitle: Text('Status: ${ride['status']}'),
                trailing: ElevatedButton(
                  onPressed: () => _sendProposal(ride['id']),
                  child: Text('Send Proposal'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class UserPanel extends StatefulWidget {
  @override
  _UserPanelState createState() => _UserPanelState();
}

class _UserPanelState extends State<UserPanel> {
  final _formKey = GlobalKey<FormState>();
  final DatabaseService database = DatabaseService();
  String _rideType = 'Standard';
  DateTime _selectedTime = DateTime.now();
  Future<List<Map<String, dynamic>>>? _ridesFuture;

  @override
  void initState() {
    super.initState();
    _ridesFuture = database.getScheduledRides();
  }

  void _scheduleRide() async {
    await database.scheduleRide({
      'rideType': _rideType,
      'scheduledTime': _selectedTime.toIso8601String(),
      'status': 'pending',
      'proposals': []
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Ride Scheduled'),
    ));
    setState(() {
      _ridesFuture = database.getScheduledRides();
    });
  }

  void _confirmDriver(String rideId, String driverId) async {
    await database.confirmDriver(rideId, driverId);
    setState(() {
      _ridesFuture = database.getScheduledRides();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Panel'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  DropdownButtonFormField(
                    value: _rideType,
                    items: ['Standard', 'Premium'].map((String type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Text(type),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _rideType = newValue as String;
                      });
                    },
                    decoration: InputDecoration(labelText: 'Ride Type'),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: _selectedTime,
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2101),
                      );
                      if (picked != null && picked != _selectedTime) {
                        setState(() {
                          _selectedTime = picked;
                        });
                      }
                    },
                    child: Text('Select Ride Time'),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _scheduleRide();
                      }
                    },
                    child: Text('Schedule Ride'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: FutureBuilder(
                future: _ridesFuture,
                builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No rides available'));
                  }

                  final rides = snapshot.data!;

                  return ListView.builder(
                    itemCount: rides.length,
                    itemBuilder: (context, index) {
                      final ride = rides[index];
                      final proposals = ride['proposals'] ?? {};

                      return ExpansionTile(
                        title: Text('${ride['rideType']} at ${DateTime.parse(ride['scheduledTime']).toLocal()}'),
                        children: proposals.entries.map<Widget>((entry) {
                          final proposal = entry.value;
                          return ListTile(
                            title: Text('Proposal from ${proposal['driverId']}'),
                            trailing: ElevatedButton(
                              onPressed: () => _confirmDriver(ride['id'], proposal['driverId']),
                              child: Text('Confirm Driver'),
                            ),
                          );
                        }).toList(),
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
