import 'dart:async';
import 'dart:io';

import 'package:digibp_appenzell/src/localisation/app_translation.dart';
import 'package:digibp_appenzell/src/models/ApplicationModel.dart';
import 'package:digibp_appenzell/src/ui/home.dart';
import 'package:digibp_appenzell/src/blocs/SubmitApplicationBloc.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:core';


class RegistrationFour extends StatefulWidget {
  Application _application;

  RegistrationFour(Application application) {
    _application = application;
  }

  @override
  State<StatefulWidget> createState() {
    return RegistrationState(_application);
  }
}

class RegistrationState extends State<RegistrationFour> {
  Application _application;

  File _file;
  List<Face> _face = <Face>[];
  FaceDetector _detector;

  List statuses = ['open', 'closed'];
  List eyes = ['left', 'right'];
  List smiles = [true, false];

  var resultMap = Map();


  RegistrationState(Application application) {
    _application = application;
  }

  @override
  void initState() {
    super.initState();
    _generateCaptcha();
    FaceDetectorOptions options = new FaceDetectorOptions(
        mode: FaceDetectorMode.accurate,
        enableLandmarks: true,
        enableClassification: true,
        minFaceSize: 0.15,
        enableTracking: true);
    _detector = FirebaseVision.instance.faceDetector(options);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppTranslations.of(context).text('tab_verification')),
        ),
        body: showBody(_file),
        floatingActionButton: new FloatingActionButton(
          onPressed: () async {
            var file = await ImagePicker.pickImage(source: ImageSource.camera);
            setState(() {
              _file = file;
            });

            if(_file != null) {
              await _detector.processImage(FirebaseVisionImage.fromFile(_file)).then((face) {
                setState(() {
                  if (face.isEmpty) {
                    debugPrint('No face detected');
                    Fluttertoast.showToast(
                        msg: AppTranslations.of(context).text('txt_no_face_detected'),
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIos: 3,
                        backgroundColor: Colors.grey,
                        textColor: Colors.white);
                  } else {
                    debugPrint('Face validation retrieved');
                    _face = face;
                  }
                });
              });
            }
          },
          child: new Icon(Icons.tag_faces),
        ));
  }

  Widget showBody(File file) {
    return new ListView(
      children: <Widget>[
        _displayCaptcha(),
        new Stack(
          children: <Widget>[
            _buildImage(),
            _buildRow(_face),
          ],
        )],
    );
  }

  _generateCaptcha() {
    for (String eye in eyes) {
      resultMap[eye] = 'closed';
      //resultMap[eye] = (statuses..shuffle()).first;
    }
    resultMap['smile'] = false;
    //resultMap['smile'] = (smiles..shuffle()).first;
  }

  Widget _displayCaptcha() {
    return new Container(
      child: Text.rich(
        TextSpan(
            text: '',
            style: TextStyle(fontStyle: FontStyle.italic, fontSize: 14),
            children: <TextSpan> [
              TextSpan(
                  text: 'Before you can finish your application, you need to verify that you are a human by solving belows FaceCaptcha®:\n\n',
                  style: TextStyle(fontStyle: FontStyle.normal, fontSize: 11)
              ),
              TextSpan(
                text: 'Please take a picture of yourself with your ',
              ),
              TextSpan(
                text: 'left eye ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: '${resultMap['left']}',
                style: TextStyle(fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
              ),
              TextSpan(
                text: ' and your ',
              ),
              TextSpan(
                text: 'right eye ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: '${resultMap['right']}',
                style: TextStyle(fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
              ),
              TextSpan(
                text: ', while you are ',
              ),
              TextSpan(
                text: '${resultMap['smile'] ? "smiling" : "not smiling"}',
                style: TextStyle(fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
              ),
              TextSpan(
                text: '!',
              ),
            ]
        ),
      ),
      margin: const EdgeInsets.all(10),

    );
  }

  Widget _buildImage() {
    if (_face.length > 0) _validateImage(_face[0]);
    return new Container(
      margin: _file != null ? EdgeInsets.only(top: 10, left: 30, right: 30) : EdgeInsets.all(10),
      child: new Container(
        child: _file == null
            ? new Text('\nTake a picture of yourself using the Floating Button at the bottom..', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),)
            : new FutureBuilder<Size>(
          future: _getImageSize(Image.file(_file, fit: BoxFit.fitWidth)),
          builder: (BuildContext context, AsyncSnapshot<Size> snapshot) {
            if (snapshot.hasData) {
              return Container(
                  foregroundDecoration: TextDetectDecoration(_face, snapshot.data),
                  child: Image.file(_file, fit: BoxFit.fitWidth));
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  Future _getImageSize(Image image) {
    Completer<Size> completer = new Completer<Size>();
    image.image.resolve(new ImageConfiguration()).addListener(
            (ImageInfo info, bool _) => completer.complete(
            Size(info.image.width.toDouble(), info.image.height.toDouble())));
    return completer.future;
  }

  _validateImage(Face face) {
    _checkData(_face);
    debugPrint('face validation');
    if (face == null || face.smilingProbability == null || face.leftEyeOpenProbability == null || face.rightEyeOpenProbability == null) return;
    bool validLeft;
    bool validRight;
    bool validSmile;
    resultMap['left'] == 'open'
        ?
    face.leftEyeOpenProbability >= 0.5 ? validLeft = true : validLeft = false
        :
    face.leftEyeOpenProbability < 0.5 ? validLeft = true : validLeft = false;

    resultMap['right'] == 'open'
        ?
    face.rightEyeOpenProbability >= 0.5 ? validRight = true : validRight = false
        :
    face.rightEyeOpenProbability < 0.5 ? validRight = true : validRight = false;

    resultMap['smile']
        ?
    face.smilingProbability >= 0.5 ? validSmile = true : validSmile = false
        :
    face.smilingProbability < 0.5 ? validSmile = true : validSmile = false;

    debugPrint('left: $validLeft right: $validRight smile: $validSmile');

    Fluttertoast.showToast(
        msg: AppTranslations.of(context).text(
            (validLeft && validRight && validSmile) ? 'txt_face_verified' :
            !validSmile ? 'txt_error_smile' : 'txt_error_eyes'
        ),
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 3,
        backgroundColor: Colors.grey,
        textColor: Colors.white);

    if (validLeft && validRight && validSmile) {
      bloc.insertCase(_application).then((success) {
        debugPrint('Application Submitted: $success');
        if(success) {
          Fluttertoast.showToast(
              msg: AppTranslations.of(context).text('txt_application_created'),
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIos: 5,
              backgroundColor: Colors.grey,
              textColor: Colors.white);
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return Home();
          }));
        } else {
          Fluttertoast.showToast(
              msg: AppTranslations.of(context).text('txt_application_error'),
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIos: 5,
              backgroundColor: Colors.grey,
              textColor: Colors.white);
        }
      });
    }
  }

  void _checkData(List<Face> faceList) {
    final double uncomputedProb = -1.0;
    final int uncompProb = -1;
    print('Length: ${faceList.length}');

    for (int i = 0; i < faceList.length; i++) {
      Rect bounds = faceList[i].boundingBox;
      print('Rectangle : $bounds');

      FaceLandmark landmark =
      faceList[i].getLandmark(FaceLandmarkType.leftEar);

      if (landmark != null) {
        Offset leftEarPos = landmark.position;
        print('Left Ear Pos : $leftEarPos');
      }

      if (faceList[i].smilingProbability != uncomputedProb) {
        double smileProb = faceList[i].smilingProbability;
        print('Smile Prob : $smileProb');
      }

      if (faceList[i].rightEyeOpenProbability != uncomputedProb) {
        double rightEyeOpenProb = faceList[i].rightEyeOpenProbability;
        print('RightEye Open Prob : $rightEyeOpenProb');
      }

      if (faceList[i].trackingId != uncompProb) {
        int tID = faceList[i].trackingId;
        print('Tracking ID : $tID');
      }
    }
  }

  /*
    LeftEyeOpenProbability : left Eye Open Probability
    RightEyeOpenProbability : right Eye Open Probability
    SmilingProbability : Smiling probability
  */
  Widget _buildRow(List faces) {
    if (faces == null || faces.length == 0) return Container(width: 0, height: 0);
    for(Face face in faces) {
      return ListTile(
        title: new Text(
          '\nLeftEyeOpenProbability : ${face.leftEyeOpenProbability} '
              '\nRightEyeOpenProbability : ${face.rightEyeOpenProbability} '
              '\nSmileProb : ${face.smilingProbability} ',
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
        ),
        dense: true,
      );
    }
  }
}

class _TextDetectPainter extends BoxPainter {
  final List<Face> _faceLabels;
  final Size _originalImageSize;
  _TextDetectPainter(faceLabels, originalImageSize)
      : _faceLabels = faceLabels,
        _originalImageSize = originalImageSize;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final paint = new Paint()
      ..strokeWidth = 2.0
      ..color = Colors.red
      ..style = PaintingStyle.stroke;

    final _heightRatio = _originalImageSize.height / configuration.size.height;
    final _widthRatio = _originalImageSize.width / configuration.size.width;
    for (var faceLabel in _faceLabels) {
      final _rect = Rect.fromLTRB(
          offset.dx + faceLabel.boundingBox.left / _widthRatio,
          offset.dy + faceLabel.boundingBox.top / _heightRatio,
          offset.dx + faceLabel.boundingBox.right / _widthRatio,
          offset.dy + faceLabel.boundingBox.bottom / _heightRatio);

      canvas.drawRect(_rect, paint);
    }
  }
}

class TextDetectDecoration extends Decoration {
  final Size _originalImageSize;
  final List<Face> _texts;
  TextDetectDecoration(List<Face> texts, Size originalImageSize)
      : _texts = texts,
        _originalImageSize = originalImageSize;

  @override
  BoxPainter createBoxPainter([VoidCallback onChanged]) {
    return new _TextDetectPainter(_texts, _originalImageSize);
  }
}