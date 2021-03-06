import 'dart:async';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ib/Controllers/CameraProvider.dart';
import 'package:ib/Controllers/VideoProvider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:tapioca/tapioca.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';
import 'package:screenshot/screenshot.dart';

class CameraScreen extends StatefulWidget {
  final List<CameraDescription> cameras;
  CameraScreen(this.cameras);
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  bool _toggleCamera = false;
  CameraController controller;

  bool isLoading = false;

  //Create an instance of ScreenshotController
  ScreenshotController screenshotController = ScreenshotController();

  Future<String> getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    // debugPrint('location: ${position.latitude}');
    lat = position.latitude.toString();
    long = position.longitude.toString();
    setState(() {});
    final coordinates = new Coordinates(position.latitude, position.longitude);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    print("${first.featureName} : ${first.addressLine}");
    return first.addressLine.toString();
  }

  Timer _timer;
  int _start = 30;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  bool isVid = false;

  String address = "";
  String lat = "";
  String long = "";

/* 
video values
 */

  String videoName;
  String latitude;
  String longitude;
  String videoPath;

  Future listenForTime(BuildContext context) async {
    if (controller != null &&
        controller.value.isInitialized &&
        controller.value.isRecordingVideo) {
      videoRecorded().then((vid) async {
        final videoProvider =
            Provider.of<VideoProvider>(this.context, listen: false);
        final cameraProvider =
            Provider.of<CameraProvider>(this.context, listen: false);

        _timer.cancel();
        setState(() {
          _start = 30;
          isLoading = true;
        });
        var tempDir = await getTemporaryDirectory();
        final savedVideoPath = '${tempDir.path}/${timestamp()}.mp4';
        print("temp dir: $tempDir");
        screenshotController.capture().then((Uint8List img) {
          print("captured");
          setState(() {
            isLoading = true;
          });
          try {
            final tapiocaBalls = [
              /*   TapiocaBall.textOverlay(
                                        address, 0, 90, 20, Color(0xffffc0cb)), */

              TapiocaBall.imageOverlay(img, 10, 10),
            ];

            final cup = Cup(Content(vid), tapiocaBalls);
            cup.suckUp(savedVideoPath).then((newvid) async {
              if (savedVideoPath != null) {
                setState(() {
                  _timer.cancel();
                  // _start = 30;
                  isLoading = false;
                });

                cameraProvider
                    .getvidThumb(vidPath: savedVideoPath)
                    .then((thumb) {
                  videoProvider
                      .save(
                          address: address,
                          latitude: lat.toString(),
                          longitude: long.toString(),
                          thumbnail: thumb,
                          time: DateTime.now().toString(),
                          vidName: savedVideoPath.split("/").last.trim(),
                          vidPath: savedVideoPath)
                      .then((val) {
                    videoProvider.getVideoList();
                    Fluttertoast.showToast(
                        msg: "Video Saved",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.white.withOpacity(0.6),
                        textColor: Colors.black,
                        fontSize: 16.0);
                  });
                });

                /*  Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                      
                          PlayVideoScreen(
                            path: savedVideoPath,
                          )),

                ); */

              } else {
                print('no path');
                setState(() {
                  isLoading = false;
                });
              }
            });
          } on PlatformException {
            print("error!!!!");
            setState(() {
              isLoading = false;
            });
          }
          setState(() {});
        }).catchError((onError) {
          print("captured error : $onError");
        });
      }).catchError((err) {
        print("screen error");
      });
      _timer.cancel();
    }

    // return vidValueModel;
  }

  Stream<int> timedCounter() async* {
    if (_start == 0) {
      print("30 done");
    }
  }

  @override
  void initState() {
    getLocation().then((adrs) {
      print("address: adrs");
      address = adrs;
      setState(() {});
    });
    onCameraSelected(widget.cameras[0]);
    super.initState();

    timedCounter();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  Widget cameraWidget(context) {
    var camera = controller.value;

    final size = MediaQuery.of(context).size;

    var scale = size.aspectRatio * camera.aspectRatio;

    // to prevent scaling down, invert the value
    if (scale < 1) scale = 1 / scale;

    return Transform.scale(
      scale: scale,
      child: Center(
        child: CameraPreview(
          controller,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  margin: EdgeInsets.only(top: 50),
                  child: Material(child: Text(_start.toString())),
                ),
              ),
              Positioned(
                bottom: 10,
                left: 60,
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                      width: size.width * 0.4,
                      child: Screenshot(
                        controller: screenshotController,
                        child: Text(
                          "$address\n\n Lat: $lat\nLong: $long",
                          style: TextStyle(
                            fontSize: 9,
                            backgroundColor: Colors.white.withOpacity(0.5),
                          ),
                        ),
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  XFile videoFile;
  VideoPlayerController videoController;
  VoidCallback videoPlayerListener;

  Future<Uint8List> screenShot() async {
    Uint8List _imageFile;
    await screenshotController.capture().then((Uint8List image) {
      //Capture Done
      setState(() {
        _imageFile = image;
      });
    }).catchError((onError) {
      print(onError);
    });

    return _imageFile;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.cameras.isEmpty) {
      return Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(16.0),
        child: Text(
          'No Camera Found',
          style: TextStyle(
            fontSize: 16.0,
            color: Colors.white,
          ),
        ),
      );
    }

    if (!controller.value.isInitialized) {
      return Container();
    }

    return Container(
      child: Stack(
        //   alignment: FractionalOffset.center,
        children: [
          cameraWidget(this.context),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.2,
              padding: EdgeInsets.all(20.0),
              color: Color.fromRGBO(00, 00, 00, 0.7),
              child: Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment.center,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.all(Radius.circular(50.0)),
                        onTap: () {
                          //  _captureImage();
                          if (controller != null &&
                              controller.value.isInitialized &&
                              controller.value.isRecordingVideo) {
                            listenForTime(this.context).then((vidValue) {});
                          } else {
                            startVideoRecording().then((val) {
                              startTimer();
                            });
                          }

                          Future.delayed(const Duration(seconds: 30), () {
                            listenForTime(this.context);
                          });
                        },
                        child: Container(
                            padding: EdgeInsets.all(4.0),
                            child: controller.value.isRecordingVideo
                                ? Card(
                                    shape: CircleBorder(),
                                    color: Colors.red,
                                    child: SizedBox(
                                      width: 60.0,
                                      height: 60.0,
                                    ),
                                  )
                                : isLoading == false
                                    ? Image.asset(
                                        'assets/ic_shutter_1.png',
                                        width: 72.0,
                                        height: 72.0,
                                      )
                                    : CircularProgressIndicator()),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.all(Radius.circular(50.0)),
                        onTap: () {
                          if (!_toggleCamera) {
                            onCameraSelected(widget.cameras[1]);
                            setState(() {
                              _toggleCamera = true;
                            });
                          } else {
                            onCameraSelected(widget.cameras[0]);
                            setState(() {
                              _toggleCamera = false;
                            });
                          }
                        },
                        child: Container(
                            width: 42.0,
                            height: 42.0,
                            padding: EdgeInsets.all(4.0),
                            child: Image.asset(
                              'assets/ic_switch_camera_3.png',
                              color: Colors.grey[200],
                              width: 42.0,
                              height: 42.0,
                            )),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          isLoading
              ? Container(
                  color: Colors.transparent,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.4,
                      ),
                      //  CircularProgressIndicator(),
                      SizedBox(
                        height: 50,
                      ),
                      Material(
                          child: Text(
                        'Rendering video with location',
                        style: TextStyle(
                            color: Colors.black, backgroundColor: Colors.white),
                      )),
                      SizedBox(
                        height: 50,
                      ),
                      Material(
                          child: Text(
                        'Please Wait ... ',
                        style: TextStyle(
                            color: Colors.black, backgroundColor: Colors.white),
                      )),
                    ],
                  ),
                )
              : SizedBox()
        ],
      ),
    );
  }

  void onCameraSelected(CameraDescription cameraDescription) async {
    if (controller != null) await controller.dispose();
    controller = CameraController(cameraDescription, ResolutionPreset.medium);

    controller.addListener(() {
      if (mounted) setState(() {});
      if (controller.value.hasError) {
        showMessage('Camera Error: ${controller.value.errorDescription}');
      }
    });

    try {
      await controller.initialize();
    } on CameraException catch (e) {
      showException(e);
    }

    if (mounted) setState(() {});
  }

  String timestamp() => new DateTime.now().millisecondsSinceEpoch.toString();

  Future<void> startVideoRecording() async {
    if (!controller.value.isInitialized) {
      //  showInSnackBar('Error: select a camera first.');
      return;
    }

    if (controller.value.isRecordingVideo) {
      // A recording is already started, do nothing.
      return;
    }

    try {
      await controller.startVideoRecording();
    } on CameraException catch (e) {
      //    _showCameraException(e);
      print(e);
      return;
    }
  }

  Future<String> videoRecorded() async {
    if (!controller.value.isInitialized) {
      showMessage('Error: select a camera first.');
      return null;
    }

    if (controller.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }

    try {
      await controller.stopVideoRecording().then((vid) {
        videoFile = vid;
        setState(() {});
        return vid.path;
      });
    } on CameraException catch (e) {
      showException(e);
      return null;
    }
    return videoFile.path;
  }

  Future<XFile> stopVideoRecording() async {
    if (!controller.value.isRecordingVideo) {
      return null;
    }

    try {
      return controller.stopVideoRecording();
    } on CameraException catch (e) {
      return null;
    }
  }

  void showException(CameraException e) {
    logError(e.code, e.description);
    showMessage('Error: ${e.code}\n${e.description}');
  }

  void showMessage(String message) {
    print(message);
  }

  void logError(String code, String message) =>
      print('Error: $code\nMessage: $message');
}

class VidValueModel {
  String videoName;
  String latitude;
  String longitude;
  String videoPath;

  VidValueModel(
      {@required this.videoName,
      @required this.videoPath,
      @required this.latitude,
      @required this.longitude});
}
