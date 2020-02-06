import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:reading_retention_tool/constants/route_constants.dart';
import 'package:reading_retention_tool/screens/BookSpecificHighlightScreen.dart';
import 'package:reading_retention_tool/screens/CategoryScreen.dart';
import 'package:reading_retention_tool/screens/GetStartedScreen.dart';
import 'package:reading_retention_tool/screens/HighlightOfTheDayScreen.dart';
import 'package:reading_retention_tool/screens/HomeScreen.dart';
import 'package:reading_retention_tool/screens/KindleHighlightsSync.dart';
import 'package:reading_retention_tool/screens/MediumHighlightsScreen.dart';
import 'package:reading_retention_tool/screens/ShowRetrievedHighlightsScreen.dart';
import 'package:reading_retention_tool/screens/SignInScreen.dart';
import 'package:reading_retention_tool/screens/SignUpScreen.dart';
import 'package:reading_retention_tool/screens/UserBooksListScreen.dart';
import 'package:reading_retention_tool/screens/ResetPasswordScreen.dart';
import 'package:reading_retention_tool/screens/WelcomePage.dart';
import 'package:reading_retention_tool/module/app_data.dart';
import 'package:reading_retention_tool/service/navigation_service.dart';
import 'package:reading_retention_tool/utils/locator.dart';
import 'router.dart' as router;

void main() {

  //Was throwing error about trying to access information before the widgets were binded
  WidgetsFlutterBinding.ensureInitialized();
  //SetupLocator
  setUpLocator();


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
        navigatorKey: locator<NavigationService>().navigatorKey,
        onGenerateRoute: router.generateRoute,
        initialRoute: WelcomeScreenRoute,
      ),
    ),
  );
}


