import 'package:flutter/material.dart';
import 'package:reading_retention_tool/constants/constants.dart';

class CustomHighlightTile extends StatelessWidget {
  const CustomHighlightTile({
    Key key,
    @required this.icon,
    @required this.text,
    this.popMenu
  }) : super(key: key);

  final Icon icon;
  final String text;
  final PopupMenuButton popMenu;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
          children: <Widget>[
            Positioned(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: icon,
              ),
              top: 5.0,
            ),
            Container(
              padding: EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 30.0),
              width: MediaQuery.of(context).size.width*0.8,
              child: Align(
                child: Text(
                  text,
                  style: TextStyle(color: kDarkColorBlack),
                  maxLines: 300,
                  softWrap: true,
                ),
                alignment: Alignment.center,
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: popMenu
            ),
          ]
      ),
    );
  }
}
