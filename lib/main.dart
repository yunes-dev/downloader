import 'dart:async';
import 'package:download_every_thing/fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'another/classes/components/components.dart';
import 'another/download/providerDownload.dart';
import 'another/notification/notification_utils.dart';
import 'another/splash/splash.dart';
import 'another/tabsWebVewPop/providerTabPop.dart';
import 'another/notification/notificationFirebase.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationUtils.initNotifications();
  if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
    await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(
        kDebugMode);
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  void inint() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    FlutterError.onError = (details) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(details);
    };
    PlatformDispatcher.instance.onError = (error, stackTrace) {
      FirebaseCrashlytics.instance.recordError(error, stackTrace, fatal: true);
      return true;
    };
    await ApiFireBase().inilizedFirebaseMessaging();
  }

  @override
  Widget build(BuildContext context) {
    inint();
    Components _widget = Components();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ProviderDownload()),
        ChangeNotifierProvider(create: (context) => ProviderTabPop())
      ],
      child: MaterialApp(
        themeMode: ThemeMode.light,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('ar'),
        ], // English

        locale: const Locale("ar", "AR"),
        title: 'Flutter Demo',
        theme: ThemeData(
            primarySwatch: _widget.Mcolor,
            primaryColor: Colors.white,
            scaffoldBackgroundColor: Colors.white,
            bottomNavigationBarTheme: const BottomNavigationBarThemeData(
                backgroundColor: Colors.white,
                selectedItemColor: Colors.black,
                unselectedItemColor: Colors.grey),
            colorScheme: ColorScheme.fromSwatch(
                primarySwatch: _widget.Mcolor,
                accentColor: _widget.Mcolor,
                backgroundColor: Colors.white,
                errorColor: Colors.red,
                brightness: Brightness.light),
            bottomSheetTheme:
                BottomSheetThemeData(backgroundColor: Colors.white),
            appBarTheme: const AppBarTheme(
                iconTheme: IconThemeData(color: Colors.white),
                titleTextStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontFamily: AppFontFamilies.cairoFont)),
            fontFamily: AppFontFamilies.cairoFont),
        debugShowCheckedModeBanner: false,
        home: const SplashApp(),
      ),
    );
  }
}
