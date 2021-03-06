import 'dart:typed_data';

import 'package:flutter/material.dart';

class Imageview extends StatefulWidget {
  final Uint8List img;
  Imageview(this.img);

  @override
  _ImageviewState createState() => _ImageviewState();
}

class _ImageviewState extends State<Imageview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Image.memory(
          widget.img,
          width: 100,
          height: 150,
        ),
      ),
    );
  }
}
