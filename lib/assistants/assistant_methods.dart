import 'dart:convert';
import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:users_app/assistants/request_assistant.dart';
import 'package:users_app/global/global.dart';
import 'package:users_app/global/map_key.dart';
import 'package:users_app/infoHandler/app_info.dart';
import 'package:users_app/models/direction_details_info.dart';
import 'package:users_app/models/directions.dart';
import 'package:users_app/models/trips_history_model.dart';
import 'package:users_app/models/user_model.dart';
import 'package:http/http.dart' as http;

class AssistantMethods
{
  static Future<String> searchAddressForGeographicCoOrdinates(Position position, context) async
  {
    String apiUrl = "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapkey";
    String humanReadableAddress="";

    var requestResponse = await RequestAssistant.receiveRequest(apiUrl);
    log(requestResponse.toString());
    if(requestResponse != "Error Occurred, Failed. No response.")
      {
        humanReadableAddress = requestResponse["results"][0]["formatted_address"];

        Directions userPickUpAddress = Directions();
        userPickUpAddress.locationLatitude = position.latitude;
        userPickUpAddress.locationLongitude = position.longitude;
        userPickUpAddress.locationName = humanReadableAddress;

        Provider.of<AppInfo>(context, listen: false).updatePickUpLocationAddress(userPickUpAddress);
      }

    return humanReadableAddress;

  }

  static void readCurrentOnlineUserInfo() async
  {
    currentFirebaseUser = fAuth.currentUser;

    DatabaseReference userRef = FirebaseDatabase.instance
        .ref()
        .child("users") //to retrieve info from user in online
        .child(currentFirebaseUser!.uid);

    userRef.once().then((snap)
    {
      if(snap.snapshot.value != null)
        {
          userModelCurrentInfo = Usermodel.fromSnapshot(snap.snapshot);
          print("name =" + userModelCurrentInfo!.name.toString());
          print("email =" + userModelCurrentInfo!.email.toString());
        }
    });
  }

  static Future <DirectionDetailsInfo?> obtainOriginToDestinationDirectionDetails(LatLng originPosition, LatLng destinationPosition) async
  {
    String urlOriginToDestinationDirectionDetails = "https://maps.googleapis.com/maps/api/directions/json?origin=${originPosition.latitude},${originPosition.longitude}&destination=${destinationPosition.latitude},${destinationPosition.longitude}&key=$mapkey";

    var responseDirectionApi = await RequestAssistant.receiveRequest(urlOriginToDestinationDirectionDetails);

    if(responseDirectionApi == "Error Occurred, Failed. No response.")
      {
       return null;
      }

    DirectionDetailsInfo directionDetailsInfo = DirectionDetailsInfo();
    directionDetailsInfo.e_points = responseDirectionApi["routes"][0]["overview_polyline"]["points"];

    directionDetailsInfo.distance_text = responseDirectionApi["routes"][0]["legs"][0]["distance"]["text"];
    directionDetailsInfo.distance_value = responseDirectionApi["routes"][0]["legs"][0]["distance"]["value"];

    directionDetailsInfo.duration_text = responseDirectionApi["routes"][0]["legs"][0]["duration"]["text"];
    directionDetailsInfo.duration_value = responseDirectionApi["routes"][0]["legs"][0]["duration"]["value"];

    return directionDetailsInfo;
  }

  //formula
  static double calculateFareAmountFromOriginToDestination(DirectionDetailsInfo directionDetailsInfo)
  {
    double timeTraveledFareAmountPerMinute = (directionDetailsInfo.duration_value! / 60) * 0.1;
    double distanceTraveledFareAmountPerKilometer = (directionDetailsInfo.duration_value! / 1000) * 0.1;

    //1 usd = 4.40 myr
    double totalFareAmount = timeTraveledFareAmountPerMinute + distanceTraveledFareAmountPerKilometer;
    //double localCurrencyTotalFare = totalFareAmount * 4.40;

    return double.parse(totalFareAmount.toStringAsFixed(1));
  }

  static sendNotificationToDriverNow(String riderUID, context) async
  {
   
  final response = await http.post(
    Uri.parse('https://onesignal.com/api/v1/notifications'),
    headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization':
          'Basic MDhjMDQxN2MtOWVmZS00YjUyLWFmNDQtMDM0MzkzMjQ4MjA4',
    },
    body: json.encode({
      'app_id':
          '730ff581-8df1-415b-98da-0dab05dbd851',
      'headings': {'en': "New Ride Request"},
      'contents': {'en': "Accept or decline the ride request"},
       'include_player_ids': [riderUID]
    }),
  );

  if (response.statusCode == 200) {
    print("sent");
  } else {
    print(response.body);
  }

    // String destinationAddress = userDropOffAddress;

    // Map<String, String> headerNotification =
    //     {
    //       'Content-Type': 'application/json',
    //       'Authorization': cloudMessagingServerToken,
    //     };

    // Map bodyNotification =
    //     {
    //       "body":"Hello, you have a new Ride Request to, \n$destinationAddress",
    //       "title":"UTM Ridex App"
    //     };

    // Map datMap =
    //     {
    //       "click_action": "FLUTTER_NOTIFICATION_CLICK",
    //       "id": "1",
    //       "status": "done",
    //       "rideRequestId": userRideRequestId
    //     };

    // Map officialNotificationFormat =
    //     {
    //       "notification": bodyNotification,
    //       "data": datMap,
    //       "priority": "high",
    //       "to": deviceRegistrationToken,
    //     };
    // log(datMap.toString());
    // var responseNotification = http.post(
    //   Uri.parse("https://fcm.googleapis.com/fcm/send"),
    //   headers: headerNotification,
    //   body: jsonEncode(officialNotificationFormat),
    // );
  }
  
  //retrieve the trips keys for online user
  //trip key= ride key request
  static void readTripKeysForOnlineUser(context)
  {
    FirebaseDatabase.instance.ref()
        .child("All Ride Request")
        .orderByChild("userName")
        .equalTo(userModelCurrentInfo!.name)
        .once()
        .then((snap)
    {
      if(snap.snapshot.value != null)
        {
          Map keysTripsId = snap.snapshot.value as Map;

          //count total trips and share with Provider
          int overAllTripCounter = keysTripsId.length;
          Provider.of<AppInfo>(context, listen: false).updateOverAllTripCounter(overAllTripCounter);

          //share trips keys with Provider
          List<String> tripsKeysList = [];
          keysTripsId.forEach((key, value)
          {
            tripsKeysList.add(key);
          });
          Provider.of<AppInfo>(context, listen: false).updateOverAllTripsKeys(tripsKeysList);

          //get trips keys data
          readTripsHistoryInformation(context);
        }
    });
  }

  static void readTripsHistoryInformation(context)
  {
    var tripsAllKeys = Provider.of<AppInfo>(context, listen: false).historyTripsKeysList;

    for (String eachKey in tripsAllKeys)
      {
        FirebaseDatabase.instance.ref()
            .child("All Ride Request")
            .child(eachKey)
            .once()
            .then((snap)
        {
          var eachTripHistory = TripsHistoryModel.fromSnapshot(snap.snapshot);

          if((snap.snapshot.value as Map)["status"] == "ended")
            {
              //update each trip history to OverAllTrips History Data List
              Provider.of<AppInfo>(context, listen: false).updateOverAllTripsHistoryInformation(eachTripHistory);
            }
        });
      }
  }
}