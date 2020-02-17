import 'package:flutter/material.dart';
import 'package:reading_retention_tool/screens/CategoriseHighlightScreen.dart';
import 'package:reading_retention_tool/screens/CategoryHighlightsScreen.dart';
import 'package:reading_retention_tool/screens/CreateNotificationPage.dart';
import 'package:reading_retention_tool/screens/GetStartedScreen.dart';
import 'package:reading_retention_tool/screens/HighlightOfTheDayScreen.dart';
import 'package:reading_retention_tool/screens/HomeScreen.dart';
import 'package:reading_retention_tool/screens/KindleHighlightsSync.dart';
import 'package:reading_retention_tool/screens/ManageCategory.dart';
import 'package:reading_retention_tool/screens/ShowRetrievedHighlightsScreen.dart';
import 'package:reading_retention_tool/screens/SignInScreen.dart';
import 'package:reading_retention_tool/screens/SignUpScreen.dart';
import 'package:reading_retention_tool/screens/UndefinedScreen.dart';
import 'package:reading_retention_tool/screens/UserBooksListScreen.dart';
import 'package:reading_retention_tool/screens/WaitingToLoginScreen.dart';
import 'package:reading_retention_tool/screens/WelcomePage.dart';
import 'package:reading_retention_tool/screens/ResetPasswordScreen.dart';
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
            ShowRetrievedHightlightsScreen(arguments['bookName']));

      case UserBooksListRoute :
        return MaterialPageRoute(builder: (context) => UserBooksListScreen());

      case CategoryRoute :
        return MaterialPageRoute(builder: (context) => CategoriseHighlightScreen());

      case HighlightOfTheDayRoute :
        var payload = settings.arguments;
        return MaterialPageRoute(builder: (context) => HighlightOfTheDayScreen(payload));

      case CategoryHighlightsRoute :
        var categoryId = settings.arguments;
        return MaterialPageRoute(builder: (context) => CategoryHighlightsScreen(categoryId));

      case SignInRoute :
        return MaterialPageRoute(builder: (context) => SignInScreen());

      case SignUpRoute :
        return MaterialPageRoute(builder: (context) => SignUpScreen());

      case UserBooksListRoute :
        return MaterialPageRoute(builder: (context) => UserBooksListScreen());

      case ManageCategoryRoute :
        return MaterialPageRoute(builder: (context) => ManageCategory());

      case ResetPasswordRoute :
        return MaterialPageRoute(builder: (context) => ResetPasswordScreen());

      case CreateNotificationRoute :
        var data = settings.arguments;
        return MaterialPageRoute(builder: (context) => CreateNotificationPage(data));

      case WaitingToLoginRoute :
        return MaterialPageRoute(builder: (context) => WaitingToLoginScreen());

      default:
        return MaterialPageRoute(builder: (context) => UndefinedScreen());
    }

}


