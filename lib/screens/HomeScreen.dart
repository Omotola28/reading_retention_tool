import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:reading_retention_tool/constants/constants.dart';
import 'package:reading_retention_tool/module/auth.dart';
import 'package:reading_retention_tool/screens/CategoryHighlightsScreen.dart';
import 'package:reading_retention_tool/screens/GetStartedScreen.dart';
import 'package:reading_retention_tool/custom_widgets/ServiceSync.dart';
import 'package:reading_retention_tool/screens/KindleHighlightsSync.dart';
import 'package:reading_retention_tool/module/app_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reading_retention_tool/screens/UserBooksListScreen.dart';
import 'package:reading_retention_tool/customIcons/my_flutter_app_icons.dart';
import 'dart:async';

class HomeScreen extends StatefulWidget {

  static String id = 'home_screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final _store = Firestore.instance;
  Future<FirebaseUser> loggedUser;
  final _auth = UserAuth.auth;
  var userEmail;
  var uid;
  bool expandFlag = false;
  List<dynamic> cat = [];

  @override
  void initState() {
    super.initState();
    loggedUser = UserAuth.getCurrentUser();
    loggedUser.then((val){
      Provider.of<AppData>(context).setCurrentUserEmail(val.email);
      Provider.of<AppData>(context).setCurrentUid(val.uid);
        //userEmail = val.email;
    });

    Future.delayed(Duration.zero, () async {
      final appData = Provider.of<AppData>(context);
      await appData.init();
    });


  }

  void getStreamBookIds() async{
    final books = await _store.collection('users')
        .document(Provider.of<AppData>(context).uid)
        .collection('books').snapshots();

   /* await for (var snapshot in books){
      for (var bookid in snapshot.documents)
      {
         print(bookid.documentID);
      }
    }*/
  }

/*void getNoOfHighlightsInCat()  async {

    final snapshots = Firestore.instance.collection('users').document(Provider.of<AppData>(context).uid)
        .collection('books').snapshots();

      await for(var snapshot in snapshots ){
         for( var snaps in snapshot.documents){
           for(var i = 0; i < snaps.data['highlights'].length; i++){
              if(snaps.data['highlights'][i]['category'] == 'Love'){
                  cat.add(snaps.data['highlights'][i]);

               // print(snaps.data['highlights'][i]);
                //print(snaps.data['highlights'][i]);
              }
           }
         }
      }




      //print('NOT SURE WHY NOT PRINIT ${cat}');
  }*/


  @override
  Widget build(BuildContext context) {
    userEmail = Provider.of<AppData>(context).email;
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
                        "Hi! :)",
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
                      thickness: 2.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Browse",
                        style: kHeadingTextStyleDecoration,
                      ),
                    ),
                    Divider(
                      color: kHighlightColorGrey,
                      thickness: 2.0,
                    ),
                    ListTile(
                      title: Text('Books'),
                      onTap: () {
                        // Update the state of the app
                        //getStreamBookIds();
                        Navigator.popAndPushNamed(context, UserBooksListScreen.id );
                      },
                      trailing: Icon(CustomIcons.book),
                    ),
                    Divider(
                      color: kHighlightColorGrey,
                    ),
                    ListTile(
                      title: Text('Categories'),
                      onTap: () {
                        setState(() {
                          expandFlag = !expandFlag;
                        });

                      },
                      trailing: expandFlag ? Icon(CustomIcons.tag , color: kPrimaryColor,) : Icon(CustomIcons.tag),
                    ),
                    ExpandableContainer(
                      expanded: expandFlag,
                      child: Column(
                        children: <Widget>[
                          Expanded(
                              child: StreamBuilder<QuerySnapshot>(
                                  stream: Firestore.instance.collection('users')
                                      .document(Provider.of<AppData>(context).uid)
                                      .collection('categories').snapshots(),
                                  builder: (context, snapshot){
                                    if(snapshot.hasData){
                                      return ListView.builder(
                                        itemBuilder: (context, index) {

                                          return Container(
                                              decoration: BoxDecoration(border: new Border.all(
                                                  width:0.5, color: Colors.grey),
                                                  color: kLightYellowBG),
                                              child: ListTile(
                                                contentPadding: EdgeInsets.fromLTRB(30.0, 0, 0, 0),
                                                title: Text(
                                                  snapshot.data.documents[index].documentID.split('#')[0],
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      color: kDarkColorBlack),
                                                ),
                                                onTap: (){
                                                  Navigator.of(context).pop();
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(builder: (context)
                                                            => CategoryHighlightsScreen(snapshot.data.documents[index].documentID.split('#')[0])
                                                    ),
                                                  );
                                                },
                                              )
                                          );
                                        },
                                        itemCount: snapshot.data.documents.length,
                                      );

                                    }
                                    else{
                                      return Text('No categories yet', style: TextStyle(color: Colors.black));
                                    }
                                  }
                              )
                          ),
                          Expanded(
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: FlatButton.icon(
                                  padding: EdgeInsets.fromLTRB(30.0, 0.0, 0.0, 0.0),
                                  color: kLightYellowBG,
                                  icon: Icon(Icons.border_color, size: 15.0,), //`Icon` to display
                                  label: Text('Manage Category' ), //`Text` to display
                                  onPressed: () {
                                    /*Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context)
                                      => CategoryHighlightsScreen();
                                      ),
                                    );*/

                                  },
                                ),
                              ),
                          ),
                        ],
                      )


                    ),

                    ListTile(
                      title: Text('Medium Articles'),
                      onTap: () {
                        // Update the state of the app
                        // ...
                        // Then close the drawer
                        Navigator.pop(context);
                      },
                      trailing: Icon(CustomIcons.doc),
                    ),
                    Divider(
                      color: kHighlightColorGrey,
                    ),
                    ListTile(
                      title: Text('Instapaper Articles'),
                      onTap: () {
                        // Update the state of the app
                        // ...
                        // Then close the drawer
                        Navigator.pop(context);
                      },
                      trailing: Icon(CustomIcons.doc),
                    ),
                    Divider(
                      color: kHighlightColorGrey,
                    ),
                    ListTile(
                      title: Text('Favourites'),
                      onTap: () {
                        // Update the state of the app
                        // ...
                        // Then close the drawer
                        Navigator.pop(context);
                      },
                      trailing: Icon(CustomIcons.favorite),
                    ),
                    Divider(
                      color: kHighlightColorGrey,
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
                  Navigator.pushNamed(context, GetStartedScreen.id);

                },
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
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
                        Provider.of<AppData>(context).noOfHighlights.toString() + ' Highlights Added',
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
                                subtitle: "Sync highlights from medium",
                                screen: 'medium',
                             ),
                            ServiceSync(
                              thumbnail: Image.asset("Images/kindle.png"),
                              title: "Kindle",
                              subtitle: "Sync highlights from your kindle ebooks/app",
                              screen: KindleHighlightsSync.id,
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
        ),
    );
  }
}

class ExpandableContainer extends StatelessWidget {
  final bool expanded;
  final double collapsedHeight;
  final double expandedHeight;
  final Widget child;

  ExpandableContainer({
    @required this.child,
    this.collapsedHeight = 0.0,
    this.expandedHeight = 300.0,
    this.expanded = true,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      width: screenWidth,
      height: expanded ? expandedHeight : collapsedHeight,
      child: Container(
        child: child,
        decoration: BoxDecoration(border: Border.all(width: 0.2, color: kHighlightColorGrey)),
      ),
    );
  }
}




