import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:reading_retention_tool/constants/constants.dart';
import 'package:reading_retention_tool/constants/route_constants.dart';
import 'package:reading_retention_tool/screens/KindleHighlightsSync.dart';
import 'package:reading_retention_tool/custom_widgets/ShowMediumDialog.dart';
import 'package:reading_retention_tool/custom_widgets/ShowInstapaperDialog.dart';
import 'package:provider/provider.dart';
import 'package:reading_retention_tool/module/app_data.dart';

class ServiceSync extends StatefulWidget {

  final Widget thumbnail;
  final String title;
  final String subtitle;
  final String screen;

  ServiceSync(this.thumbnail, this.title, this.subtitle, this.screen);


  @override
  _ServiceSyncState createState() => _ServiceSyncState();
}

class _ServiceSyncState extends State<ServiceSync> {

  var isBookmarkSynced = false;
  var isMediumSynced = false;

  Future<bool> _isBookmarksSynced() async {
    var data =  await Firestore.instance
        .collection('instapaperbookmarks')
        .document(Provider.of<AppData>(context, listen: false).userData.id)
        .get();

    if(data.exists){
      setState(() {
        isBookmarkSynced = true;
      });
    }
    else{
      setState(() {
        isBookmarkSynced = false;
      });
    }

    return isBookmarkSynced;
  }

  Future<bool> _isMediumSynced() async {
    var data =  await Firestore.instance
        .collection('medium')
        .document(Provider.of<AppData>(context, listen: false).userData.id)
        .get();

    if(data.exists){
      setState(() {
        isMediumSynced = true;
      });
    }
    else{
      setState(() {
        isMediumSynced = false;
      });
    }

    return isMediumSynced;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        switch (widget.screen) {
          case 'kindle':
            {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context)
                => KindleHighlightsSync()
                ),
              );
            }
            break;

          case 'medium':
            {
              _isMediumSynced().then((val){
                if(!val){
                  showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (_) {
                        return ShowMediumDialog();
                      });
                }
                else{
                  Navigator.pushNamed(context, MediumHighlightsSyncRoute, arguments: 'success');
                }
              });


            }
            break;

          case 'instapaper':
            {

              _isBookmarksSynced().then((val){
                if(!val){
                  showDialog(
                      context: context,
                      builder: (_) {
                        return ShowInstapaperDialog();
                      });
                }
                else{
                  Navigator.pushNamed(context, InstapaperBookmarksRoute);
                }
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
                  child: widget.thumbnail,
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
                              '${widget.title}',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0
                              ),
                            ),
                            const Padding(padding: EdgeInsets.only(bottom: 2.0)),
                            Text(
                              '${widget.subtitle}',
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




/*
Future<bool> showMediumDialog(BuildContext context){




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
                        Provider.of<AppData>(context, listen: false).setMeduimUserName(null);
                    else
                        Provider.of<AppData>(context, listen: false).setMeduimUserName(_mediumUsername.text);

                    try {

                     dynamic resp = await callable.call(<String, dynamic>{
                        'name': _mediumUsername.text,
                        'uid': Provider.of<AppData>(context, listen: false).userData.id
                      });



                      print(resp.data);
                      Navigator.pushNamed(context, MediumHighlightsSyncRoute, arguments: resp.data);

                    } catch (e, s) {
                      print(e);
                      print(s);
                    }


               },
          ),
        ]
        );
      }
  );
}*/
