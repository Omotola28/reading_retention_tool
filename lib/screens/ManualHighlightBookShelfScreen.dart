import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:reading_retention_tool/constants/route_constants.dart';
import 'package:reading_retention_tool/custom_widgets/AppBar.dart';
import 'package:reading_retention_tool/screens/ManualHighlightScreen.dart';
import 'package:provider/provider.dart';
import 'package:reading_retention_tool/module/app_data.dart';
import 'package:reading_retention_tool/constants/constants.dart';



class ManualHighlightBookShelfScreen extends StatefulWidget {
  @override
  _ManualHighlightBookShelfScreenState createState() => _ManualHighlightBookShelfScreenState();
}

class _ManualHighlightBookShelfScreenState extends State<ManualHighlightBookShelfScreen> {

  final _store = Firestore.instance;
  Map<String, dynamic> bookData;

  showAlertDialog(BuildContext context, Map<String, dynamic> bookData) {

    print(bookData);
    // set up the buttons
    Widget shelfButton = FlatButton(
      child: Text("Open Book", style: TextStyle(color: kPrimaryColor),),
      onPressed:  () {
        Provider.of<AppData>(context, listen: false).setBookData(bookData);
        Navigator.popAndPushNamed(context, SpecificManualBookRoute,
            arguments: bookData);
      },
    );
    Widget deleteButton = FlatButton(
      child: Text("Delete", style: TextStyle(color: Colors.red)),
      onPressed:  () {
        Firestore.instance.collection("hmq")
            .document(Provider.of<AppData>(context, listen: false).userData.id)
            .collection("books")
            .document(bookData['bookname'])
            .delete();

        Navigator.of(context).pop();
      },
    );
    Widget cancelButton = FlatButton(
      child: Text("Cancel", style: TextStyle(color: kPrimaryColor)),
      onPressed:  () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Actions"),
      content: Text("Are you sure you would like to proceed with deleting this book"), //contains blah highlights
      actions: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            shelfButton,
            deleteButton,
            cancelButton,
          ],
        )

      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(headerText: 'Manual Book Shelf', screen: ManualHighlightScreen(), context: context),
      body: SafeArea(
          child: StreamBuilder<QuerySnapshot>(
                    stream: _store.collection('hmq')
                        .document(Provider.of<AppData>(context).userData.id)
                        .collection('books').snapshots(),
                    builder: (context, snapshot){

                      if(snapshot.hasData){

                        if(snapshot.data.documents.isNotEmpty){
                          return GridView.builder(
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                              itemCount: snapshot.data.documents.length,
                              itemBuilder: (context, index) {

                                return Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Container(
                                    height: 50,
                                    width: 50,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        GestureDetector(
                                          child: Container(
                                            height: 75,
                                            child: Image.network(snapshot.data.documents[index]['url'] ?? kBookPlaceHolder),
                                          ),
                                          onTap: (){
                                            bookData = { 'bookname' : snapshot.data.documents[index]['bookname'],
                                              'url' : snapshot.data.documents[index]['url'] };

                                            Provider.of<AppData>(context, listen: false).setBookData(bookData);
                                            Navigator.popAndPushNamed(context, SpecificManualBookRoute,
                                                arguments: bookData);
                                          },
                                          onLongPress: (){
                                            bookData = { 'bookname' : snapshot.data.documents[index]['bookname'],
                                              'url' : snapshot.data.documents[index]['url'] };
                                            showAlertDialog(context, bookData);
                                          },
                                        ),
                                        Expanded(
                                            child:  Text(snapshot.data.documents[index]['bookname'], style:
                                                    TextStyle(fontSize: 10.0), textAlign: TextAlign.center,)
                                        ),
                                        Expanded(
                                              child: Text(snapshot.data.documents[index]['author'],
                                              style: TextStyle(fontSize: 10.0,), textAlign: TextAlign.center,))
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
      ),
    );
  }
}
