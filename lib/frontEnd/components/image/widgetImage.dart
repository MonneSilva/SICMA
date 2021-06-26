import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

class ToImage extends StatefulWidget {
  ToImage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _ToImageState createState() => _ToImageState();
}

class _ToImageState extends State<ToImage> {
  int _counter = 0;
  File _imageFile;

  //Create an instance of ScreenshotController
  ScreenshotController screenshotController = ScreenshotController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    var result;
    return Scaffold(
      body: Container(
        child: new Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Screenshot(
                controller: screenshotController,
                child: Column(
                  children: <Widget>[
                    Text(
                      'You have pushed the button this many times:' +
                          _counter.toString(),
                    ),
                    FlutterLogo(),
                  ],
                ),
              ),
              _imageFile != null ? Image.file(_imageFile) : Container(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _incrementCounter();
          _imageFile = null;
          /*
          screenshotController
              .capture(delay: Duration(milliseconds: 10))
              .then((File image) async {
            //print("Capture Done");
            setState(() {
              _imageFile = image;
            });
            result = image.readAsBytesSync();
            print("File Saved to Gallery");
          }).catchError((onError) {
            print(onError);
          });*/
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  _saved(File image) async {
    final result = await ImageGallerySaver.saveImage(image.readAsBytesSync());
    print("File Saved to Gallery");
  }
}
