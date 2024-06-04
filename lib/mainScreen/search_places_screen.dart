import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:users_app/assistants/request_assistant.dart';
import 'package:users_app/global/map_key.dart';
import 'package:users_app/models/predicted_places.dart';
import 'package:users_app/widgets/place_prediction_tile.dart';

class SearchPlacesScreen extends StatefulWidget
{
  const SearchPlacesScreen({Key? key}) : super(key: key);

  @override
  State<SearchPlacesScreen> createState() => _SearchPlacesScreenState();
}




class _SearchPlacesScreenState extends State<SearchPlacesScreen>
{
  List<PredictedPlaces> placePredictedList = [];

  void findPlaceAutoCompleteSearch(String inputText) async
  {
    if(inputText.length > 1) //write 2 or more char
      {
        String urlAutoCompleteSearch = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$inputText&key=$mapkey&components=country:MY";

        var responseAutoCompleteSearch = await RequestAssistant.receiveRequest(urlAutoCompleteSearch);
        log(responseAutoCompleteSearch.toString());
        if(responseAutoCompleteSearch == "Error Occurred, Failed. No response.")
          {
            return;
          }

        if(responseAutoCompleteSearch["status"] == "OK")
          {
            var placePredictions = responseAutoCompleteSearch["predictions"];

            var placePredictionsList = (placePredictions as List).map((jsonData) => PredictedPlaces.fromJson(jsonData)).toList();

            setState(() {
              placePredictedList = placePredictionsList;
            });
          }
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.black,
      body: Column(
        children: [
          //search place UI
          Container(
            height: 160,
            decoration: const BoxDecoration(
              // color: Colors.black54,
              boxShadow: [
                BoxShadow(
                  color: Colors.orange,
                  blurRadius: 8,
                  spreadRadius: 0.5,
                  offset: Offset(
                    0.7,
                    0.7,
                  ),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [

                  const SizedBox(height: 25.0,),

                  Stack(
                    children: [
                      GestureDetector(
                        onTap: ()
                        {
                          Navigator.pop(context);
                        },
                        child: const Icon(
                          Icons.arrow_back,
                          // color: Colors.black,
                        ),
                      ),

                      const Center(
                        child: Text(
                          "Search Drop off Location",
                          style: TextStyle(
                            fontSize: 18.0,
                            // color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16.0,),

                  Row(
                    children: [
                      const Icon(
                        Icons.edit_location_alt_outlined,
                        // color: Colors.black,
                      ),

                      const SizedBox(width: 18.0,),

                      Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              onChanged: (valuetype)
                              {
                                findPlaceAutoCompleteSearch(valuetype);
                              },
                            decoration: const InputDecoration(
                              hintText: "Search...",
                              fillColor: Colors.white54,
                              filled: true,
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(
                                left: 11.0,
                                top: 8.0,
                                bottom: 8.0,
                              ),
                            ),
                        ),
                          ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),

          //display place prediction result
          (placePredictedList.length > 0)
              ? Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.separated(
                      itemCount: placePredictedList.length,
                      physics: ClampingScrollPhysics(),
                      itemBuilder: (context, index)
                      {
                        return PlacePredictionTileDesign(
                          predictedPlaces: placePredictedList[index],
                        );
                      },
                      separatorBuilder: (BuildContext context, int index){
                        return const Divider(
                          height: 1,
                          color: Colors.white,
                          thickness: 1,
                        );
                      },
                    ),
                  ),
          )
              : Container(),
        ],
      ),
    );
  }
}
