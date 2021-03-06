import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

final FirebaseFirestore db = FirebaseFirestore.instance;
final auth = FirebaseAuth.instance;
String userUid = auth.currentUser.uid.toString();

FirebaseFirestore fireStoreSnapshotRef = FirebaseFirestore.instance;

FirebaseStorage storage = FirebaseStorage.instance;

// upload paths

String profileImagePath = "video/";
