import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../Models/VideoModel.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper; // Singleton DatabaseHelper
  static Database _database; // Singleton Database

  String vidTable = 'vid_table';
  String colId = 'id';
  String vidName = 'vidName';
  String vidPath = 'vidPath';
  String address = 'address';
  String latitute = 'latitute';
  String longitute = 'longitute';
  String thumbnail = 'thumbnail';
  String cloudStatus = 'cloudStatus';
  String time = 'time';

  DatabaseHelper._createInstance(); // Named constructor to create instance of DatabaseHelper

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper
          ._createInstance(); // This is executed only once, singleton object
    }
    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    // Get the directory path for both Android and iOS to store database.
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'vids.db';

    // Open/create the database at a given path
    var vidsDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return vidsDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $vidTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $vidName TEXT, $vidPath TEXT, $address TEXT, $latitute TEXT, $longitute TEXT, $thumbnail, $cloudStatus TEXT, $time TEXT)');
  }

  // Fetch Operation: Get all vid objects from database
  Future<List<Map<String, dynamic>>> getVidMapList() async {
    Database db = await this.database;

//		var result = await db.rawQuery('SELECT * FROM $vidTable order by $colTitle ASC');
    var result = await db.query(vidTable, orderBy: '$colId DESC');
    return result;
  }

  // Insert Operation: Insert a vid object to database
  Future<int> insertVideo(VideoModel vid) async {
    Database db = await this.database;
    var result = await db.insert(vidTable, vid.toMap());
    return result;
  }

  // Update Operation: Update a Video object and save it to database
  Future<int> updateVideo(VideoModel vid) async {
    var db = await this.database;
    var result = await db.update(vidTable, vid.toMap(),
        where: '$colId = ?', whereArgs: [vid.id]);
    return result;
  }

  Future<int> updateVideoCompleted(VideoModel vid) async {
    var db = await this.database;
    var result = await db.update(vidTable, vid.toMap(),
        where: '$colId = ?', whereArgs: [vid.id]);
    return result;
  }

  // Delete Operation: Delete a Video object from database
  Future<int> deleteVideo(int id) async {
    var db = await this.database;
    int result = await db.rawDelete('DELETE FROM $vidTable WHERE $colId = $id');
    return result;
  }

  // Get number of Video objects in database
  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) from $vidTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  // Get the 'Map List' [ List<Map> ] and convert it to 'Video List' [ List<Video> ]
  Future<List<VideoModel>> getVidList() async {
    var vidMapList = await getVidMapList(); // Get 'Map List' from database
    int count =
        vidMapList.length; // Count the number of map entries in db table

    List<VideoModel> vidList = List<VideoModel>();
    // For loop to create a 'vid List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      vidList.add(VideoModel.fromMapObject(vidMapList[i]));
    }

    return vidList;
  }
}
