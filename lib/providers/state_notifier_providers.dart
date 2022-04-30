import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toptop_app/controllers/user_controller.dart';
import 'package:toptop_app/controllers/video_controller.dart';

import '../models/user.dart' as user_models;
import '../controllers/auth_controller.dart';
import '../models/video.dart';

final authControllerProvider =
    StateNotifierProvider<AuthControllerNotifier, User?>(
  (ref) {
    return AuthControllerNotifier(ref.read);
  },
);

final userControllerProvider = StateNotifierProvider<UserControllerNotifier,
    AsyncValue<user_models.User?>>(
  (ref) {
    final user = ref.watch(authControllerProvider);

    return UserControllerNotifier(ref.read, user?.uid);
  },
);

final videoControllerProvider =
    StateNotifierProvider<VideoControllerNotifier, AsyncValue<List<Video>>>(
  (ref) {
    return VideoControllerNotifier(ref.read);
  },
);
