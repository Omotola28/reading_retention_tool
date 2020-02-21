import 'package:flutter/material.dart';
import 'package:reading_retention_tool/constants/constants.dart';


class SocialMediaButtons extends StatelessWidget {

  SocialMediaButtons({@required this.icon, @required this.onTap});

  final IconData icon;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(side: BorderSide(
        width: 2.0,
        color: kPrimaryColor,
      ),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: InkWell(
        splashColor: Colors.white.withAlpha(30),
        onTap: onTap,
        child: Container(
          width: 290,
          height: 50,
          child: Icon(
            icon,
            color: kDarkSocialBtnColor,
          ),
        ),
      ),
    );
  }
}
