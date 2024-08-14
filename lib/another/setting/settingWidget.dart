import 'package:download_every_thing/another/classes/components/aboutUs.dart';
import 'package:download_every_thing/another/classes/components/classStaticLists.dart';
import 'package:download_every_thing/another/classes/models/aboutUsModel.dart';
import 'package:download_every_thing/another/setting/browsecSetting.dart';
import 'package:download_every_thing/another/setting/settingGeneral.dart';
import 'package:flutter/material.dart';
import '../classes/components/components.dart';

class SettingWidget extends StatelessWidget {
  const SettingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Components components = Components();
    List<AboutUsModel> listSetting = ClassStaticLists.listSetting;
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
            decoration: BoxDecoration(
          gradient: components.gradient,
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(255, 88, 86, 86).withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        )),
        title: const Text('الاعدادت',
            style: TextStyle(
              fontFamily: 'Air',
            )),
        centerTitle: true,
      ),
      body: Container(
          padding: const EdgeInsets.all(7),
          child: ListView.builder(
            itemCount: listSetting.length,
            itemBuilder: (context, index) {
              final setting = listSetting[index];
              return Column(
                children: [
                  Card(
                      child: ListTile(
                    onTap: () {
                      if (setting.id == "1") {
                        components.pushed(
                            SettingGeneral(title: setting.name), context);
                      } else if (setting.id == "2") {
                        components.pushed(
                            BrowsecSetting(title: setting.name), context);
                      } else if (setting.id == "3") {
                        components.pushed(AboutUs(), context);
                      }
                    },
                    trailing: Icon(
                      setting.icon,
                      size: 30,
                      color: Components().lightColor,
                    ),
                    title: Text(
                      setting.name,
                      style: const TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Air'),
                      //   textAlign: TextAlign.center,
                    ),
                    // subtitle: Container(),
                  ))
                ],
              );
            },
          )),
    );
  }
}
