import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:users_app/assistants/request_assistant.dart';
import 'package:users_app/global/global.dart';
import 'package:users_app/global/map_key.dart';
import 'package:users_app/infoHandler/app_info.dart';
import 'package:users_app/models/directions.dart';
import 'package:users_app/models/predicted_places.dart';
import 'package:users_app/widgets/progress_dialog.dart';


class PlacePredictionTileDesign extends StatefulWidget
{
  final PredictedPlaces? predictedPlaces;

  PlacePredictionTileDesign({this.predictedPlaces});

  @override
  State<PlacePredictionTileDesign> createState() => _PlacePredictionTileDesignState();
}

class _PlacePredictionTileDesignState extends State<PlacePredictionTileDesign> {
  getPlaceDirectionDetails(String? placeId, context) async
  {
    showDialog(context: context,
      builder: (BuildContext context) => ProgressDialog(
          message: "Setting Up Drop-Off, Please wait...",
        ),
    );

    String placeDirectionDetailsUrl = "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$mapkey";

    var responseApi = await RequestAssistant.receiveRequest(placeDirectionDetailsUrl);

    Navigator.pop(context);

    if(responseApi == "Error Occurred, Failed. No response.")
      {
        return;
      }

    if(responseApi["status"] == "OK")
      {
        Directions directions = Directions();
        directions.locationName = responseApi["result"]["name"];
        directions.locationId = placeId;
        directions.locationLatitude = responseApi["result"]["geometry"]["location"]["lat"];
        directions.locationLongitude = responseApi["result"]["geometry"]["location"]["lng"];

        print("\nlocation name =" + directions.locationName!);
        print("\nlocation lat =" + directions.locationLatitude!.toString());
        print("\nlocation log =" + directions.locationLongitude!.toString());

        Provider.of<AppInfo>(context, listen: false).updateDropOffLocationAddress(directions);

        setState(() {
          userDropOffAddress = directions.locationName!;
        });

        Navigator.pop(context, "obtainedDropoff");
      }
  }

  @override
  Widget build(BuildContext context)
  {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: ElevatedButton(
        onPressed: ()
        {
          getPlaceDirectionDetails(widget.predictedPlaces!.place_id, context);
        },
        style: ElevatedButton.styleFrom(
          // backgroundColor: Colors.white10,
        ),
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Row(
            children: [
              const Icon(
                Icons.location_on_outlined,
                // color: Colors.grey,
              ),
              const SizedBox(width: 14.0,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8.0,),
                    Text(
                      widget.predictedPlaces!.main_text!,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16.0,
                        // color: Colors.white54,
                      ),
                    ),
                    const SizedBox(height: 2.0,),
                    Text(
                      widget.predictedPlaces!.secondary_text!,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12.0,
                        // color: Colors.white54,
                      ),
                    ),
                    const SizedBox(height: 8.0,),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
