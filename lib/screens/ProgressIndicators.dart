import 'package:flutter/material.dart';
import 'package:reading_retention_tool/constants/constants.dart';

Container circularProgressIndicator(){
  return Container(
    alignment: Alignment.center,
    padding: EdgeInsets.only(top: 10.0),
    child: CircularProgressIndicator(valueColor : AlwaysStoppedAnimation(kPrimaryColor)),
  );
}

Container linearProgressIndicator(){
  return Container(
    padding: EdgeInsets.only(bottom: 10.0),
    child: LinearProgressIndicator(valueColor: AlwaysStoppedAnimation(kPrimaryColor)),
  );
}