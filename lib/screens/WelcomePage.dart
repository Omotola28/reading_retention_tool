import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:reading_retention_tool/screens/GetStartedScreen.dart';
import 'package:flutter/scheduler.dart';
import 'package:reading_retention_tool/constants/constants.dart';


class WelcomePage extends StatefulWidget {


  @override
  _WelcomePage createState() => _WelcomePage();
}

class _WelcomePage extends State<WelcomePage> {

  @override
  void initState(){
    super.initState();
    //This function loadGetStartedScreen should be called when this screen shows after 3 secs
    SchedulerBinding.instance.addPostFrameCallback((_) => loadGetStartedScreen());
  }

  void loadGetStartedScreen(){
    Future.delayed(Duration(seconds: 3), () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context)
        => GetStartedScreen()
        ),
      );

    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset('Images/quotd.png'),
              SpinKitDoubleBounce(
                color: kHighlightColorGrey,
                size: 50.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}


