import 'package:flutter/material.dart';
import 'package:reading_retention_tool/constants/constants.dart';

class ActionUserButton extends StatelessWidget {
  ActionUserButton({this.color, this.title, @required this.onPressed});

  final Color color;
  final String title;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        splashColor: Colors.white.withAlpha(30),
        onTap: onPressed,
        child: Container(
          alignment: Alignment.center,
          color: kPrimaryColor,
          width: 300,
          height: 50,
          child: Text(
            title,
            style: kHeadingTextStyleDecoration.copyWith(color: color),
          ),
        ),
      ),
    );
  }
}
