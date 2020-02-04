import 'package:flutter/widgets.dart';
import 'dart:async';

import 'package:reading_retention_tool/screens/HighlightOfTheDayScreen.dart';

class NavigationService{

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<dynamic> navigateTo(String routename, {dynamic arguments }){
    return navigatorKey.currentState.pushNamed(routename, arguments: arguments );
  }

  bool goBack(){
    return navigatorKey.currentState.pop();
  }


}