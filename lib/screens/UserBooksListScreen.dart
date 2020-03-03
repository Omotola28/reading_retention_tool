import 'package:flutter/material.dart';
import 'package:reading_retention_tool/constants/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reading_retention_tool/custom_widgets/AppBar.dart';
import 'package:reading_retention_tool/module/app_data.dart';
import 'package:provider/provider.dart';
import 'package:reading_retention_tool/screens/BookSpecificHighlightScreen.dart';
import 'package:reading_retention_tool/screens/HomeScreen.dart';

class UserBooksListScreen extends StatefulWidget {

  @override
  _UserBooksListScreenState createState() => _UserBooksListScreenState();
}

class _UserBooksListScreenState extends State<UserBooksListScreen> {

  final _store = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: header(headerText: 'Book List', screen: HomeScreen(), context: context),
      body: SafeArea(
          child: Column(
            children: <Widget>[
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                    stream: _store.collection('kindle')
                        .document(Provider.of<AppData>(context).userData.id)
                        .collection('books').snapshots(),
                    builder: (context, snapshot){

                      if(snapshot.hasData){

                        if(snapshot.data.documents.isNotEmpty){
                          return ListView.builder(
                              itemCount: snapshot.data.documents.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Card(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Card(
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
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }
                          );
                        }
                        else{
                          return Container(
                            child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Image.asset(
                                      'Images/nobooks.png',
                                    ),
                                    Text('No Books Added Yet',
                                      style: TextStyle(
                                          color: kDarkColorBlack),
                                    ),
                                  ],
                                ) 
                            )
                          );
                        }



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
