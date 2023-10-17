import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

import '../styles/colors.dart';

class CustomCard extends StatelessWidget {
  final String? title;
  final Widget? subtitle;
  final String? leading;
  final String? mintitle;
  const CustomCard(
      {this.title,
      this.mintitle,
      this.subtitle,
      this.leading,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(5),
        color: mintitle == "лк."
            ? context.isDarkMode ? Colors.yellow[100]!.withOpacity(.8) : Colors.yellow[100]
            : mintitle == "лаб."
                ? context.isDarkMode ? Colors.blue[100]!.withOpacity(.8) : Colors.blue[100]
                : mintitle == "пр.з."
                    ? context.isDarkMode ? Colors.red[100]!.withOpacity(.8) : Colors.red[100]!
                    : context.isDarkMode ? Colors.white.withOpacity(.8) : Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Text(
                  leading != null ? leading! : '',
                  style:  TextStyle(fontSize: 18, color: colorText),
                ),
              ),
              Flexible(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${title}\n${mintitle != null ? mintitle : ''}",
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold, color: colorText),
                      // overflow: TextOverflow.ellipsis,
                      maxLines: 5,
                    ),
                    subtitle != null ? subtitle! : SizedBox(),
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
