import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:tflite/tflite.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData.dark().copyWith(
            primaryColor: Color(0xFF0A0E21),
            scaffoldBackgroundColor: Color(0xFF0A0E21)),
        home: Scaffold(
            appBar: AppBar(
              title: Center(
                child: Text(
                  'WASTE  CLASSIFIER',
                  style: TextStyle(fontSize: 24.0),
                ),
              ),
            ),
            body: Center(child: MyImagePicker())));
  }
}

class MyImagePicker extends StatefulWidget {
  @override
  MyImagePickerState createState() => MyImagePickerState();
}

class MyImagePickerState extends State {
  File imageURI;
  String result;
  String path;

  Future getImageFromCamera() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      imageURI = image;
      path = image.path;
    });
  }

  Future getImageFromGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      imageURI = image;
      path = image.path;
    });
  }

  Future classifyImage() async {
    await Tflite.loadModel(
        model: "assets/garbage.tflite", labels: "assets/labels.txt");
    var output = await Tflite.runModelOnImage(
        path: path,
        imageMean: 0.0, // defaults to 117.0
        imageStd: 255.0, // defaults to 1.0
        numResults: 2, // defaults to 5
        threshold: 0.2, // defaults to 0.1
        asynch: true);

    setState(() {
      result = output.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
          imageURI == null
              ? Text('No image selected.')
              : Image.file(imageURI,
                  width: 300, height: 200, fit: BoxFit.cover),
          Row(
            children: <Widget>[
              Expanded(
                child: GestureDetector(
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Icon(
                            FontAwesomeIcons.camera,
                            size: 70.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Text(
                              'Select Image From Camera',
                              style: TextStyle(fontSize: 12.0),
                            ),
                          ),
                        ],
                      ),
                    ),
                    margin: EdgeInsets.all(15.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        (10.0),
                      ),
                      color: Color(0xFF1D1E33),
                    ),
                  ),
                  onTap: () => getImageFromCamera(),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Icon(
                            FontAwesomeIcons.photoVideo,
                            size: 70.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Text(
                              'Select Image From Gallery',
                              style: TextStyle(fontSize: 12.0),
                            ),
                          ),
                        ],
                      ),
                    ),
                    margin: EdgeInsets.all(15.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        (10.0),
                      ),
                      color: Color(0xFF1D1E33),
                    ),
                  ),
                  onTap: () => getImageFromGallery(),
                ),
              ),
            ],
          ),
          // Container(
          //   margin: EdgeInsets.fromLTRB(0, 30, 0, 20),
          //   child: RaisedButton(
          //     onPressed: () => getImageFromCamera(),
          //     child: Text(
          //       'Click Here To Select Image From Camera',
          //       style: TextStyle(fontSize: 16.0),
          //     ),
          //     textColor: Colors.white,
          //     color: Color(0xFF1D1E33),
          //     padding: EdgeInsets.fromLTRB(14, 14, 14, 14),
          //     elevation: 10.0,
          //     shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadius.circular(20.0),
          //     ),
          //   ),
          // ),
          // Container(
          //     margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
          //     child: RaisedButton(
          //       onPressed: () => getImageFromGallery(),
          //       child: Text(
          //         'Click Here To Select Image From Gallery',
          //         style: TextStyle(fontSize: 16.0),
          //       ),
          //       textColor: Colors.white,
          //       color: Color(0xFF1D1E33),
          //       padding: EdgeInsets.fromLTRB(14, 14, 14, 14),
          //       elevation: 10.0,
          //       shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(20.0),
          //       ),
          //     )),
          Container(
              margin: EdgeInsets.fromLTRB(0, 30, 0, 20),
              child: RaisedButton(
                onPressed: () => classifyImage(),
                child: Text(
                  'Classify Image',
                  style: TextStyle(fontSize: 18.0),
                ),
                textColor: Colors.white,
                color: Color(0xFFEB1555),
                padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
                elevation: 10.0,
              )),
          result == null
              ? Text(
                  'Result',
                  style: TextStyle(color: Colors.white),
                )
              : Text(
                  result,
                  style: TextStyle(color: Colors.white),
                )
        ])));
  }
}
