import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AboutScreen extends StatefulWidget
{

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen>
{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: ListView(

        children: [

          const SizedBox(height: 100,),

          //image
          Container(
            height: 230,
            child: Center(
              child: Image.asset(
                "images/logo3.png",
                width: 260,
                height: 260,
              ),
            ),
          ),

          Column(
            children: [

              //company name
              const Text(
                "UTM Ridex",
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white54,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20,),

              //about my company
              const Text(
                "UTM Ridex is a Ride Sharing Application Service in Universiti Teknologi Malaysia (UTM)."
                "Ride sharing is a way for multiple riders to get to where they are going by sharing a single vehicle that is going in their direction.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white54,
                ),
              ),

              const SizedBox(height: 10,),

              const Text(
                "UTM Ridex was developed in June 2024.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white54,
                ),
              ),

              const SizedBox(height: 30,),

              //close
              ElevatedButton(
                onPressed:()
                {
                  SystemNavigator.pop();
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple
                ),
                child: const Text(
                  "Close",
                  style: TextStyle(color: Colors.white),
                ),
              ),

            ],
          ),

        ],

      ),
    );
  }
}
