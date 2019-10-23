import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:reading_retention_tool/constants/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:reading_retention_tool/screens/GetStartedScreen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  FirebaseUser loggedUser;
  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();

    getCurrentUser();
  }

  void getCurrentUser() async{
    try {
      final user = await _auth.currentUser();
      if (user != null)
        setState(() {
          loggedUser = user;
        });
      print("Result $loggedUser");
    }
    catch (e) {
      print("Error $e");
    }
  }


  @override
  Widget build(BuildContext context) {
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
                      loggedUser.email != null ? loggedUser.email : '',
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
                    "Upload Highlights",
                    style: kHeadingTextStyleDecoration.copyWith(fontSize: 25.0),
                  ),
                  Text(
                    "20 out of 2000 highlights",
                    style: kTrailingTextStyleDecoration,
                  ),
                ],
              ),
              SizedBox(
                height: 125.0,
              ),
              Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      elevation: 2.0,
                      color: kPrimaryColor,
                      child: TextField(
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                            BorderSide(color: kPrimaryColor),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Text(
                    "File format accepted included html & pdf",
                    style: kTrailingTextStyleDecoration,
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}