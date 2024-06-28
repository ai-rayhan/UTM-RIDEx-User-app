import 'package:flutter/material.dart';
import 'package:users_app/assistants/schedule_service.dart';

class DriverPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final database = ScheduleRideService();

    return Scaffold(
      appBar: AppBar(
        title: Text('Driver Panel'),
      ),
      body: FutureBuilder(
        future: database.getScheduledRides(),
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
                  onPressed: () {
                    database.sendProposal(ride['id'], {
                      'driverId': 'driver123', // This should be dynamic
                      'proposalTime': DateTime.now().toIso8601String(),
                      'status': 'pending'
                    });
                  },
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
