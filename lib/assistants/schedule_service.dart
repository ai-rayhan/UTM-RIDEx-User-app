import 'package:firebase_database/firebase_database.dart';
import 'package:users_app/models/schedule.dart';

class DatabaseService {
  final DatabaseReference _db = FirebaseDatabase.instance.reference();
  final String uid;

  DatabaseService({required this.uid});

  Future<void> createRide(String deliveryType, DateTime scheduleTime) async {
    String rideId = _db.child('rides').push().key!;
    await _db.child('rides/$rideId').set({
      'uid': uid,
      'deliveryType': deliveryType,
      'scheduleTime': scheduleTime.toIso8601String(),
      'status': 'pending',
    });
  }
Stream<List<Ride>> getRides() {
  return _db.child('rides').orderByChild('uid').equalTo(uid).onValue.map((event) {
    final rides = <Ride>[];
    final data = event.snapshot.value as Map?;
    if (data != null) {
      data.forEach((key, value) {
        rides.add(Ride.fromMap(key, Map<String, dynamic>.from(value)));
      });
    }
    return rides;
  });
}


  Future<void> sendProposal(String rideId, String driverId) async {
    await _db.child('rides/$rideId/proposals').push().set({
      'driverId': driverId,
      'status': 'pending',
    });
  }

  Future<void> confirmProposal(String rideId, String proposalKey) async {
    await _db.child('rides/$rideId/proposals/$proposalKey').update({
      'status': 'confirmed',
    });

    await _db.child('rides/$rideId').update({
      'status': 'confirmed',
    });
  }
}
