import 'package:flutter/material.dart';
import 'package:ib/Models/VideoModel.dart';
import 'package:ib/Utils/DatabaseHelper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';

class VideoProvider with ChangeNotifier {
  VideoProvider() {
    getVideoList();
  }

  DatabaseHelper helper = DatabaseHelper();

  List<VideoModel> videoList = [];
  int count = 0;

  getVidList() => videoList;

  Future<bool> save(
      {@required String vidName,
      @required String vidPath,
      @required String thumbnail,
      @required String latitude,
      @required String longitude,
      @required String address,
      @required String time}) async {
    var videoModel = VideoModel(
        vidName, vidPath, latitude, longitude, thumbnail, "no", time, address);

    int result;
    if (videoModel.id != null) {
      // Case 1: Update operation
      result = await helper.updateVideo(videoModel);
    } else {
      result = await helper.insertVideo(videoModel);
    }

    if (result != 0) {
      // Success
      //	_showAlertDialog('Status', 'FoodTruckModel Saved Successfully');
      return true;
    } else {
      return false;
      // Failure
      //	_showAlertDialog('Status', 'Problem Saving FoodTruckModel');
    }
  }

  Future<bool> delete(
      {@required BuildContext context, @required VideoModel vidModel}) async {
    int result = await helper.deleteVideo(vidModel.id);
    if (result != 0) {
      getVideoList();
      return true;
    } else {
      return false;
    }
  }

  getVideoList() async {
    final Future<Database> dbFuture = helper.initializeDatabase();
    await dbFuture.then((database) async {
      Future<List<VideoModel>> videoListFuture = helper.getVidList();
      videoListFuture.then((vidList) {
        this.videoList = vidList;
        this.count = vidList.length;
        notifyListeners();
      });
    });
  }

  String timeStampToTime({timeStamp}) {
    var time = DateTime.parse(timeStamp);
    String formattedDate = DateFormat('kk:mm | dd-MM-yyyy').format(time);
    return formattedDate;
  }
}
