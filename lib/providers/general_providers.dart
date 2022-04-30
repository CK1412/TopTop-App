import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toptop_app/services/user_service.dart';

import '../services/auth_service.dart';

//! FIREBASE

//* For Authentication related functions you need an instance of FirebaseAuth
final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

//* create an instance of Cloud firestore
final firebaseFirestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

//! SERVICES

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(ref.read);
});

final userServiceProvider = Provider<UserService>((ref) {
  return UserService(
    ref.read(firebaseFirestoreProvider).collection('users'),
  );
});
