import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  final String title;
  // final Icon trailing;
  final Function()? onTap;
  const CustomListTile(
      {required this.title, this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      title: Text(
        title,
        style: TextStyle(),
      ),
      trailing: const Icon(Icons.arrow_forward_ios),
    );
  }
}
