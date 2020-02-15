import 'package:flutter/material.dart';
import 'package:reading_retention_tool/custom_widgets/AppBar.dart';
import 'ProgressIndicators.dart';

class WaitingToLoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(implyLeading: false),
      body: SafeArea(
        child: Container(
          child: linearProgressIndicator()
        ),
      ),
    );
  }
}
