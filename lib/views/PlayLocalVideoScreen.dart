import 'package:ib/Controllers/VideoProvider.dart';
import 'package:ib/Models/VideoModel.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PlayLocalVideoScreen extends StatefulWidget {
  final VideoModel localVid;
  PlayLocalVideoScreen({@required this.localVid});
  @override
  _PlayVideoScreenState createState() => _PlayVideoScreenState();
}

class _PlayVideoScreenState extends State<PlayLocalVideoScreen> {
  VideoPlayerController _vidcontroller;

/*   void _initPlayer(String s) {
    try {
      _vidcontroller = VideoPlayerController.file(File(s));

      _vidcontroller.initialize().then((value) => {
            _vidcontroller.addListener(() {
              //custom Listner
              setState(() {
                if (!_vidcontroller.value.isPlaying &&
                    _vidcontroller.value.initialized &&
                    (_vidcontroller.value.duration ==
                        _vidcontroller.value.position)) {
                  //checking the duration and position every time
                  //Video Completed//

                  setState(() {});
                }
              });
            })
          });
    } catch (Exception) {
      print(Exception);
    }
  } */

  saveVid() async {
    GallerySaver.saveVideo(widget.localVid.vidPath).then((path) {
      Fluttertoast.showToast(
          msg: "Video Saved In Gallery",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.white.withOpacity(0.7),
          textColor: Colors.black,
          fontSize: 16.0);
    });
  }

  @override
  void initState() {
    super.initState();
    _vidcontroller = VideoPlayerController
        . //network('https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4')
        file(File(widget.localVid.vidPath))
      ..initialize().then((_) {
        _vidcontroller.addListener(() {
          //custom Listner
          setState(() {
            if (!_vidcontroller.value.isPlaying &&
                _vidcontroller.value.initialized &&
                (_vidcontroller.value.duration ==
                    _vidcontroller.value.position)) {
              //checking the duration and position every time
              //Video Completed//

              setState(() {});
            }
          });
        });

        setState(() {});
      });
    //   saveVid();
  }

  @override
  Widget build(BuildContext context) {
    final videoProvider = Provider.of<VideoProvider>(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        actions: [
          Row(
            children: [
              GestureDetector(
                  onTap: () {
                    saveVid();
                  },
                  child: Icon(Icons.download_rounded)),
              SizedBox(
                width: 20,
              ),
              GestureDetector(
                  onTap: () {
                    videoProvider
                        .delete(
                            context: this.context, vidModel: widget.localVid)
                        .then((deleted) {
                      if (deleted == true) {
                        Fluttertoast.showToast(
                            msg: "Video Deleted",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.white.withOpacity(0.6),
                            textColor: Colors.black,
                            fontSize: 16.0);
                        Navigator.pop(context);
                      } else {
                        Fluttertoast.showToast(
                            msg: "Some Error Occured",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.white.withOpacity(0.6),
                            textColor: Colors.black,
                            fontSize: 16.0);
                      }
                    });
                  },
                  child: Icon(
                    Icons.delete,
                    color: Colors.redAccent,
                  )),
              SizedBox(
                width: 20,
              ),
            ],
          )
        ],
      ),
      body: Center(
        child: _vidcontroller.value.initialized
            ? AspectRatio(
                aspectRatio: _vidcontroller.value.aspectRatio,
                child: VideoPlayer(_vidcontroller),
              )
            : Container(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (!_vidcontroller.value.isPlaying) {
            await _vidcontroller.seekTo(Duration.zero);
            _vidcontroller.play();
            setState(() {});
          } else {
            _vidcontroller.value.isPlaying
                ? _vidcontroller.pause()
                : _vidcontroller.play();
            setState(() {});
          }
        },
        child: Icon(
          _vidcontroller.value.isPlaying ? Icons.stop : Icons.refresh,
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _vidcontroller.dispose();
  }
}
