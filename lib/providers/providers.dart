import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toptop_app/services/user_service.dart';
import 'package:toptop_app/services/video_service.dart';

import '../models/video.dart';
import '../services/auth_service.dart';
import '../services/storage_service.dart';
import 'state_notifier_providers.dart';

//! FIREBASE

//* For Authentication related functions you need an instance of FirebaseAuth
final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

//* create an instance of Cloud firestore
final firebaseFirestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

//* create an instance of Cloud Storage
final firebaseStorageProvider = Provider<FirebaseStorage>((ref) {
  return FirebaseStorage.instance;
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

final storageServiceProvider = Provider<StorageService>((ref) {
  return StorageService(ref.read);
});

final videoServiceProvider = Provider<VideoService>((ref) {
  return VideoService(
    ref.read(firebaseFirestoreProvider).collection('videos'),
  );
});

//! OTHER
//* get list of videos liked by users
final videosLikedByUserProvider =
    Provider.family<List<Video>?, String>((ref, userId) {
  final videosState = ref.watch(videoControllerProvider);

  if (videosState is AsyncData) {
    return videosState.value!
        .where((video) => video.userIdLiked.contains(userId))
        .toList();
  }
  return null;
});


