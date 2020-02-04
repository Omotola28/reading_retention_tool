import 'package:flutter/material.dart';
import 'package:share/share.dart';

class ShareHighlight{

  void share(BuildContext context, String highlightString){

    Share.share(highlightString, subject: 'Highlight from HighlightMyQuotes');
  }

}