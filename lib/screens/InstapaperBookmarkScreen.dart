import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:reading_retention_tool/constants/constants.dart';
import 'package:reading_retention_tool/constants/route_constants.dart';
import 'package:reading_retention_tool/custom_widgets/AppBar.dart';
import 'package:reading_retention_tool/screens/HomeScreen.dart';
import 'package:reading_retention_tool/module/app_data.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:provider/provider.dart';
import 'dart:async';

class InstapaperBookmarkScreen extends StatefulWidget {
  
  @override
  _InstapaperBookmarkScreenState createState() => _InstapaperBookmarkScreenState();
}

class _InstapaperBookmarkScreenState extends State<InstapaperBookmarkScreen> {

  final _store = Firestore.instance;
  bool userHasData = false;
  bool isHighlightSynced = false;
  var instapaperCredentials;
  var instapaperEmail;
  var instapaperPassword;
  var message;
  var userKey;
  var userSecret;
  var data;
  var isTapped = false;

  Future<DocumentSnapshot> getInstapaperCredentials() async{
    instapaperCredentials = await _store.collection('instapaperbookmarks')
        .document(Provider.of<AppData>(context, listen: false).userData.id)
        .get();

    return instapaperCredentials;
  }

  

  Future<DocumentSnapshot> _getInstapaperBookmarks() async {
    var data =  await _store
        .collection('instapaperbookmarks')
        .document(Provider.of<AppData>(context, listen: false).userData.id)
        .get();

    if(data.exists){
      setState(() {
        userHasData = true;
      });
    }
    else{
      setState(() {
        userHasData = false;
      });
    }

    return data;
  }

  Future<bool> _isBookmarksHighlightSynced(bookmarkId) async {
    var data =  await _store
        .collection('instapaperhighlights')
        .document(Provider.of<AppData>(context, listen: false).userData.id)
        .collection('highlights')
        .document(bookmarkId)
        .get();

    if(data.exists){

      setState(() {
        isHighlightSynced = true;
      });
    }
    else{
      setState(() {
        isHighlightSynced = false;
      });
    }

    return isHighlightSynced;
  }

  final HttpsCallable callable = CloudFunctions(region: 'europe-west2').getHttpsCallable(functionName: 'syncBookmarkHighlights',);


  Future<String> _callSyncBookmarkHighlights(bookmarkId) async {

    try{

      dynamic resp = await callable.call(<String, dynamic>{
        'username' : instapaperEmail,
        'password' : instapaperPassword,
        'bookmarkID': bookmarkId,
        'key' : userKey,
        'secret' : userSecret,
        'uid' : Provider
            .of<AppData>(context, listen: false)
            .userData
            .id,
      });

      if (resp.data == 200) {
        Navigator.popAndPushNamed(
            context, BookmarkHighlightRoute, arguments: bookmarkId.toString());
      }
      else{
        setState(() {
          message = 'Bookmark does not contain highlights';
        });

      }
    }
    catch (e, s) {
      print(e);
      print(s);
    }


    return message;
  }
  
  @override
  Widget build(BuildContext context) {
   // final bookmarkIsSynced = Provider.of<AppData>(context, listen: false).bookmarkIsSynced;
    
    return Scaffold(
      appBar: header(headerText: 'Bookmark List', screen: HomeScreen(), context: context),
      body: SafeArea(
        child: FutureBuilder (
            future:  _getInstapaperBookmarks(),
            builder: (context, snapshot) {
              List<Widget> widgetHighlights = [];

              if(userHasData)  {

                List bookmarks = snapshot.data['instabookmarks'];

                if(bookmarks.isEmpty){
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
                  for (var index = 0; index < bookmarks.length; index++) {

                    final highlightWidget =
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Card(
                        //color: bookmarkIsSynced ? kPrimaryColor : Colors.white,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[

                            Card(
                              elevation: 3.0,
                              child: ListTile(
                                contentPadding: EdgeInsets.all(20.0),
                                title: Text(bookmarks[index]['title']),
                               /* subtitle: bookmarkIsSynced ?
                                          Text('bookmark is sycned',
                                                style: TextStyle(color: kSecondaryColor,
                                                                 fontStyle: FontStyle.italic),) : Text(''),*/
                                onTap: (){

                                  _isBookmarksHighlightSynced(bookmarks[index]['id'].toString()).then((val){
                                        if(!val){
                                          getInstapaperCredentials().then((val){
                                            if(val.exists){
                                              instapaperEmail = val.data['credentials']['email'];
                                              instapaperPassword = val.data['credentials']['password'];
                                              userKey = val.data['credentials']['key'];
                                              userSecret = val.data['credentials']['secret'];

                                              _callSyncBookmarkHighlights(bookmarks[index]['id']).then((val){
                                                   if(val != null){
                                                     setState(() {
                                                       isTapped = false;
                                                     });
                                                     final snackBar = SnackBar(
                                                       backgroundColor: kPrimaryColor,
                                                       content: Text(val),
                                                     );
                                                     Scaffold.of(context).showSnackBar(snackBar);
                                                   }
                                              });
                                            }

                                          });
                                        }
                                        else{
                                          Navigator.popAndPushNamed(
                                              context, BookmarkHighlightRoute, arguments: bookmarks[index]['id'].toString());
                                        }
                                  });



                                },
                              ),
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
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        CircularProgressIndicator(),
                        SizedBox(height: 10.0,),
                        Text('This might take some time!',)
                      ],
                    ),
                );

              }
              return ListView.builder(
                itemCount: snapshot.data['instabookmarks'].length == null ? 0 : snapshot.data['instabookmarks'].length,
                itemBuilder: (context, index) {
                  return widgetHighlights[index];
                },
              );
            }
        ),
      ),
    );
  }
}



