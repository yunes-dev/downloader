import 'package:download_every_thing/another/classes/components/components.dart';
import 'package:download_every_thing/another/classes/models/aboutUsModel.dart';
import 'package:flutter/material.dart';

class ListCard extends StatelessWidget {
  AboutUsModel aboutUsModel;
  Function() onTap;
  ListCard({super.key, required this.aboutUsModel, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
        child: ListTile(
      onTap: onTap,
      leading: Icon(
        aboutUsModel.icon,
        size: 30,
        color: Components().lightColor,
      ),
      title: Text(
        aboutUsModel.name,
        style: const TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
      subtitle: Container(),
    ));
  }
}
