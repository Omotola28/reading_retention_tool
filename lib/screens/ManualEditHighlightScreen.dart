import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reading_retention_tool/constants/route_constants.dart';
import 'package:reading_retention_tool/custom_widgets/AppBar.dart';
import 'package:reading_retention_tool/custom_widgets/UserTextInputField.dart';
import 'package:reading_retention_tool/module/formdata.dart';
import 'package:reading_retention_tool/screens/ManualHighlightScreen.dart';
import 'package:reading_retention_tool/constants/constants.dart';
import 'package:flutter/services.dart';


class ManualEditHighlightScreen extends StatefulWidget {

  FormData formData;


  ManualEditHighlightScreen(this.formData);

  @override
  _ManualEditHighlightScreenState createState() => _ManualEditHighlightScreenState();
}

class _ManualEditHighlightScreenState extends State<ManualEditHighlightScreen> {

  String extractedText, page, title, thoughts;
  List<dynamic> textList = [];



  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: header(headerText: 'Edit Manual Highlight', screen: ManualHighlightScreen(), context: context),
        body: SafeArea(
          child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(
                      readOnly: true,
                      keyboardType: TextInputType.multiline,
                      initialValue: widget.formData.author == null ? '' : widget.formData.author + ', ' + widget.formData.bookname,
                      decoration: InputDecoration(
                          prefixIcon: widget.formData.url != null ?
                          Image.network(
                            widget.formData.url,
                            height: 30,
                            width: 30,
                          ) : Image.network(kBookPlaceHolder, height: 30, width: 30,),
                          labelText: 'ChooseBook',
                          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: kPrimaryColor,width: 2.0)),
                          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: kPrimaryColor,width: 3.0)),
                          suffixIcon: IconButton(
                              icon: Icon(Icons.play_arrow, color: kHighlightColorDarkGrey,),
                              onPressed: () {
                                Navigator.pushNamed(context, AddBookRoute, arguments: widget.formData);
                              })
                      ),
                      validator: (value) => value.isEmpty ? 'No text extracted' : null,
                      onChanged: (text){
                        //widget.formData.extractedText = text;
                      },
                    ),
                  ),

                  UserTextInputField(
                      labelText: 'Page',
                      initialVal: widget.formData.page == null ? '' : widget.formData.page,
                      validate: null,
                      value: false,
                      savedValue:  (value) => page = value,
                      onchanged: (text){
                        widget.formData.page = text;
                      },
                  ),
                  UserTextInputField(
                      labelText: 'Title/Chapter',
                      initialVal: widget.formData.chapter == null ? '' : widget.formData.chapter,
                      validate: (value) => value.isEmpty ? 'Please enter title or chapter' : null,
                      value: false,
                      savedValue: (value) => title =  value,
                      onchanged: (text){
                        widget.formData.chapter = text;

                      },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      initialValue: widget.formData.extractedText.toLowerCase(),
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: kPrimaryColor,width: 2.0)),
                        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: kPrimaryColor,width: 3.0)),
                      ),
                      validator: (value) => value.isEmpty ? 'No text extracted' : null,
                      onChanged: (text){
                        widget.formData.extractedText = text;
                      },
                    ),
                  ),
                  UserTextInputField(
                      labelText: 'Thoughts',
                      initialVal: widget.formData.thoughts == null ? '' : widget.formData.thoughts,
                      validate: null,
                      value: false,
                      savedValue: (value) => thoughts = value,
                      onchanged: (text){
                        widget.formData.thoughts = text;
                      },
                  ),
                ],
              )
          ),
        ),
      bottomNavigationBar: BottomAppBar(
           child: Row(
          //direction: Axis.horizontal,
             crossAxisAlignment: CrossAxisAlignment.end,
             mainAxisAlignment: MainAxisAlignment.end,

             children: <Widget>[
               Padding(
                 padding: const EdgeInsets.fromLTRB(10, 0, 10 , 0),
                 child: OutlineButton(
                   disabledBorderColor: kPrimaryColor,
                   onPressed: () async {

                     final form = _formKey.currentState;
                     final firebaseUser = await FirebaseAuth.instance.currentUser();
                     if(form.validate())
                     {
                       form.save();
                       try{

                         final snapshot = await Firestore.instance
                             .collection('hmq')
                             .document(firebaseUser.uid)
                             .collection('books')
                             .document(widget.formData.bookname)
                             .get();

                         if (snapshot == null || !snapshot.exists) {
                           textList.add({'chapter' : widget.formData.chapter,
                             'color': '#808080',
                             'page': widget.formData.page,
                             'highlight' : widget.formData.extractedText,
                             'thoughts' : widget.formData.thoughts
                           });
                           widget.formData.textList = textList;

                           final result = await addBookToDatabase(widget.formData);

                           result  != false ? Navigator.popAndPushNamed(context, ManualHighlightBookShelfRoute) : print(result);
                         }
                         else{


                           textList.add(
                               {'chapter' : widget.formData.chapter,
                                 'color': '#808080',
                                 'page': widget.formData.page,
                                 'highlight' : widget.formData.extractedText, 'thoughts' : widget.formData.thoughts
                               }
                           );

                           final result = await updateTextField(
                               widget.formData.bookname, textList);

                           result  != false ? Navigator.popAndPushNamed(context, ManualHighlightBookShelfRoute) : print(result);

                         }


                       } on PlatformException catch (e) {
                         //e.code
                         switch(e.code)
                         {
                           case "ERROR_INVALID_EMAIL":
                             print(e.code);
                         }
                         _formKey.currentState.reset();
                       }
                     }
                   },
                   child: Text('Submit',
                     style: TextStyle(
                         color: kPrimaryColor,
                         letterSpacing: 1
                     ),
                   ),
                 ),
               )
            ],
        ),
      ),
    );
  }

  static Future<bool> addBookToDatabase(FormData formData) async {

    final firebaseUser = await FirebaseAuth.instance.currentUser();

    Firestore.instance
        .collection("hmq")
        .document(firebaseUser.uid)
        .collection("books")
        .document(formData.bookname)
        .setData(formData.toJson());

    return true;
  }

  static Future<bool> updateTextField(String bookname, List<dynamic> textList) async {

    final firebaseUser = await FirebaseAuth.instance.currentUser();

    Firestore.instance.collection('hmq')
        .document(firebaseUser.uid)
        .collection('books')
        .document(bookname)
        .updateData({"textList": FieldValue.arrayUnion(textList)});

    return true;

  }
}


