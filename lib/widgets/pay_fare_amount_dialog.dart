import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:users_app/assistants/schedule_service.dart';

class PayFareAmountDialog extends StatefulWidget
{
  double? fareAmount;
  String? driverId;

  PayFareAmountDialog({ this.fareAmount,this.driverId});

  @override
  State<PayFareAmountDialog> createState() => _PayFareAmountDialogState();
}




class _PayFareAmountDialogState extends State<PayFareAmountDialog>
{
  String qrCodeUrl='';
  @override
  void initState() {
   loadRiderData();
    super.initState();
  }
   loadRiderData()async{
   qrCodeUrl= await getRiderdetails(widget.driverId);
   setState(() {
     
   });
  }
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      backgroundColor: Colors.grey,
      child: Container(
        margin: const EdgeInsets.all(6),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            const SizedBox(height: 20,),

            Text(
              "Fare Amount".toUpperCase(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 20,),

            const Divider(
              thickness: 4,
              color: Colors.grey,
            ),

            const SizedBox(height: 16,),

            Text(
              widget.fareAmount.toString(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
                fontSize: 50,
              ),
            ),

            const SizedBox(height: 10,),

            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "This is the total trip fare amount, Please Pay to driver",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ),
            qrCodeUrl!=''?Image.network(qrCodeUrl,height: 120,width: 150,fit: BoxFit.cover,):Container(),

            const SizedBox(height: 10,),

            Padding(
              padding: const EdgeInsets.all(18.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
                  onPressed: ()
                  {
                    Future.delayed(const Duration(milliseconds: 2000), ()
                    {
                      Navigator.pop(context, "cashPayed");
                    });
                  },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Pay",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                     Text(
                       "RM " + widget.fareAmount!.toString(),
                       style: const TextStyle(
                         fontSize: 20,
                         color: Colors.white,
                         fontWeight: FontWeight.bold,
                       ),
                     ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 4,),


          ],
        ),
      ),
    );
  }
}
