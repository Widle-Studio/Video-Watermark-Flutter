import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:ib/Controllers/VideoProvider.dart';
import 'package:ib/Models/VideoModel.dart';
import 'package:ib/views/CameraPage.dart';
import 'package:ib/views/PlayLocalVideoScreen.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future openCamera() async {
    availableCameras().then((cameras) async {
      /*   final imagePath = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CameraScreen(cameras), //CameraPage(cameras),
        ),
      );
      setState(() {
      //  _imagePath = imagePath;
      }); */

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CameraScreen(cameras)),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    openCamera();
  }

  @override
  Widget build(BuildContext context) {
    final videoProvider = Provider.of<VideoProvider>(context);

    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    List<VideoModel> _vids = [];

    _vids = videoProvider.getVidList();

    return Scaffold(
        appBar: AppBar(
          title: Text('IB App'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: openCamera,
          child: Icon(
            Icons.photo_camera,
            color: Colors.white,
          ),
          backgroundColor: Colors.blue,
        ),
        body: _vids.length != 0
            ? Container(
                width: width,
                height: height,
                child: ListView.builder(
                  itemCount: _vids.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PlayLocalVideoScreen(
                                    localVid: _vids[index],
                                  )),
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(
                            vertical: 20, horizontal: width * 0.02),
                        height: height * 0.35,
                        width: width,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: 4,
                                  offset: Offset(0, 0),
                                  spreadRadius: 2)
                            ]),
                        child: Stack(
                          children: [
                            Container(
                              height: height * 0.28,
                              width: width,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  image: DecorationImage(
                                      image: FileImage(
                                        (File(_vids[index].thumbnail)),
                                      ),
                                      fit: BoxFit.cover)),
                              child: Center(
                                  child: Icon(
                                Icons.play_arrow,
                                size: 50,
                                color: Colors.white,
                              )),
                            ),
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: Container(
                                margin: EdgeInsets.only(left: 20, bottom: 12),
                                child: Text(
                                  _vids[index].vidName,
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Container(
                                margin: EdgeInsets.only(right: 20, bottom: 12),
                                child: Text(
                                  videoProvider.timeStampToTime(
                                      timeStamp: _vids[index].time),
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              )
            : Container(
                width: width,
                height: height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.video_call,
                      size: 50,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      'No Videos Found..',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ));
  }
}
