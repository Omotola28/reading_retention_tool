import 'package:flutter/material.dart';
import 'package:reading_retention_tool/screens/AddBookScreen.dart';
import 'package:reading_retention_tool/screens/BookmarkHighlightScreen.dart';
import 'package:reading_retention_tool/screens/CategoriseHighlightScreen.dart';
import 'package:reading_retention_tool/screens/CategoryHighlightsScreen.dart';
import 'package:reading_retention_tool/screens/GetStartedScreen.dart';
import 'package:reading_retention_tool/screens/HighlightOfTheDayScreen.dart';
import 'package:reading_retention_tool/screens/HomeScreen.dart';
import 'package:reading_retention_tool/screens/InstapaperBookmarkScreen.dart';
import 'package:reading_retention_tool/screens/KindleHighlightsSyncScreen.dart';
import 'package:reading_retention_tool/screens/ManageCategory.dart';
import 'package:reading_retention_tool/screens/ManualEditHighlightScreen.dart';
import 'package:reading_retention_tool/screens/ManualHighlightBookShelfScreen.dart';
import 'package:reading_retention_tool/screens/MediumHighlightsSyncScreen.dart';
import 'package:reading_retention_tool/screens/ShowRetrievedHighlightsScreen.dart';
import 'package:reading_retention_tool/screens/SignInScreen.dart';
import 'package:reading_retention_tool/screens/SignUpScreen.dart';
import 'package:reading_retention_tool/screens/SpecificManualBookScreen.dart';
import 'package:reading_retention_tool/screens/UndefinedScreen.dart';
import 'package:reading_retention_tool/screens/UserBooksListScreen.dart';
import 'package:reading_retention_tool/screens/WaitingToLoginScreen.dart';
import 'package:reading_retention_tool/screens/WelcomePage.dart';
import 'package:reading_retention_tool/screens/ResetPasswordScreen.dart';
import 'package:reading_retention_tool/constants/route_constants.dart';
import 'package:reading_retention_tool/screens/ManualHighlightScreen.dart';


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
        var whichService = settings.arguments;
        return MaterialPageRoute(builder: (context) => CategoriseHighlightScreen(whichService));

      case HighlightOfTheDayRoute :
        var payload = settings.arguments;
        return MaterialPageRoute(builder: (context) => HighlightOfTheDayScreen(payload));

      case CategoryHighlightsRoute :
        var categoryId = settings.arguments;
        return MaterialPageRoute(builder: (context) => CategoryHighlightsScreen(categoryId));

      case MediumHighlightsSyncRoute :
        var payload = settings.arguments;
        return MaterialPageRoute(builder: (context) => MediumHighlightsSyncScreen(payload));

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

      case InstapaperBookmarksRoute :
        return MaterialPageRoute(builder: (context) => InstapaperBookmarkScreen());

      case BookmarkHighlightRoute :
        var bookmarkId = settings.arguments;
        return MaterialPageRoute(builder: (context) => BookmarkHighlightScreen(bookmarkId));

      case ManualHighlightRoute :
        return MaterialPageRoute(builder: (context) => ManualHighlightScreen());

      case ManualEditHighlightRoute :
        var formData = settings.arguments;
        return MaterialPageRoute(builder: (context) => ManualEditHighlightScreen(formData));

      case AddBookRoute :
        var formData = settings.arguments;
        return MaterialPageRoute(builder: (context) => AddBookScreen(formData));

      case ManualHighlightBookShelfRoute :
        return MaterialPageRoute(builder: (context) => ManualHighlightBookShelfScreen());

      case SpecificManualBookRoute :
        var bookData = settings.arguments;
        return MaterialPageRoute(builder: (context) => SpecificManualBookScreen(bookData));

      case WaitingToLoginRoute :
        return MaterialPageRoute(builder: (context) => WaitingToLoginScreen());

      default:
        return MaterialPageRoute(builder: (context) => UndefinedScreen());
    }

}


