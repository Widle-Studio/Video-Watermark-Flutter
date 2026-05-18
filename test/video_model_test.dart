import 'package:flutter_test/flutter_test.dart';
import 'package:video_watermark/Models/VideoModel.dart';

void main() {
  group('VideoModel Tests', () {
    test('toMap() should return a correct map', () {
      final video = VideoModel(
        'test_video',
        '/path/to/video',
        '12.34',
        '56.78',
        'thumb.jpg',
        'uploaded',
        '2023-10-27 10:00:00',
        '123 Test St',
      );

      final map = video.toMap();

      expect(map['vidName'], 'test_video');
      expect(map['vidPath'], '/path/to/video');
      expect(map['latitute'], '12.34');
      expect(map['longitute'], '56.78');
      expect(map['thumbnail'], 'thumb.jpg');
      expect(map['cloudStatus'], 'uploaded');
      expect(map['time'], '2023-10-27 10:00:00');
      expect(map['address'], '123 Test St');
      expect(map.containsKey('id'), isFalse);
    });

    test('toMap() should include id if present', () {
      final video = VideoModel.withId(
        1,
        'test_video',
        '/path/to/video',
        '12.34',
        '56.78',
        'thumb.jpg',
        'uploaded',
        '2023-10-27 10:00:00',
        '123 Test St',
      );

      final map = video.toMap();

      expect(map['id'], 1);
      expect(map['vidName'], 'test_video');
    });

    test('fromMapObject() should create a correct VideoModel', () {
      final map = {
        'id': 1,
        'vidName': 'test_video',
        'vidPath': '/path/to/video',
        'address': '123 Test St',
        'latitute': '12.34',
        'longitute': '56.78',
        'thumbnail': 'thumb.jpg',
        'cloudStatus': 'uploaded',
        'time': '2023-10-27 10:00:00',
      };

      final video = VideoModel.fromMapObject(map);

      expect(video.id, 1);
      expect(video.vidName, 'test_video');
      expect(video.vidPath, '/path/to/video');
      expect(video.address, '123 Test St');
      expect(video.latitute, '12.34');
      expect(video.longitute, '56.78');
      expect(video.thumbnail, 'thumb.jpg');
      expect(video.cloudStatus, 'uploaded');
      expect(video.time, '2023-10-27 10:00:00');
    });

    test('Setters should respect length constraints and update correct fields',
        () {
      final video = VideoModel('', '', '', '', '', '', '');

      video.vidName = 'New Name';
      expect(video.vidName, 'New Name');

      video.vidPath = 'New Path';
      expect(video.vidPath, 'New Path');
      // Verify the fix: vidPath setter should not change vidName
      expect(video.vidName, 'New Name');

      video.address = 'New Address';
      expect(video.address, 'New Address');

      video.latitute = '1.1';
      expect(video.latitute, '1.1');

      video.longitute = '2.2';
      expect(video.longitute, '2.2');

      video.thumbnail = 'new.jpg';
      expect(video.thumbnail, 'new.jpg');

      video.cloudStatus = 'pending';
      expect(video.cloudStatus, 'pending');

      video.time = '2023-11-01';
      expect(video.time, '2023-11-01');
    });

    test('Setters should ignore values longer than 255 characters', () {
      final video = VideoModel('Initial', '', '', '', '', '', '');
      final longString = 'a' * 256;

      video.vidName = longString;
      expect(video.vidName, 'Initial');
    });
  });
}
