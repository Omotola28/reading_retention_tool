import 'package:flutter/widgets.dart';
import 'dart:async';


class NavigationService{

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<dynamic> navigateTo(String routename, {dynamic arguments }){
    return navigatorKey.currentState.pushNamed(routename, arguments: arguments );
  }

  bool goBack(){
    return navigatorKey.currentState.pop();
  }


}