import 'package:flutter/material.dart';
import 'package:reading_retention_tool/screens/CategoryScreen.dart';
import 'package:reading_retention_tool/screens/GetStartedScreen.dart';
import 'package:reading_retention_tool/screens/HighlightOfTheDayScreen.dart';
import 'package:reading_retention_tool/screens/HomeScreen.dart';
import 'package:reading_retention_tool/screens/KindleHighlightsSync.dart';
import 'package:reading_retention_tool/screens/ShowRetrievedHighlightsScreen.dart';
import 'package:reading_retention_tool/screens/SignInScreen.dart';
import 'package:reading_retention_tool/screens/SignUpScreen.dart';
import 'package:reading_retention_tool/screens/UndefinedScreen.dart';
import 'package:reading_retention_tool/screens/UserBooksListScreen.dart';
import 'package:reading_retention_tool/screens/WelcomePage.dart';
import 'package:reading_retention_tool/constants/route_constants.dart';


Route<dynamic> generateRoute(RouteSettings settings){

    switch(settings.name){
      case WelcomeScreenRoute :
        return MaterialPageRoute(builder: (context) => WelcomePage());

      case HomeScreenRoute :
        return MaterialPageRoute(builder: (context) => HomeScreen());

      case GetStartedScreenRoute :
        return MaterialPageRoute(builder: (context) => GetStartedScreen());

      case KindleHighlightsSyncRoute :
        return MaterialPageRoute(builder: (context) => KindleHighlightsSync());

      case ShowRetrievedHightlightsRoute:

        Map<String,dynamic> arguments = settings.arguments;

        return MaterialPageRoute(builder: (context) =>
            ShowRetrievedHightlightsScreen(arguments['highlightObj'], arguments['bookName']));

      case UserBooksListRoute :
        return MaterialPageRoute(builder: (context) => UserBooksListScreen());

      case CategoryRoute :
        return MaterialPageRoute(builder: (context) => CategoryScreen());

      case HighlightOfTheDayRoute :
        var payload = settings.arguments;
        return MaterialPageRoute(builder: (context) => HighlightOfTheDayScreen(payload));

      case SignInRoute :
        return MaterialPageRoute(builder: (context) => SignInScreen());

      case SignUpRoute :
        return MaterialPageRoute(builder: (context) => SignUpScreen());

      default:
        return MaterialPageRoute(builder: (context) => UndefinedScreen());
    }

}


/*const String WelcomeScreenRoute = 'welcome_screen';
const String HomeScreenRoute = 'home_screen';
const String GetStartedScreenRoute = 'getstarted_screen';
const String KindleHighlightsSyncRoute = 'kindle_highlights_sync_screen';
const String MediumHighlightsRoute = 'medium_highlights_screen';
const String ShowRetrievedHightlightsRoute = 'show_retrieved_highlights_screen';
const String UserBooksListRoute = 'user_booklist_screen';
const String CategoryRoute = 'category_screen';
const String HighlightOfTheDayRoute = 'highlight_of_the_day_screen';
const String SignInRoute = 'signIn_screen';
const String SignUpRoute = 'signUp_screen';*/
