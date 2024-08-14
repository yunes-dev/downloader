import 'package:download_every_thing/another/boarding/onbording.dart';
import 'package:download_every_thing/another/classes/components/components.dart';
import 'package:download_every_thing/another/homeScreen/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashApp extends StatefulWidget {
  const SplashApp({super.key});

  @override
  State<SplashApp> createState() => _SplashAppState();
}

class _SplashAppState extends State<SplashApp>
    with SingleTickerProviderStateMixin {
  bool showBoarding = false;
  getDataOFBoarding() async {
    print('**************************');
    SharedPreferences pref = await SharedPreferences.getInstance();
    showBoarding = await pref.getBool('boarding') ?? false;
    setState(() {});
    print(showBoarding);
  }

  @override
  void initState() {
    super.initState();
    getDataOFBoarding();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    Future.delayed(
      Duration(seconds: 3),
      () {
        Components().pushReplce(
            showBoarding == true ? HomeScreen() : Onbording(), context);
      },
    );
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 246, 126, 27),
            Color.fromARGB(255, 100, 2, 2)
          ],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          //  stops: [0.0, 1.0],
          //tileMode: TileMode.clamp
        )),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(100.0)),
              child: Image.asset(
                "assets/images/logo.png",
                width: 150.0,
                height: 150.0,
              ),
            ),
            Text(
              "محمل الملفات MC",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w900),
            )
          ],
        ),
      ),
      bottomSheet: Text("medeBy@metacode-2023"),
    );
  }
}
