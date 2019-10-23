import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:reading_retention_tool/screens/WelcomePage.dart';

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
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
        primaryColor: Color(0xFFFFFFFF),
        backgroundColor: Colors.white,
      ),
      home: Scaffold(
        body: SafeArea(
          child: WelcomePage(),
        ),
      ),
    ),
  );
}


