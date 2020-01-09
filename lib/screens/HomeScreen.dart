import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:reading_retention_tool/constants/constants.dart';
import 'package:reading_retention_tool/module/auth.dart';
import 'package:reading_retention_tool/screens/GetStartedScreen.dart';
import 'package:reading_retention_tool/custom_widgets/ServiceSync.dart';
import 'package:reading_retention_tool/screens/KindleHighlightsSync.dart';
import 'package:reading_retention_tool/module/user_data.dart';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  Future<FirebaseUser> loggedUser;
  final _auth = UserAuth.auth;
  var userEmail;
  var uid;


  @override
  void initState() {
    super.initState();
    loggedUser = UserAuth.getCurrentUser();
    loggedUser.then((val){
      Provider.of<UserData>(context).setCurrentUserEmail(val.email);
      Provider.of<UserData>(context).setCurrentUid(val.uid);
        //userEmail = val.email;
    });
   // userEmail = Provider.of<Data>(context).email;

  }


  @override
  Widget build(BuildContext context) {
    userEmail = Provider.of<UserData>(context).email;
    return Scaffold(
        appBar: AppBar(
          brightness: Brightness.light,
          iconTheme: IconThemeData(color: kDarkColorBlack),
          elevation: 0.0,
          actions: <Widget>[
            new IconButton(
              onPressed: () {
                //do something
              },
              padding: EdgeInsets.all(0.0),
              iconSize: 100.0,
              icon: Image.asset(
                'Images/quotd.png',
              ),
              // tooltip: 'Closes application',
              //    onPressed: () => exit(0),
            ),
          ],
        ),
        drawer: Drawer(
          child: Column(
            children: <Widget>[
              Expanded(
                child: ListView(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.topRight,
                      child: FlatButton(
                          onPressed: null,
                          child: Image.asset(
                            "Images/settings.png",
                            width: 24.0,
                            height: 24.0,
                          )
                      ),
                    ),
                    UserAccountsDrawerHeader(
                      accountName: Text(
                        "Omotola Shogunle",
                        style: kTrailingTextStyleDecoration,
                      ),
                      accountEmail: Text(
                        // '',
                        userEmail != null ? userEmail : '',
                        style: kHeadingTextStyleDecoration,
                      ),
                      currentAccountPicture: CircleAvatar(
                        backgroundColor: kPrimaryColor,
                      ),
                    ),
                    ListTile(
                      leading: Image.asset(
                        "Images/notes.png",
                        width: 24.0,
                        height: 24.0,
                      ),
                      title: Text('All Highlights'),
                      onTap: () {
                        // Update the state of the app
                        // ...
                        // Then close the drawer
                        Navigator.pop(context);
                      },
                    ),
                    Divider(
                      color: kHighlightColorGrey,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Categories",
                        style: kHeadingTextStyleDecoration,
                      ),
                    ),
                    ListTile(
                      title: Text('Item 2'),
                      onTap: () {
                        // Update the state of the app
                        // ...
                        // Then close the drawer
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
              ListTile(
                title: Text(
                  "Logout",
                  style: kHeadingTextStyleDecoration.copyWith(color: kPrimaryColor),

                ),
                onTap: () {
                  _auth.signOut();
                  Navigator.push(context, MaterialPageRoute(builder: (context){
                    return GetStartedScreen();
                  }));

                },
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: Container(
            color: Colors.white,
            child: Column(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text(
                      "Sync Highlights",
                      style: kHeadingTextStyleDecoration.copyWith(fontSize: 25.0),
                    ),
                    Text(
                      "20 out of 2000 highlights",
                      style: kTrailingTextStyleDecoration,
                    ),
                  ],
                ),
                SizedBox(
                  height: 30.0,
                ),
                Column(
                  children: <Widget>[
                    ListView(
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(20.0),
                      children: <Widget>[
                           ServiceSync(
                             thumbnail: Image.asset("Images/Instapaper.png"),
                             title: "Instatpaper",
                             subtitle: "Sync all your highlights from articles you have read online"
                           ),
                           ServiceSync(
                              thumbnail: Image.asset("Images/medium.png"),
                              title: "Medium",
                              subtitle: "Sync highlights from medium"
                           ),
                          ServiceSync(
                            thumbnail: Image.asset("Images/kindle.png"),
                            title: "Kindle",
                            subtitle: "Sync highlights from your kindle ebooks/app",
                            screen: KindleHighlightsSync(),
                          ),
                          ServiceSync(
                            thumbnail: Image.asset("Images/hmq.png"),
                            title: "Highlight My Quotes",
                            subtitle: "Add highlights manually from print books you have read"
                          ),
                          ],
                        )
                      ],
                    ),
                  ],
                )
          ),
        ),
    );
  }
}


