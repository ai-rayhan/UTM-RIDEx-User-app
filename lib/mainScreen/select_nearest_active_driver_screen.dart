import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:smooth_star_rating_nsafe/smooth_star_rating.dart';
import 'package:users_app/assistants/assistant_methods.dart';
import 'package:users_app/global/global.dart';
import 'package:users_app/infoHandler/app_info.dart';

class SelectNearestActiveDriversScreen extends StatefulWidget {
  final DatabaseReference? referenceRideRequest;

  SelectNearestActiveDriversScreen({this.referenceRideRequest});

  @override
  State<SelectNearestActiveDriversScreen> createState() => _SelectNearestActiveDriversScreenState();
}

class _SelectNearestActiveDriversScreenState extends State<SelectNearestActiveDriversScreen> {
  String fareAmount = "";

  @override
  void initState() {
    super.initState();
    getDriverList();
  }

  void getDriverList() {
    final int rideIndex = context.read<AppInfo>().rideIndex;
    debugPrint("Ride index: $rideIndex");
    setState(() {
      if (dList != null) {
        if (rideIndex == 0) {
          dList = dList.where((element) => element['car_details']['vehicle_category'] == 'Bike').toList();
        } else if (rideIndex == 1) {
          dList = dList.where((element) => element['car_details']['vehicle_category'] == 'Car').toList();
        } else if (rideIndex == 2) {
          dList = dList.where((element) => element['delivery'] == 'yes').toList();
        }
      }
      debugPrint("Filtered driver list: ${dList?.length ?? 0} drivers found");
    });
  }

  @override
  void dispose() {
    dList = [];
    super.dispose();
  }

  getFareAmountAccordingToVehicleType(int index) {
    if (tripDirectionDetailsInfo != null) {
      fareAmount = (AssistantMethods.calculateFareAmountFromOriginToDestination(tripDirectionDetailsInfo!) * 4)
          .toStringAsFixed(1);
    }
    return fareAmount;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: const Text(
          "Nearest Online Drivers",
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.close,
            color: Colors.white,
          ),
          onPressed: () {
            widget.referenceRideRequest?.remove();
            Fluttertoast.showToast(msg: "You have cancelled the ride request.");
            SystemNavigator.pop();
          },
        ),
      ),
      body: dList == null || dList!.isEmpty
          ? Center(
              child: Text(
                dList == null ? "Error loading drivers" : "No drivers available",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: dList!.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      chosenDriverId = dList![index]["id"].toString();
                    });
                    Navigator.pop(context, "driverChoosed");
                  },
                  child: Card(
                    color: Colors.orangeAccent,
                    elevation: 3,
                    shadowColor: Colors.green,
                    margin: const EdgeInsets.all(8),
                    child: ListTile(
                      leading: Padding(
                        padding: const EdgeInsets.only(top: 2.0),
                        child: Image.asset(
                          "images/" + dList![index]["car_details"]["type"].toString() + ".png",
                          width: 70,
                        ),
                      ),
                      title: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            dList![index]["name"],
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            dList![index]["car_details"]["car_model"],
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                            ),
                          ),
                          SmoothStarRating(
                            rating: dList![index]["ratings"] == null ? 0.0 : double.parse(dList![index]["ratings"]),
                            color: Colors.black,
                            borderColor: Colors.black,
                            allowHalfRating: true,
                            starCount: 5,
                            size: 15,
                          ),
                        ],
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "\RM " + getFareAmountAccordingToVehicleType(index),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 2,
                          ),
                          Text(
                            tripDirectionDetailsInfo != null ? tripDirectionDetailsInfo!.duration_text! : "",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black54,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            tripDirectionDetailsInfo != null ? tripDirectionDetailsInfo!.distance_text! : "",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black54,
                                fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
