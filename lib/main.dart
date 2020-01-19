import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:reading_retention_tool/screens/GetStartedScreen.dart';
import 'package:reading_retention_tool/screens/HomeScreen.dart';
import 'package:reading_retention_tool/screens/KindleHighlightsSync.dart';
import 'package:reading_retention_tool/screens/MediumHighlightsScreen.dart';
import 'package:reading_retention_tool/screens/ShowRetrievedHighlightsScreen.dart';
import 'package:reading_retention_tool/screens/SignInScreen.dart';
import 'package:reading_retention_tool/screens/SignUpScreen.dart';
import 'package:reading_retention_tool/screens/UserBooksListScreen.dart';
import 'package:reading_retention_tool/screens/WelcomePage.dart';
import 'package:reading_retention_tool/module/app_data.dart';
import 'package:reading_retention_tool/screens/UserBooksListScreen.dart';

void main() {

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
      builder: (context) => AppData(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.light().copyWith(
          primaryColor: Color(0xFFFFFFFF),
          backgroundColor: Colors.white,
        ),
        initialRoute: WelcomePage.id,
        routes: {
          WelcomePage.id : (context) => WelcomePage(),
          HomeScreen.id : (context) => HomeScreen(),
          GetStartedScreen.id : (context) => GetStartedScreen(),
          SignInScreen.id : (context) => SignInScreen(),
          SignUpScreen.id : (context) => SignUpScreen(),
          KindleHighlightsSync.id : (context) => KindleHighlightsSync(),
          MediumHighlightsScreen.id : (context) => MediumHighlightsScreen(),
          ShowRetrievedHightlightsScreen.id : (context) =>
              ShowRetrievedHightlightsScreen(Provider.of<AppData>(context).highlightObject, Provider.of<AppData>(context).bookName),
          UserBooksListScreen.id : (context) => UserBooksListScreen(),

        },
        /*home: Scaffold(
          body: SafeArea(
            child: WelcomePage(),
          ),
        ),*/
      ),
    ),
  );
}


