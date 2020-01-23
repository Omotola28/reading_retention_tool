import 'package:flutter/material.dart';
import 'package:reading_retention_tool/constants/constants.dart';

class TextAndDivider extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(child: Text('Colors', style: TextStyle(color: kHighlightColorDarkGrey),)),
        Expanded(
          child: Divider(
            thickness: 1.5,
          ),
        ),
        Expanded(
          child: Divider(
            thickness: 1.5,
          ),
        ),
        Expanded(
          child: Divider(
            thickness: 1.5,
          ),
        ),
        Expanded(
          child: Divider(
            thickness: 1.5,
          ),
        ),
        Expanded(
          child: Divider(
            thickness: 1.5,
          ),
        ),

      ],
    );
  }
}
