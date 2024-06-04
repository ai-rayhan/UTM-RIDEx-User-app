import 'package:flutter/material.dart';
class CustomContainer extends StatelessWidget {
  const CustomContainer({super.key, required this.child, this.bgColor});
final Widget child;
final Color? bgColor;
  @override
  Widget build(BuildContext context) {
    return 
Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: bgColor??Color.fromARGB(57, 255, 255, 255),
                           border: Border.all(width: 1,color: Colors.white60),
                            borderRadius: BorderRadius.circular(15)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 10),
                            child:child));
  }
}