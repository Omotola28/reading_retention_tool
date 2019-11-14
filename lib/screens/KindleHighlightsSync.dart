import 'package:flutter/material.dart';
import 'package:reading_retention_tool/constants/constants.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:reading_retention_tool/custom_widgets/ActionUserButton.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class KindleHighlightsSync extends StatefulWidget {
  @override
  _KindleHighlightsSync createState() => new _KindleHighlightsSync();
}

class _KindleHighlightsSync extends State<KindleHighlightsSync> {
  String _fileName;
  String _path;
  String _extension;
  bool _loadingPath = false;
  FileType _pickingType;

  TextEditingController _controller = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => _extension = _controller.text);
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
                        ActionUserButton(color: Colors.white, title: 'Upload File', onPressed: (){
                          final StorageReference firebaseStorageRef =
                                FirebaseStorage.instance.ref().child('file.pdf');
                          final StorageUploadTask task = firebaseStorageRef.putFile(File(_path));
                        }),
                      ],
                    ),
                  ),
                )),
          ),
        ),
      );
  }
}

