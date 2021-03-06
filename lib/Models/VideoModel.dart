class VideoModel {
  int _id;
  String _vidName;
  String _vidPath;
  String _address;
  String _latitute;
  String _longitute;
  String _thumbnail;
  String _cloudStatus;
  String _time;

  VideoModel(this._vidName, this._vidPath, this._latitute, this._longitute,
      this._thumbnail, this._cloudStatus, this._time,
      [this._address]);

  VideoModel.withId(this._id, this._vidName, this._vidPath, this._latitute,
      this._longitute, this._thumbnail, this._cloudStatus, this._time,
      [this._address]);

  int get id => _id;

  String get vidName => _vidName;
  String get vidPath => _vidPath;

  String get address => _address;

  String get latitute => _latitute;

  String get longitute => _longitute;

  String get thumbnail => _thumbnail;

  String get cloudStatus => _cloudStatus;

  String get time => _time;

  set vidName(String newVid) {
    if (newVid.length <= 255) {
      this._vidName = newVid;
    }
  }

  set vidPath(String newVidPath) {
    if (newVidPath.length <= 255) {
      this._vidName = newVidPath;
    }
  }

  set address(String newAddress) {
    if (newAddress.length <= 255) {
      this._address = newAddress;
    }
  }

  set latitute(String newLat) {
    if (newLat.length <= 255) {
      this._latitute = newLat;
    }
  }

  set longitute(String newLong) {
    if (newLong.length <= 255) {
      this._longitute = newLong;
    }
  }

  set thumbnail(String newthumbnail) {
    if (newthumbnail.length <= 255) {
      this._thumbnail = newthumbnail;
    }
  }

  set cloudStatus(String status) {
    if (status.length <= 255) {
      this._cloudStatus = status;
    }
  }

  set time(String newTime) {
    this._time = newTime;
  }

  // Convert a Note object into a Map object
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = _id;
    }
    map['vidName'] = _vidName;
    map['vidPath'] = _vidPath;
    map['address'] = _address;
    map['longitute'] = _longitute;
    map['latitute'] = _latitute;
    map['thumbnail'] = _thumbnail;
    map['cloudStatus'] = _cloudStatus;
    map['time'] = _time;

    return map;
  }

  // Extract a Note object from a Map object
  VideoModel.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._vidName = map['vidName'];
    this._vidPath = map['vidPath'];
    this._address = map['address'];
    this.latitute = map['latitute'];
    this.longitute = map['longitute'];
    this._thumbnail = map['thumbnail'];
    this.cloudStatus = map['cloudStatus'];
    this._time = map['time'];
  }
}
