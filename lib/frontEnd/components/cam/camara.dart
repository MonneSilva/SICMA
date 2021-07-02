import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';

// A screen that allows users to take a picture using a given camera.
class TakePictureScreen extends StatefulWidget {
  final CameraDescription camera;
  final ValueChanged<dynamic> onTaken;
  const TakePictureScreen({
    Key key,
    @required this.camera,
    this.onTaken,
  }) : super(key: key);

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  CameraController _controller;

  Future<void> _initializeControllerFuture;
  List positions = ['Frontal', 'Posterior', 'Lateral Derecho'];
  int _index = 0;
  List<dynamic> paths = [];

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.max,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  void _handleChanged(data) {
    widget.onTaken(data);
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(80.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                AppBar(
                  automaticallyImplyLeading: false,
                  leading: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColorLight,
                      borderRadius: new BorderRadius.only(
                        bottomRight: const Radius.circular(10.0),
                        topRight: const Radius.circular(10.0),
                      ),
                    ),
                    margin: EdgeInsets.only(top: 3, bottom: 3),
                    child: IconButton(
                      color: Theme.of(context).primaryColorLight,
                      icon: Icon(
                        Icons.keyboard_arrow_left,
                        color: Colors.white,
                        size: 30,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  bottomOpacity: 0.0,
                  elevation: 0.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          bottomLeft: Radius.circular(20))),
                  backgroundColor: Colors.transparent,
                )
              ])),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return new Stack(
              alignment: FractionalOffset.center,
              children: <Widget>[
                new Positioned.fill(
                  child: new AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: new CameraPreview(_controller)),
                ),
                new Positioned.fill(
                  child: new Opacity(
                    opacity: 0.7,
                    child: Padding(
                        padding: EdgeInsets.only(bottom: 80),
                        child: Image.asset(
                          'lib/frontEnd/assets/image/overlaycamera.png',
                          fit: BoxFit.fill,
                        )),
                  ),
                ),
                Positioned.fill(
                  top: 700,
                  child: new Opacity(
                      opacity: 0.9,
                      child: Container(
                        color: Colors.white,
                      )),
                ),
                Positioned.fill(
                    top: 25,
                    child: new Opacity(
                      opacity: 0.9,
                      child: Text(
                        positions[_index],
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 25),
                      ),
                    )),
              ],
            );
          } else {
            // Otherwise, display a loading indicator.
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(Icons.camera_alt),
        // Provide an onPressed callback.
        onPressed: () async {
          // Take the Picture in a try / catch block. If anything goes wrong,
          // catch the error.
          try {
            // Ensure that the camera is initialized.
            await _initializeControllerFuture;

            // Construct the path where the image should be saved using the
            // pattern package.

            // Attempt to take a picture and log where it's been saved.
            final image = await _controller.takePicture();

            _showMaterialDialog(image.path);
            print(image.path);
            _handleChanged(false);

            // If the picture was taken, display it on a new screen.
            //print('hola.5');

            // Navigator.pop(context, path);
          } catch (e) {
            // If an error occurs, log the error to the console.
            print(e);
          }
        },
      ),
    );
  }

  _showMaterialDialog(path) {
    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
              title: new Text(positions[_index]),
              content: Image.file(File(path)),
              actions: <Widget>[
                FlatButton(
                  child: Text('Cancelar'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                FlatButton(
                  child: Text('Aceptar'),
                  onPressed: () {
                    paths.add(path);
                    setState(() {
                      if (_index < positions.length) _index++;
                    });

                    Navigator.of(context).pop();
                    if (_index == positions.length) Navigator.of(context).pop();
                  },
                )
              ],
            ));
  }
}

// ignore: must_be_immutable
class Miniature extends StatefulWidget {
  String globalpath;
  bool phototaken = false;
  Map medidas = Map();
  Miniature({this.onTaken});
  final ValueChanged<dynamic> onTaken;

  @override
  State<StatefulWidget> createState() {
    return new _MiniatureState();
  }
}

class _MiniatureState extends State<Miniature> {
  bool photoTaken = true;
  void _handleChanged(state) {
    widget.onTaken(state);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Opacity(
            opacity: 0.9,
            child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[100],
                  boxShadow: [
                    BoxShadow(color: Colors.white10, spreadRadius: 3),
                  ],
                ),
                height: 500,
                alignment: Alignment.center,
                //color: Colors.grey,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      photoTaken
                          ? Icon(
                              Icons.camera_alt_outlined,
                              color: Theme.of(context).primaryColorLight,
                              size: 100,
                            )
                          : Icon(
                              Icons.accessibility_new,
                              color: Theme.of(context).primaryColorLight,
                              size: 100,
                            ),
                      photoTaken
                          ? FlatButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                              color: Theme.of(context).primaryColor,
                              textColor: Colors.white,
                              onPressed: () async {
                                WidgetsFlutterBinding.ensureInitialized();
                                final cameras = await availableCameras();
                                final firstCamera = cameras.first;
                                //print('hol');
                                /*final path = await*/ Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TakePictureScreen(
                                        camera: firstCamera,
                                        onTaken: (state) {
                                          photoTaken = state;
                                        }),
                                  ),
                                );
                                /*if (path != null) {
                            setState(() {
                              //print('$path');
                              widget.globalpath = path;
                              widget.phototaken = true;
                            });
                          }*/
                              },
                              child: Text('Tomar fotografía'),
                            )
                          : FlatButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                              color: Theme.of(context).primaryColor,
                              textColor: Colors.white,
                              onPressed: () async {
                                _handleChanged(false);
                              },
                              child: Text('Obtener medidas'),
                            ),
                    ])))
      ],
    );
  }
}
