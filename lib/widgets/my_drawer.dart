import 'package:flutter/material.dart';
import 'package:users_app/global/global.dart';
import 'package:users_app/mainScreen/about_screen.dart';
import 'package:users_app/mainScreen/monthly_hourly_basis.dart';
import 'package:users_app/mainScreen/profile_screen.dart';
import 'package:users_app/mainScreen/schedule_ride.dart';
import 'package:users_app/mainScreen/trips_history_screen.dart';
import 'package:users_app/models/trips_history_model.dart';
import 'package:users_app/splashScreen/splash_screen.dart';


class MyDrawer extends StatefulWidget
{
  String? name;
  String? email;

  MyDrawer({this.name, this.email});
  @override
  State<MyDrawer> createState() => _MyDrawerState();
}



class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context)
  {
    return Drawer(
      backgroundColor: Colors.orangeAccent,
      child: ListView(
        children: [
          //drawer header
          Container(
            height: 200,
            color: Colors.black,
            child: DrawerHeader(
              decoration: const BoxDecoration(color: Colors.purple),
              child: Row(
                children: [
                  const Icon(
                    Icons.person,
                    size: 40,
                    color: Colors.black,
                  ),

                  const SizedBox(width: 16,),

                  Expanded(
                    
                    child: Column(

                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.name.toString(),
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10,),
                        Text(
                          widget.email.toString(),
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),


          const SizedBox(height: 12.0,),

          //drawer body
          GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (c)=> TripsHistoryScreen()));
            },
            child: const ListTile(
              leading: Icon(Icons.history, color: Colors.black,),
              title: Text(
                "History",
                style: TextStyle(
                  color: Colors.black
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (c)=> UpCommingTripScreen()));
            },
            child: const ListTile(
              leading: Icon(Icons.schedule, color: Colors.black,),
              title: Text(
                "Schedule Ride",
                style: TextStyle(
                  color: Colors.black
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (c)=> UserScreen()));
            },
            child: const ListTile(
              leading: Icon(Icons.calendar_month, color: Colors.black,),
              title: Text(
                "Monthly/Hourly Basis Car Rent",
                style: TextStyle(
                  color: Colors.black
                ),
              ),
            ),
          ),

          GestureDetector(
            onTap: ()
            {
              Navigator.push(context, MaterialPageRoute(builder: (c)=> ProfileScreen()));
            },
            child: const ListTile(
              leading: Icon(Icons.person, color: Colors.black,),
              title: Text(
                "Visit Profile",
                style: TextStyle(
                    color: Colors.black
                ),
              ),
            ),
          ),

          GestureDetector(
            onTap: ()
            {
              Navigator.push(context, MaterialPageRoute(builder: (c)=> AboutScreen()));
            },
            child: const ListTile(
              leading: Icon(Icons.info, color: Colors.black,),
              title: Text(
                "About",
                style: TextStyle(
                    color: Colors.black
                ),
              ),
            ),
          ),

          GestureDetector(
            onTap: (){
              fAuth.signOut();
              Navigator.push(context, MaterialPageRoute(builder: (c)=> const MySplashScreen()));
            },
            child: const ListTile(
              leading: Icon(Icons.logout, color: Colors.black,),
              title: Text(
                "Sign Out",
                style: TextStyle(
                    color: Colors.black
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
