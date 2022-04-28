import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toptop_app/models/video.dart';
import 'package:toptop_app/services/auth_service.dart';
import 'package:toptop_app/services/video_service.dart';
import 'package:toptop_app/models/user.dart' as models;
import '../services/user_service.dart';

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

final userProvider = Provider<UserService>((ref) {
  return UserService.instance;
});

final videoProvider = Provider<VideoService>((ref) {
  return VideoService.instance;
});

//! GET VIDEOS
final getVideosProvider = StreamProvider<List<Video>>((ref) async* {
  final stream = ref.read(videoProvider).collectionStream;
  yield* stream.map(
    (snapshot) => snapshot.docs
        .map(
          (doc) => Video.fromMap(doc.data()),
        )
        .toList(),
  );
});

//* pause/play video
final videoStateProvider = StateProvider<bool>((ref) {
  return true;
});

final getUserProvider =
    FutureProvider.family<models.User?, String>((ref, userId) async {
  final userService = ref.read(userProvider);
  return userService.getUser(userId);
});
