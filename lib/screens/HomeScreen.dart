import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:reading_retention_tool/constants/constants.dart';
import 'package:reading_retention_tool/custom_widgets/AppBar.dart';
import 'package:reading_retention_tool/service/auth_service.dart';
import 'package:reading_retention_tool/screens/ActivityFeedPage.dart';
import 'package:reading_retention_tool/screens/CategoryHighlightsScreen.dart';
import 'package:reading_retention_tool/screens/GetStartedScreen.dart';
import 'package:reading_retention_tool/module/app_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reading_retention_tool/screens/ManageCategory.dart';
import 'package:reading_retention_tool/screens/NearbyLibraryPage.dart';
import 'package:reading_retention_tool/screens/ServiceSyncListPage.dart';
import 'package:reading_retention_tool/screens/UserBooksListScreen.dart';
import 'package:reading_retention_tool/customIcons/my_flutter_app_icons.dart';
import 'dart:async';
import 'package:cloud_functions/cloud_functions.dart';



class HomeScreen extends StatefulWidget {


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
  int categoryLength = 0;
  PageController pageController;
  int pageIndex = 0;



  @override
  void initState() {
    super.initState();
    loggedUser = UserAuth.getCurrentUser();
    loggedUser.then((val){
      Provider.of<AppData>(context).setCurrentUserEmail(val.email);
      Provider.of<AppData>(context).setCurrentUid(val.uid);
    });


    Future.delayed(Duration.zero, () async {
      final appData = Provider.of<AppData>(context);
      await appData.init();
    });

    //Navigation page controller
    pageController = PageController(initialPage: 0);


  }

  getStreamBookIds() async{
    final books = await _store.collection('users')
        .document(Provider.of<AppData>(context).uid)
        .collection('books').snapshots();

  }

  onPageChanged(int pageIndex){
    setState(() {
      this.pageIndex = pageIndex;
    });

  }

  onTap(int pageIndex){
    pageController.animateToPage(pageIndex, duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  //TODO: DELETE ONCE DONE WITH TESTING
  final HttpsCallable callable = CloudFunctions.instance.getHttpsCallable(
    functionName: 'syncInstapaper',
  );


  @override
  Widget build(BuildContext context) {
    final currentUser =  Provider.of<AppData>(context).userData;

    return Scaffold(
        appBar: header(),
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
                    Padding(
                      padding: const EdgeInsets.only(left: 5.0),
                      child: UserAccountsDrawerHeader(
                        accountName: Text(
                          "Hi! :)",
                          style: kTrailingTextStyleDecoration,
                        ),
                        accountEmail: Text(
                          currentUser != null ? currentUser.displayName : '',
                          //userEmail != null ? userEmail : '',
                          style: kHeadingTextStyleDecoration,
                        ),
                        currentAccountPicture: Container(
                          width: 300,
                          height: 300,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: kPrimaryColor,
                              image: currentUser.photoUrl != null ? DecorationImage(
                                  fit: BoxFit.fill,
                                  image: NetworkImage(currentUser.photoUrl)
                              )
                                  : DecorationImage(
                                    fit: BoxFit.fill,
                                    //colorFilter: ColorFilter.mode(kPrimaryColor, BlendMode.color),
                                    image: NetworkImage(kNoPhotoUrl),
                              )
                              //borderRadius: BorderRadius.circular(50.0)
                          ),

                        )
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context)
                          => UserBooksListScreen(),
                          ),
                        );
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
                      trailing: expandFlag ? Icon(CustomIcons.tag , color: kPrimaryColor) : Icon(CustomIcons.tag),
                    ),
                    ExpandableContainer(
                      expanded: expandFlag,
                      child: Column(
                        children: <Widget>[
                          Flexible(
                              flex: 4,
                              child: StreamBuilder<QuerySnapshot>(
                                  stream: Firestore.instance.collection('users')
                                      .document(Provider.of<AppData>(context).uid)
                                      .collection('categories').snapshots(),
                                  builder: (context, snapshot){
                                    if(snapshot.hasData){
                                      categoryLength = snapshot.data.documents.length;
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

                                    return Text('No categories yet', style: TextStyle(color: Colors.black));

                                  }

                              )
                          ),
                          categoryLength != 0 ?
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: FlatButton.icon(
                                padding: EdgeInsets.fromLTRB(30.0, 0.0, 0.0, 0.0),
                                color: kLightYellowBG,
                                icon: Icon(Icons.border_color, size: 15.0,), //`Icon` to display
                                label: Text('Manage Category' ), //`Text` to display
                                onPressed: () {
                                  Navigator.pop(context);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context)
                                    => ManageCategory()
                                    ),
                                  );
                                },
                              ),
                            ),
                          ): Container(),
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
                      onTap: () async {

                       print(Provider.of<AppData>(context).uid);
                        dynamic resp = await callable.call(<String, dynamic>{
                          'username': 'omotolashogunle@gmail.com',
                          'password': '@Matilda28',
                          'uid' : Provider.of<AppData>(context).uid
                        });


                        print(resp.data);

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
                 // _auth.signOut();
                  googleSignIn.signOut();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context)
                    => GetStartedScreen()
                    ),
                  );

                },
              ),
            ],
          ),
        ),
        body: PageView(
          children: <Widget>[
            ServiceSyncListPage(),
            NearbyLibraryPage(),
            ActivityFeedPage(),
          ],

          controller: pageController,
          onPageChanged: onPageChanged,
          physics: NeverScrollableScrollPhysics(),
        ),
      bottomNavigationBar: CupertinoTabBar(
          currentIndex: pageIndex,
          onTap: onTap,
          activeColor: kPrimaryColor,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home)),
            BottomNavigationBarItem(icon: Icon(Icons.library_books)),
            BottomNavigationBarItem(icon: Icon(Icons.notifications_active))
          ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
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





