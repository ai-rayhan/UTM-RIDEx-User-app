class Proposal {
  final String driverId;
  final String status;

  Proposal({required this.driverId, required this.status});

  factory Proposal.fromMap(Map<String, dynamic> data) {
    return Proposal(
      driverId: data['driverId'],
      status: data['status'],
    );
  }
}

class Ride {
  final String rideId;
  final String uid;
  final String deliveryType;
  final DateTime scheduleTime;
  final String status;
  final List<Proposal> proposals;

  Ride({
    required this.rideId,
    required this.uid,
    required this.deliveryType,
    required this.scheduleTime,
    required this.status,
    required this.proposals,
  });

  factory Ride.fromMap(String rideId, Map<String, dynamic> data) {
    List<Proposal> proposals = [];
    if (data['proposals'] != null) {
      data['proposals'].forEach((key, value) {
        proposals.add(Proposal.fromMap(value));
      });
    }

    return Ride(
      rideId: rideId,
      uid: data['uid'],
      deliveryType: data['deliveryType'],
      scheduleTime: DateTime.parse(data['scheduleTime']),
      status: data['status'],
      proposals: proposals,
    );
  }
}
