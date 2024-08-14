// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../classes/components/components.dart';
import '../tabsWebVewPop/providerTabPop.dart';

// ignore: must_be_immutable
class BrowsecSetting extends StatelessWidget {
  String title;
  BrowsecSetting({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    Components components = Components();
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
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
        ),
        body: Consumer<ProviderTabPop>(builder: (context, provider, child) {
          return Container(
            padding: const EdgeInsets.all(7),
            child: Column(
              children: [
                _Browsec(
                    onTap: () {},
                    check: Checkbox(
                      value: provider.pubTab,
                      onChanged: (value) {
                        provider.setPlivage(value!, provider.adsWebShow!);
                        print(provider.pubTab);
                      },
                    ),
                    title: "منع النوافذ المنبثقة"),
                _Browsec(
                    onTap: () {},
                    check: Checkbox(
                      value: provider.adsWebShow,
                      onChanged: (value) {
                        provider.setPlivage(provider.pubTab!, value!);
                        print(provider.pubTab);
                      },
                    ),
                    title: "تشغيل مانع الاعلانات"),
              ],
            ),
          );
        }));
  }
}

// ignore: must_be_immutable
class _Browsec extends StatelessWidget {
  Function()? onTap;
  Widget check;
  String title;
  _Browsec(
      {super.key,
      required this.onTap,
      required this.check,
      required this.title});

  @override
  Widget build(BuildContext context) {
    return Card(
        child: ListTile(
      onTap: onTap,
      trailing: check,
      title: Text(
        title,
        style: TextStyle(
            fontSize: 15.0, fontWeight: FontWeight.bold, fontFamily: 'Air'),
        //   textAlign: TextAlign.center,
      ),
    ));
  }
}
