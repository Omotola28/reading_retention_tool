import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reading_retention_tool/customIcons/my_flutter_app_icons.dart';
import 'package:reading_retention_tool/module/app_data.dart';

class CategoryTile extends StatefulWidget {
  final String categoryTitle;
  final Color categoryColor;

  CategoryTile({this.categoryTitle, this.categoryColor});

  @override
  _CategoryTileState createState() => _CategoryTileState();
}

class _CategoryTileState extends State<CategoryTile> {


  @override
  Widget build(BuildContext context) {
    return ListTile(
       leading:  Padding(
         padding: const EdgeInsets.only(top: 6.0),
         child: Icon(
           CustomIcons.circle,
           color: widget.categoryColor,
           size: 10.0,
         ),
       ),
      title: Text(widget.categoryTitle),
      onTap: (){
         Provider.of<AppData>(context).setCategory(widget.categoryTitle, widget.categoryColor);
      },
    );
  }
}
