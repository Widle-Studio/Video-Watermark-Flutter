import 'package:flutter/material.dart';
import 'package:ib/views/HomePage.dart';
import 'dart:async';
import 'package:permission_handler/permission_handler.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  Future<bool> checkPermssion() async {
    var status = await Permission.location.status;
    if (status.isUndetermined) {
      requestPermission().then((value) {
        return value;
      });
    } else if (status.isGranted) {
      return true;
    } else if (status.isDenied) {
      return false;
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
      return false;
    } else {
      return false;
    }
  }

  Future<bool> requestPermission() async {
    final status = await Permission.location.request();
    //   final newstatus = await Permission.camera.request();
    if (status.isGranted) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomePage()));
      return true;
    } else {
      return false;
    }
  }

  @override
  void initState() {
    checkPermssion().then((permission) {
      if (permission == true) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      } else {
        requestPermission();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(),
    );
  }
}
