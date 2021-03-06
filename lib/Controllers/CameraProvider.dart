import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'dart:async';
import 'package:flutter/cupertino.dart';

class CameraProvider with ChangeNotifier {
  CameraProvider() {}

  Uint8List bytes;

  Future<String> getvidThumb({@required String vidPath}) async {
    final uint8list = await VideoThumbnail.thumbnailFile(
      video: vidPath,
      thumbnailPath: (await getTemporaryDirectory()).path,
      imageFormat: ImageFormat.JPEG,
      maxHeight:
          250, // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
      quality: 90,
    );

    return uint8list;
  }
}
