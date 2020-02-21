import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:reading_retention_tool/constants/constants.dart';
import 'package:reading_retention_tool/constants/route_constants.dart';
import 'package:reading_retention_tool/module/app_data.dart';
import 'package:reading_retention_tool/service/navigation_service.dart';
import 'package:reading_retention_tool/utils/locator.dart';
import 'router.dart' as router;
import 'dart:async';

void main() {

  //Was throwing error about trying to access information before the widgets were binded
  WidgetsFlutterBinding.ensureInitialized();
  //SetupLocator
  setUpLocator();

  Crashlytics.instance.enableInDevMode = true;

  // Pass all uncaught errors to Crashlytics.
  FlutterError.onError = Crashlytics.instance.recordFlutterError;


  SystemUiOverlayStyle copyWith({
    Color systemNavigationBarColor,
    Color systemNavigationBarDividerColor,
    Color statusBarColor,
    Brightness statusBarBrightness,
    Brightness statusBarIconBrightness,
    Brightness systemNavigationBarIconBrightness,
  }) {
    return SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.dark,
    );
  }

  /**
   * Setting the theme for the application the copyWith is used
   * to indicate what we would like to copy all over our app
   */
  SystemChrome.setSystemUIOverlayStyle(copyWith());

  runApp(
      ChangeNotifierProvider<AppData>(
        create: (context) => AppData(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData.light().copyWith(
            primaryColor: Color(0xFFFFFFFF),
            accentColor: kSecondaryColor,
            backgroundColor: Colors.white,
          ),
          navigatorKey: locator<NavigationService>().navigatorKey,
          onGenerateRoute: router.generateRoute,
          initialRoute: WelcomeScreenRoute,
        ),
      ),
    );



}


