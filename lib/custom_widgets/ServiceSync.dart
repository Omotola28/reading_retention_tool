import 'package:flutter/material.dart';
import 'package:reading_retention_tool/constants/constants.dart';
import 'package:provider/provider.dart';
import 'package:reading_retention_tool/module/app_data.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:reading_retention_tool/screens/MediumHighlightsScreen.dart';

class ServiceSync extends StatelessWidget {
  ServiceSync({
    Key key,
    this.thumbnail,
    this.title,
    this.subtitle,
    this.screen,
  }) : super(key: key);

  final Widget thumbnail;
  final String title;
  final String subtitle;
  final String screen;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        switch (screen) {
          case 'kindle_highlights_sync_screen':
            {
              Navigator.pushNamed(context, screen);
            }
            break;

          case 'medium':
            {
              showMediumDialog(context).then((val){
                //TODO:clear value set in medium name
                print("MEDIUM ${Provider.of<AppData>(context).mediumUsername}");
              });
            }
            break;

          case 'Delete':
            {

            }
            break;

          default:
            break;
        }

      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: SizedBox(
          height: 100,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: kHighlightColorGrey,
                      blurRadius: 6.0, // has the effect of softening the shadow
                      spreadRadius: 1.0, // has the effect of extending the shadow
                      offset: Offset(
                        1.0, // horizontal, move right 10
                        1.0, // vertical, move down 10
                      ),
                    )
                  ],
                ),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: thumbnail,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 0.0, 2.0, 0.0),
                  child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            '$title',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0
                            ),
                          ),
                          const Padding(padding: EdgeInsets.only(bottom: 2.0)),
                          Text(
                            '$subtitle',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12.0,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

Future<bool> showMediumDialog(BuildContext context){


  final _mediumUsername = TextEditingController(text: '@username');
  FocusNode _focusNode = FocusNode();

  _focusNode.addListener((){
      if (_focusNode.hasFocus) _mediumUsername.clear();
  });

  final HttpsCallable callable = CloudFunctions.instance.getHttpsCallable(
    functionName: 'syncMedium',
  );

  return showDialog(context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Image.asset(
            "Images/medium.png",
            height: 50,
            width: 50,
          ),
          content: TextFormField(
              validator: (value) => value.isEmpty ? 'Please enter your username' : null,
              decoration: InputDecoration(
                labelText: 'Enter medium username',
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: kPrimaryColor,width: 2.0)),
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: kPrimaryColor,width: 3.0)),
              ),
              controller: _mediumUsername,
              focusNode: _focusNode,
              style: TextStyle(color: Colors.grey),

              onTap: () {

              }),
          actions: <Widget>[
               FlatButton(
                    color: kPrimaryColor,
                    child: Text(
                      'Sync Highlights',
                      style: kHeadingTextStyleDecoration.copyWith(color: Colors.white),
                ),
               onPressed: () async {
                    if(_mediumUsername.text == '@username')
                        Provider.of<AppData>(context).setMeduimUserName(null);
                    else
                        Provider.of<AppData>(context).setMeduimUserName(_mediumUsername.text);

                    dynamic resp = await callable.call(<String, dynamic>{
                      'name': _mediumUsername.text,
                      'uid': Provider.of<AppData>(context).uid
                    });

                    print(resp.data);
                   // Navigator.popAndPushNamed(context, MediumHighlightsScreen.id);

               },
          ),
        ]
        );
      }
  );
}