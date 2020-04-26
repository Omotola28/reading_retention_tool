import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:reading_retention_tool/constants/constants.dart';
import 'package:reading_retention_tool/constants/route_constants.dart';
import 'package:reading_retention_tool/custom_widgets/AppBar.dart';
import 'package:reading_retention_tool/module/formdata.dart';
import 'package:reading_retention_tool/screens/HomeScreen.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'dart:io';
import 'dart:async';

class ManualHighlightScreen extends StatefulWidget {
  @override
  _ManualHighlightScreenState createState() => _ManualHighlightScreenState();
}

class _ManualHighlightScreenState extends State<ManualHighlightScreen> {

  File _imageFile;
  bool isDisabled = true;
  FormData data = FormData();

  Future<void> _pickImage(ImageSource source) async{
    File selected = await ImagePicker.pickImage(source: source);

    setState(() {
      _imageFile = selected;
      isDisabled = false;
    });
  }

  void _clear(){
    print('juiuuujhjjjhjj');
    setState(() {
      _imageFile = null;
      isDisabled = true;

    });
  }

  Future<void> _cropImage() async{
    File cropped = await ImageCropper.cropImage(
        sourcePath: _imageFile.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ]
            : [
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio5x3,
          CropAspectRatioPreset.ratio5x4,
          CropAspectRatioPreset.ratio7x5,
          CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: kPrimaryColor,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          title: 'Crop Image',
        )
    );

    setState(() {
      //null aware indicates the double ?? if cropped is null set it to _imageFile
      _imageFile = cropped ?? _imageFile;
      isDisabled = false;
    });
  }


  Future _recognizeText() async{
    String text = '';

    FirebaseVisionImage theImage = FirebaseVisionImage.fromFile(_imageFile);
    TextRecognizer recognizeText = FirebaseVision.instance.textRecognizer();
    VisionText readText = await recognizeText.processImage(theImage);

    for(TextBlock block in readText.blocks){
      for(TextLine line in block.lines){
        for(TextElement word in line.elements){

          text += ' ' +word.text;
        }
      }
    }

    if(text.isNotEmpty){
      data.extractedText = text;
      Navigator.pushNamed(context, ManualEditHighlightRoute, arguments: data);
    }
    print(text);
  }

  Future<bool> _onBackPressed() {
    _clear();
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Are you sure?'),
        content: new Text('Do you want to exit an App'),
        actions: <Widget>[
          new GestureDetector(
            onTap: () => Navigator.of(context).pop(false),
            child: Text("NO"),
          ),
          SizedBox(height: 16),
          new GestureDetector(
            onTap: () => Navigator.of(context).pop(true),
            child: Text("YES"),
          ),
        ],
      ),
    ) ??
        false;
  }

  @override
  void initState() {
    super.initState();
    _clear();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: header(headerText: 'Manual Highlight', screen: HomeScreen(), context: context),
        body: SafeArea(
          child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                     Padding(
                       padding: const EdgeInsets.only(bottom: 5.0),
                       child: Text('Capture/Add Image', style: TextStyle(fontSize: 15.0, color: kDarkColorBlack, letterSpacing: 0.5)),
                     ),
                     isDisabled == false && _imageFile != null ?
                      Center(
                        child: Container(
                          alignment: AlignmentDirectional(0.0, 0.0),
                          constraints: BoxConstraints(
                              maxHeight: 300.0,
                              maxWidth: 300.0,
                              minWidth: 150.0,
                              minHeight: 150.0
                          ),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: FileImage(_imageFile) == null
                                    ? null
                                    : FileImage(_imageFile),
                                fit: BoxFit.contain
                            )
                          ),
                        ),
                      )
                     : Center(
                       child: Container(
                         color: Colors.black12,
                         child: _imageFile == null ? Icon(FontAwesomeIcons.plus, color: kHighlightColorGrey) : null,
                         alignment: AlignmentDirectional(0.0, 0.0),
                         constraints: BoxConstraints(
                             maxHeight: 300.0,
                             maxWidth: 300.0,
                             minWidth: 150.0,
                             minHeight: 150.0
                         ),
                       ),
                     )
                      ],
              ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
            child: Row(
              //direction: Axis.horizontal,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ImageProcessIcons(() => {Navigator.pushNamed(context, ManualHighlightBookShelfRoute)}, Icons.library_books),
                ImageProcessIcons(() => {_pickImage(ImageSource.camera)}, Icons.camera_alt),
                ImageProcessIcons(() => {_pickImage(ImageSource.gallery)}, Icons.image),
                AdditionalImageProcessIcons(_cropImage, Icons.crop, isDisabled),
                AdditionalImageProcessIcons(_recognizeText, Icons.play_arrow, isDisabled),

              ],
            ),
        ),
      );
  }
}

class ImageProcessIcons extends StatelessWidget {

  final Function function;
  final IconData iconButton;

  ImageProcessIcons(this.function, this.iconButton);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
      child: RawMaterialButton(
          onPressed: function,
        child: new Icon(
          iconButton,
          color: kPrimaryColor,
          size: 25.0,
        ),
      ),
      ),
    );
  }
}

class AdditionalImageProcessIcons extends StatelessWidget {

  final Function function;
  final IconData iconButton;
  final bool isDisabled;

  AdditionalImageProcessIcons(this.function, this.iconButton, this.isDisabled);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        child: RawMaterialButton(
          onPressed: isDisabled ? null : function,
          child: new Icon(
            iconButton,
            color: isDisabled ? kHighlightColorDarkGrey : kPrimaryColor,
            size: 25.0,
          ),
        ),
      ),
    );
  }
}

