import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:toptop_app/models/user.dart' as models;

late models.User currentUser;

// For Authentication related functions you need an instance of FirebaseAuth
final FirebaseAuth fireAuth = FirebaseAuth.instance;

// create an instance of Cloud firestore
final FirebaseFirestore fireDatabase = FirebaseFirestore.instance;

// create an instance of FirebaseStorage
final FirebaseStorage fireStorage = FirebaseStorage.instance;
