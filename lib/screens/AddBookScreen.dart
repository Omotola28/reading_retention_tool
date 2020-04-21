import 'package:cloud_functions/cloud_functions.dart';
import 'package:flappy_search_bar/search_bar_style.dart';
import 'package:flutter/material.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:reading_retention_tool/constants/constants.dart';
import 'package:reading_retention_tool/constants/route_constants.dart';
import 'package:reading_retention_tool/custom_widgets/AppBar.dart';
import 'package:reading_retention_tool/module/book.dart';
import 'package:reading_retention_tool/module/formdata.dart';
import 'package:reading_retention_tool/screens/ManualEditHighlightScreen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';



class AddBookScreen extends StatefulWidget {

  FormData formData;

  AddBookScreen(this.formData);


  @override
  _AddBookScreenState createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {

  String title= '';
  String author='';
  String url='';
  String searchResult = '';


  Future<Book> _requestBooks(String isbn) async {
    final response = await http.get('https://openlibrary.org/api/books?bibkeys=ISBN:$isbn&jscmd=data&format=json');

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.

        if(json.decode(response.body)['ISBN:'+isbn] != null)
            return Book.fromJson(json.decode(response.body), isbn);

    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  Future<List<Book>> search(String search) async {

    await Future.delayed(Duration(seconds: 2));
    if (searchResult == null) return [];
    if (search == "error") throw Error();


    await _requestBooks(search).then((value){
      print(value);
      if(value == null ){
          print(value);
          setState(() {

            title = null;
            author = null;
            url = null;
          });
      }
      else{
        setState(() {

          title = value.title;
          author = value.author;
          url = value.url;
        });
      }


    });

    return List.generate(1, (int index) {
      return Book(
          author: this.author,
          title :this.title,
          url: this.url
      );
    });




  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: header(
            headerText: 'Add Book',
            screen: ManualEditHighlightScreen(widget.formData),
            context: context),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: SearchBar(
              onSearch: search,
              onItemFound: (Book book, int index) {
                if(book.title != null){
                  return Container(
                    color: kLightYellowBG,
                    child: Card(
                      color: kLightYellowBG,
                      child: ListTile(
                        leading: Image.network(book.url ?? kBookPlaceHolder),
                        title: Text(book.author),
                        subtitle: Text(
                            book.title
                        ),
                        //trailing: Icon(Icons.more_vert),
                        isThreeLine: true,
                        onTap: (){
                          widget.formData.author = book.author;
                          widget.formData.bookname = book.title;
                          widget.formData.url = book.url;

                          Navigator.of(context).pushNamed(ManualEditHighlightRoute, arguments: widget.formData);
                        },
                      ),
                    ),
                  );
                }
                else{
                  return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Container(child: Text('No Book Found'),),
                      ));
                }

              },
                minimumChars: 13,
                searchBarStyle: SearchBarStyle(
                  backgroundColor: kHighlightColorGrey,
                  padding: EdgeInsets.all(10),
                  borderRadius: BorderRadius.circular(10),
                ),
              onError: (error) {
                return Center(
                  child: Text("Error occurred : $error"),
                );
              },
              emptyWidget: Center(
                child: Text("Empty"),
              ),
              hintText: "Type in Book ISBN",
              hintStyle: TextStyle(
                color: kHighlightColorDarkGrey,
              ),
              textStyle: TextStyle(
                color: kDarkColorBlack,
              ),
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
            ),
          ),
        )
    );
  }
}
