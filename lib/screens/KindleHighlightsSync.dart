import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reading_retention_tool/constants/constants.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:reading_retention_tool/custom_widgets/ActionUserButton.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:reading_retention_tool/module/app_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:async';

import 'package:reading_retention_tool/screens/ShowRetrievedHighlightsScreen.dart';


class KindleHighlightsSync extends StatefulWidget {

  static String id = 'kindle_highlights_sync_screen';

  @override
  _KindleHighlightsSync createState() => new _KindleHighlightsSync();
}

class _KindleHighlightsSync extends State<KindleHighlightsSync> {
  String _fileName;
  String _path;
  String _extension;
  bool _loadingPath = false;
  FileType _pickingType;
  final _firestore = Firestore.instance;
  var _highlightObject;
  List obj = [];
  StorageUploadTask task;
  StorageReference firebaseStorageRef;


  TextEditingController _controller = new TextEditingController();

  Future<DocumentSnapshot> getHighlights() async{

      final highlights =
        await _firestore.collection("users")
            .document(Provider.of<AppData>(context).uid).collection('books')
            .document(_fileName).get();


      return highlights;

  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => _extension = _controller.text);
  }

  @override
  void dispose() {
    super.dispose();
    task = null;
    _path = null;
  }

  void _openFileExplorer() async {
      setState(() => _loadingPath = true);
      try {
          _path = await FilePicker.getFilePath(
              type: FileType.CUSTOM, fileExtension: 'pdf'
          );

      } on PlatformException catch (e) {
        print("Unsupported operation" + e.toString());
      }
      if (!mounted) return;
      setState(() {
        _loadingPath = false;
        _fileName = _path != null
            ? _path.split('/').last
            : '...';
      });
  }

  @override
  Widget build(BuildContext context) {
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
        body: SafeArea(
          child: Container(
            child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Builder(
                          builder: (BuildContext context) => _loadingPath
                              ? Padding(
                              padding: EdgeInsets.only(bottom: 10.0),
                              child: CircularProgressIndicator())
                              : _path != null
                              ? Container(
                            height: MediaQuery.of(context).size.height * 0.10,
                            child: SizedBox(
                              child: ListView.separated(
                                itemCount: 1,
                                itemBuilder: (BuildContext context, int index) {
                                  //'File $index: '
                                  final String name = _fileName;
                                  final path = _path;

                                  return Row(
                                    children: <Widget>[
                                      Container(
                                        height: 30.0,
                                        child: Image.asset("Images/pdf.png"),

                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(10.0, 0.0, 2.0, 0.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                name,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20.0
                                                ),
                                              ),
                                              const Padding(padding: EdgeInsets.only(bottom: 2.0)),
                                              Text(
                                                path,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontSize: 10.0,
                                                  color: kHighlightColorGrey,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],

                                  );
                                },
                                separatorBuilder:
                                    (BuildContext context, int index) =>
                                    Divider(),
                              ),
                            ),
                          )
                              : Container(),
                        ),
                        //CUSTOM BUTTON FOR APP
                        ActionUserButton(color: Colors.white, title: 'Select File', onPressed: () => _openFileExplorer()),
                        task != null ? Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: CircularProgressIndicator(),
                        ) :
                                      ActionUserButton(color: Colors.white, title: 'Upload File', onPressed: (){
                                           _uploadStatus(File(_path));

                                           task.events.listen((onData){
                                             print(onData.type);
                                             if(onData.type == StorageTaskEventType.success)

                                               Future.delayed(const Duration(seconds: 5), () {

                                                 getHighlights().then((highlights){

                                                  // print(highlights.data);
                                                  Provider.of<AppData>(context).setUploadedHighlights(
                                                       highlights);


                                                   Map<String, dynamic> highlighted = jsonDecode(
                                                       highlights.data['highlights']);

                                                   highlighted.forEach((key, value) {
                                                     obj.add({
                                                       'highlight' : value,
                                                       'category' : 'uncategorised',
                                                       'color' : '#808080',
                                                       'index' : key
                                                     });
                                                   });

                                                   //print(obj);
                                                    //Set object for listbuilder to be accessed globally
                                                   Provider.of<AppData>(context).setHighlightListObject(
                                                       obj);
                                                   Provider.of<AppData>(context).setBookName(_fileName);
                                                 });

                                                // print(task);
                                                 Navigator.pushNamed(
                                                     context, ShowRetrievedHightlightsScreen.id);
                                               });

                                           });
                        }),

                      ],
                    ),
                  ),
                )),
          ),
        ),
      );
  }

  String _bytesTransferred(StorageTaskSnapshot snapshot) {
    double res = snapshot.bytesTransferred / 1024.0;
    double res2 = snapshot.totalByteCount / 1024.0;
    return '${res.truncate().toString()}/${res2.truncate().toString()}';
  }


  Widget _uploadStatus(File file) {

    setState(() {
      firebaseStorageRef = FirebaseStorage.instance.ref().child("${Provider.of<AppData>(context).uid}_${_fileName}");
      task = firebaseStorageRef.putFile(file);
    });



    return StreamBuilder(
      stream: task.events,
      builder: (BuildContext context, snapshot) {
        Widget subtitle;
        if (snapshot.hasData) {
          final StorageTaskEvent event = snapshot.data;
          final StorageTaskSnapshot snap = event.snapshot;
          subtitle = Text('${_bytesTransferred(snap)} KB sent', style: TextStyle(color: kDarkColorBlack),);
        } else {
          subtitle = const Text('Starting...');
        }

        return ListTile(
            title: task.isComplete && task.isSuccessful
                ? Text(
              'Done',
              style: TextStyle(color: kDarkColorBlack),
            )
                : Text(
              'Uploading',
              style: TextStyle(color: kDarkColorBlack),
            ),
            subtitle: subtitle,
          );

      },
    );
  }
}

