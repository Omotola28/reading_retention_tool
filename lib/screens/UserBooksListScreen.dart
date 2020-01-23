import 'package:flutter/material.dart';
import 'package:reading_retention_tool/constants/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reading_retention_tool/module/app_data.dart';
import 'package:provider/provider.dart';
import 'package:reading_retention_tool/screens/BookSpecificHighlightScreen.dart';
import 'package:reading_retention_tool/screens/HomeScreen.dart';

class UserBooksListScreen extends StatefulWidget {

  static String id = 'user_books_lists';

  @override
  _UserBooksListScreenState createState() => _UserBooksListScreenState();
}

class _UserBooksListScreenState extends State<UserBooksListScreen> {

  final _store = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
         leading: FlatButton(
             child: Icon(
                 Icons.arrow_back_ios,
                 color: kDarkColorBlack,
             ),

             onPressed: () {
                  Navigator.popAndPushNamed(context, HomeScreen.id);
               }

         ),
         title: Text('Book List', style: TextStyle(
           color: kDarkSocialBtnColor,
         ),
         ),
         brightness: Brightness.light,
         iconTheme: IconThemeData(color: kDarkColorBlack),
         elevation: 0.0,
         actions: <Widget>[
           new IconButton(
             onPressed: () {
               print('jhjkja');
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
      body: SafeArea(
          child: Column(
            children: <Widget>[
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                    stream: _store.collection('users')
                        .document(Provider.of<AppData>(context).uid)
                        .collection('books').snapshots(),
                    builder: (context, snapshot){
                      List<ListTile> bookList = [];
                      if(snapshot.hasData){


                        /*final books = snapshot.data.documents;

                        for( var book in books )
                        {
                          final bookId = book.documentID;
                          final textWidget =  ListTile(title: Text(bookId.split('.')[0]));
                          bookList.add(textWidget);

                        }
                        print(bookList.length);*/


                        return ListView.builder(
                              itemCount: snapshot.data.documents.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  elevation: 3.0,
                                  child: ListTile(
                                    title: Text(snapshot.data.documents[index].documentID.split('.')[0]),
                                    onTap: (){
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context)
                                        => BookSpecificHighlightScreen(snapshot.data.documents[index].documentID)),
                                      );

                                    },
                                    trailing: Icon(Icons.keyboard_arrow_right),
                                  ),
                                );
                              }
                          );

                      }
                      else{
                        return Center(child: CircularProgressIndicator());
                      }


                    }

                ),
              )
            ],
          )
      ),
    );
  }
}
