import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String text;
  final bool? fontWeight;
  const CustomText(this.text, {this.fontWeight, super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(fontSize: 25, fontWeight: fontWeight == null || !fontWeight! ? FontWeight.normal : FontWeight.bold),
      textAlign: TextAlign.center,
    );
  }
}
