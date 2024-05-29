import 'package:firebase_auth/firebase_auth.dart';
import 'package:users_app/models/user_model.dart';

import '../models/direction_details_info.dart';



final FirebaseAuth fAuth = FirebaseAuth.instance;
User? currentFirebaseUser;
Usermodel? userModelCurrentInfo;
List dList = []; //active driver list : key info
DirectionDetailsInfo? tripDirectionDetailsInfo;
String? chosenDriverId="";
String cloudMessagingServerToken = "key=AAAAE38DC38:APA91bGvuKUVRkGsuG0130abVZ-fjSBHH1_aYMz7gI2M9y1-I8RySC4puEHHOddWzdl0KCeSqOohRzfLwbwqhL1D28otsRhNiQP8M1WVTf3vx0UeeU7Ac0VrkCKz4OTN9WN73HELYrid";
String userDropOffAddress = "";
String driverCarDetails="";
String driverName="";
String driverPhone="";
double countRatingStars = 0.0;
String titleStarsRating="";