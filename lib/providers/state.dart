import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toptop_app/services/auth_service.dart';

import '../services/firestore_service.dart';

//! AUTH

// access all the functions of the authentication
final authProvider = Provider<AuthService>((ref) {
  return AuthService.instance;
});

// check state login or log out
// Below is user of firebase_auth, not of me.
final authStateProvider = StreamProvider<User?>((ref) {
  return ref.read(authProvider).authStateChange;
});

//! STORE

final firestoreProvider = Provider<FirestoreService>((ref) {
  return FirestoreService.instance;
});
