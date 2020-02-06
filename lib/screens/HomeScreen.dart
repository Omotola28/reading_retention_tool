import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:reading_retention_tool/constants/constants.dart';
import 'package:reading_retention_tool/module/auth.dart';
import 'package:reading_retention_tool/screens/CategoryHighlightsScreen.dart';
import 'package:reading_retention_tool/screens/GetStartedScreen.dart';
import 'package:reading_retention_tool/custom_widgets/ServiceSync.dart';
import 'package:reading_retention_tool/screens/KindleHighlightsSync.dart';
import 'package:reading_retention_tool/module/app_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reading_retention_tool/screens/ManageCategory.dart';
import 'package:reading_retention_tool/screens/UserBooksListScreen.dart';
import 'package:reading_retention_tool/customIcons/my_flutter_app_icons.dart';
import 'package:oauth1/oauth1.dart' as oauth1;
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;

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

  }

  Future doLogin(
      String email,
      String password
      ) async {

    var url = "https://www.instapaper.com/api/1/oauth/access_token";

    Map<String, dynamic> body = {
      'x_auth_username' : '${email}',
      'x_auth_password' : '${password}',
      'x_auth_mode' : 'client_auth'
    };


    var ms = (new DateTime.now()).millisecondsSinceEpoch;

    final response = await http.post(url,
        body: body,
        headers: {
          HttpHeaders.authorizationHeader : 'OAuth oauth_consumer_key="287b4ea14bdd4f488a7721abda57c261",oauth_signature_method="HMAC-SHA1",oauth_timestamp="${(ms / 1000).round()}",oauth_nonce="IHEaM65PpHN",oauth_version="1.0",oauth_signature=""'
        },
        encoding: Encoding.getByName("utf-8")
    );


    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      print(response.body);
     // return Login.fromJson(json.decode(response.body));
    } else {
      print('RESPONSE ' + response.body);
      throw Exception('Failed to load post');
    }
  }

/*
  static final INSTAPAPER_API_URL_ACCESS_TOKEN="https://www.instapaper.com/api/1/oauth/access_token";
  static final INSTAPAPER_API_KEY = '287b4ea14bdd4f488a7721abda57c261';
  static final INSTAPAPER_SECRET_KEY = 'b0354423a77c43feb07671cd2a67d4ed';

  static final platform = new oauth1.Platform(
      '',
      '',
      INSTAPAPER_API_URL_ACCESS_TOKEN,
      oauth1.SignatureMethods.hmacSha1// signature method
  );


  static final clientCredentials = new oauth1.ClientCredentials(INSTAPAPER_API_KEY, INSTAPAPER_SECRET_KEY);

  var auth = new oauth1.Authorization(clientCredentials, platform);

  oauth1.Credentials _tempCredentials;

  Future<String> getRequestTokenUrl() async {

    final response = await auth.requestTemporaryCredentials('oob');
    _tempCredentials = response.credentials;
    print(response);
   // return "${auth.getResourceOwnerAuthorizationURI(_tempCredentials.token)}";
  }

  // get real token with pin code input from user
  Future<oauth1.Client> requestToken(String verifier) async {
    final response = await auth.requestTokenCredentials(_tempCredentials, verifier);
    _tempCredentials = null;

    // save the token to local storage
    //_saveToken(response.credentials);

    // this is the oauth1 client that we can use as httpClient to call other APIs that needed authentication.
    var authClient = oauth1.Client(platform.signatureMethod, clientCredentials, response.credentials);
    return authClient;
  }

*/


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
                      onTap: () {

                        doLogin('omotolashogunle@gmail.com', '@Matilda28').then((val){
                          print(val);
                        });
                        //instapaper();
                        //Navigator.pop(context);
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

  void _makeInstapaperAccessTokenRequest() async{
    // set up POST request arguments
    String url = 'https://www.instapaper.com/api/1/oauth/access_token';
    Map<String, String> headers = {"Content-type": "application/x-www-form-urlencoded"};
    String json = '{"title": "Hello", "body": "body text", "userId": 1}';
    // make POST request
    Response response = await post(url, headers: headers, body: json);
    // check the status code for the result
    int statusCode = response.statusCode;
    // this API passes back the id of the new item added to the body
    String body = response.body;
    // {
    //   "title": "Hello",
    //   "body": "body text",
    //   "userId": 1,
    //   "id": 101
    // }

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





Future<Post> fetchPost() async {
  final response = await http.post(
    'https://www.instapaper.com/api/1/oauth/access_token',
    headers: {HttpHeaders.authorizationHeader: "Basic your_api_token_here"},
  );
  final responseJson = json.decode(response.body);

  return Post.fromJson(responseJson);
}

class Post {
  final int userId;
  final int id;
  final String title;
  final String body;

  Post({this.userId, this.id, this.title, this.body});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      body: json['body'],
    );
  }

}


