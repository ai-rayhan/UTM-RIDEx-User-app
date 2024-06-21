import 'dart:convert';
import 'package:http/http.dart' as http;

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
