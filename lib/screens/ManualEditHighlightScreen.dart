import 'package:flutter/material.dart';
import 'package:reading_retention_tool/constants/route_constants.dart';
import 'package:reading_retention_tool/custom_widgets/AppBar.dart';
import 'package:reading_retention_tool/custom_widgets/UserTextInputField.dart';
import 'package:reading_retention_tool/module/formdata.dart';
import 'package:reading_retention_tool/screens/ManualHighlightScreen.dart';
import 'package:reading_retention_tool/constants/constants.dart';
import 'package:provider/provider.dart';
import 'package:reading_retention_tool/module/app_data.dart';

class ManualEditHighlightScreen extends StatefulWidget {

  FormData formData;


  ManualEditHighlightScreen(this.formData);

  @override
  _ManualEditHighlightScreenState createState() => _ManualEditHighlightScreenState();
}

class _ManualEditHighlightScreenState extends State<ManualEditHighlightScreen> {

  String extractedText, _color, page, title, thoughts;
  List<String> _colors = <String>['', 'red', 'green', 'blue', 'orange'];


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
                        widget.formData.extractedText = text;
                      },
                    ),
                  ),
                  /*FormField(
                    builder: (FormFieldState state) {
                      return InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'Choose Book',
                          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: kPrimaryColor,width: 2.0)),
                          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: kPrimaryColor,width: 3.0)),
                        ),
                        isEmpty: _color == '',
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                          child: DropdownButtonHideUnderline(
                            child:  DropdownButton(
                              value: _color,
                              isDense: true,
                              onChanged: (String newValue) {
                                setState(() {
                                  _color = newValue;
                                  state.didChange(newValue);
                                });
                              },
                              items: _colors.map((String value) {
                                return DropdownMenuItem(
                                  value: value,
                                  child: new Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      );
                    },
                  )*/
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
                        print(text);
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
               /*OutlineButton(
                 disabledBorderColor: kPrimaryColor,
                 onPressed: () {
                   // Provider.of<AppData>(context, listen: false).setFormData(formData);
                   // print(Provider.of<AppData>(context, listen: false).editFormData.extractedText);
                    Navigator.pushNamed(context, AddBookRoute, arguments: widget.formData);
                 },
                 child: Text('Add Book',
                   style: TextStyle(
                       color: kPrimaryColor,
                       letterSpacing: 1
                   ),
                 ),
               ),*/
               Padding(
                 padding: const EdgeInsets.fromLTRB(10, 0, 10 , 0),
                 child: OutlineButton(
                   disabledBorderColor: kPrimaryColor,
                   onPressed: () {
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
}


