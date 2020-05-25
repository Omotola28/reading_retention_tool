import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reading_retention_tool/constants/constants.dart';
import 'package:reading_retention_tool/constants/route_constants.dart';
import 'package:reading_retention_tool/service/auth_service.dart';
import 'package:reading_retention_tool/screens/ActivityFeedPage.dart';
import 'package:flutter/services.dart';
import 'package:reading_retention_tool/module/app_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reading_retention_tool/screens/NearbyLibraryPage.dart';
import 'package:reading_retention_tool/screens/ServiceSyncListPage.dart';
import 'package:reading_retention_tool/screens/UserBooksListScreen.dart';
import 'package:reading_retention_tool/customIcons/my_flutter_app_icons.dart';
import 'dart:async';
import 'package:cloud_functions/cloud_functions.dart';
import 'dart:io';



class HomeScreen extends StatefulWidget {


  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  bool expandFlag = false;
  int categoryLength = 0;
  PageController pageController;
  int pageIndex = 0;
  static const platform = const MethodChannel('app.channel.shared.data');
  String dataShared = "No data";
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  StreamSubscription<IosNotificationSettings> iosSubscription;


  @override
  void initState() {
    super.initState();


    Future.delayed(Duration.zero, () async {
      final appData = Provider.of<AppData>(context, listen: false);
      await appData.init();
    });

    //Navigation page controller
    pageController = PageController(initialPage: 0);

    if(Platform.isIOS){
       iosSubscription = _firebaseMessaging.onIosSettingsRegistered.listen((data){
           _saveDeviceToke();
      });
       _firebaseMessaging.requestNotificationPermissions(IosNotificationSettings());
    }
    else{
      _saveDeviceToke();
    }




  }

  onPageChanged(int pageIndex){
    setState(() {
      this.pageIndex = pageIndex;
    });

  }

  onTap(int pageIndex){
    pageController.animateToPage(pageIndex, duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
  }


  final HttpsCallable callable = CloudFunctions.instance.getHttpsCallable(
    functionName: 'syncInstapaper',
  );


  _saveDeviceToke() async{

    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    String uid = user.uid;

    String fcmToken = await _firebaseMessaging.getToken();
    if(fcmToken !=null){
      var tokenRef = Firestore.instance
                              .collection('users')
                              .document(uid)
                              .collection('tokens')
                              .document(fcmToken);
      await tokenRef.setData({
        'token' : fcmToken,
        'createdAt' : FieldValue.serverTimestamp(),
        'platform' : Platform.operatingSystem
      });

    }

  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
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
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: UserAccountsDrawerHeader(
                          accountName: Text(
                            "Hi! :)",
                            style: kTrailingTextStyleDecoration.copyWith(color: kDarkColorBlack),
                          ),
                          accountEmail: Text(
                            Provider.of<AppData>(context).userData != null ? Provider.of<AppData>(context).userData.displayName : '',

                            style: kHeadingTextStyleDecoration,
                          ),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(
                                   kNoPhotoUrl
                                ),
                                fit: BoxFit.fill
                            )
                          ),
                        ),
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
                        title: Text('Kindle NoteBooks'),
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
                            Provider.of<AppData>(context).userData != null ?
                            Flexible(
                                flex: 2,
                                child: StreamBuilder<QuerySnapshot>(
                                    stream: Firestore.instance.collection('category')
                                        .document(Provider.of<AppData>(context).userData.id)
                                        .collection('userCategories').snapshots(),
                                    builder: (context, snapshot){
                                      if(snapshot.hasData){
                                        categoryLength = snapshot.data.documents.length;
                                        return ListView.builder(
                                          itemBuilder: (context, index) {

                                            if(snapshot.data.documents[index].data.length == 1){
                                              return  Container(
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
                                                      Navigator.pushNamed(context, CategoryHighlightsRoute, arguments:
                                                      snapshot.data.documents[index].documentID);
                                                    },
                                                  )
                                              );
                                            }

                                            return SizedBox();// Doesn't do anything or hopefully take up space
                                          },
                                          itemCount: snapshot.data.documents.length,
                                        );

                                      }

                                      return Text('No categories yet', style: TextStyle(color: Colors.black));

                                    }

                                )
                            ) : CircularProgressIndicator(),
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
                                    Navigator.popAndPushNamed(context, ManageCategoryRoute);
                                  },
                                ),
                              ),
                            ): Container(),
                          ],
                        )


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
                    UserAuth.auth.signOut();
                    UserAuth.googleSignIn.signOut();

                    Navigator.popAndPushNamed(context, GetStartedScreenRoute);

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
            backgroundColor: Colors.white,
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.home)),
              BottomNavigationBarItem(icon: Icon(Icons.library_books)),
              BottomNavigationBarItem(icon: Icon(Icons.notifications_active))
            ],
        ),
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





