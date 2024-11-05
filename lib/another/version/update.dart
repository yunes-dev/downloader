import 'package:download_every_thing/another/classes/components/components.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class VersionCheckPage extends StatelessWidget {
  const VersionCheckPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
            //padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
          gradient: Components().gradient,
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(255, 88, 86, 86).withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        )),
        title: const Text(
          "تحديث التطبيق",
          textAlign: TextAlign.right,
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'يتوفر اصدار حديث لهذا التطبيق :',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ButtonStyle(
                  fixedSize: MaterialStateProperty.all(Size.infinite),
                  backgroundColor:
                      MaterialStateProperty.all(Components().lightColor)),
              onPressed: () async {
                try {
                  await launch(
                    "https://play.google.com/store/apps/details?id=com.mc_downloader22",
                    enableJavaScript: true,
                  );
                } catch (e) {
                  print(e);
                }
              },
              child: const Text(
                'تحديث',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
