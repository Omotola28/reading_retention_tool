import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:reading_retention_tool/constants/constants.dart';
import 'package:reading_retention_tool/constants/route_constants.dart';
import 'package:reading_retention_tool/custom_widgets/AppBar.dart';
import 'package:reading_retention_tool/screens/HomeScreen.dart';
import 'package:reading_retention_tool/screens/ProgressIndicators.dart';
import 'package:provider/provider.dart';
import 'package:reading_retention_tool/module/app_data.dart';
import 'package:reading_retention_tool/custom_widgets/CustomHighlightTile.dart';
import 'package:reading_retention_tool/customIcons/my_flutter_app_icons.dart';
import 'package:reading_retention_tool/utils/color_utility.dart';


class MediumHighlightsSyncScreen extends StatefulWidget {

  final String payload;

  MediumHighlightsSyncScreen(this.payload);

  @override
  _MediumHighlightsSyncScreenState createState() => _MediumHighlightsSyncScreenState();
}

class _MediumHighlightsSyncScreenState extends State<MediumHighlightsSyncScreen> {

  var message;
  var highlights = [];

  @override
  void initState() {
    super.initState();

    setState(() {
      message = widget.payload;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  header(headerText: 'Medium Highlights', context: context , screen: HomeScreen() ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            message != 'success' ? Center(child: Container(child:circularProgressIndicator() ,),)

                : Expanded(
                  child: StreamBuilder(
                  stream: Firestore.instance
                      .collection('medium')
                      .document(Provider.of<AppData>(context, listen: false).userData.id)
                      .snapshots(),
                  builder: (context, snapshot) {
                    List<Widget> widgetHighlights = [];
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      highlights = snapshot.data['mediumHighlights'];



                      for (var index = 0; index < highlights.length; index++) {

                        final highlightWidget =
                        Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Card(
                            color: Color.fromRGBO(250, 249, 242, 1),

                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                CustomHighlightTile(
                                  icon: Icon(CustomIcons.circle, size: 8.0, color: HexColor(highlights[index]['color'])),
                                  text: highlights[index]['highlight'],

                                )
                              ],
                            ),
                          ),
                        );

                        widgetHighlights.add(highlightWidget);
                      }


                    }
                    return ListView.builder(
                        itemCount: snapshot.data['mediumHighlights'].length == null ? 0 : snapshot.data['mediumHighlights'].length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: widgetHighlights[index],
                          );
                        });
                  }),
                )
          ],
        ),
      )
    );
  }
}



/*
*/


/*
FutureBuilder (
future:  _getKindleHighlights(),
builder: (context, snapshot) {
List<Widget> widgetHighlights = [];

if(userHasData)  {

List highlights = snapshot.data['highlights'];

_saveNoOfHighlights(highlights.length);
if(highlights.isEmpty){
return Container(
child: Center(
child: Column(
mainAxisAlignment: MainAxisAlignment.center,
crossAxisAlignment: CrossAxisAlignment.center,
children: <Widget>[
Image.asset(
'Images/notfound.png',
),
Text('No Highlights Extracted',
style: TextStyle(
color: kDarkColorBlack),
),
],
)


),
);
}
else{
for (var index = 0; index < highlights.length; index++) {

var cleanseText = highlights[index]['highlight'].replaceAll(new RegExp(r' - '), '');
final highlightWidget =
Padding(
padding: const EdgeInsets.all(10.0),
child: Card(
child: Column(
mainAxisSize: MainAxisSize.min,
children: <Widget>[
ListTile(
contentPadding: EdgeInsets.all(20.0),
subtitle: Text(cleanseText),
),
],
),
),
);

widgetHighlights.add(highlightWidget);
}
}

} else {
return Center(
child: CircularProgressIndicator(),
);
}
return ListView.builder(
itemCount: snapshot.data['highlights'].length == null ? 0 : snapshot.data['highlights'].length,
itemBuilder: (context, index) {
return widgetHighlights[index];
},
);
}
)*/
