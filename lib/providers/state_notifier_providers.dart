import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toptop_app/controllers/comment_controller.dart';
import 'package:toptop_app/controllers/notification_controller.dart';
import 'package:toptop_app/controllers/current_user_controller.dart';
import 'package:toptop_app/controllers/video_controller.dart';
import 'package:toptop_app/models/comment.dart';

import '../models/notification.dart' as notification_model;
import '../models/user.dart' as user_model;
import '../controllers/auth_controller.dart';
import '../models/video.dart';

final authControllerProvider =
    StateNotifierProvider<AuthControllerNotifier, User?>(
  (ref) {
    return AuthControllerNotifier(ref.read);
  },
);

final currentUserControllerProvider = StateNotifierProvider<
    CurrentUserControllerNotifier, AsyncValue<user_model.User?>>(
  (ref) {
    final user = ref.watch(authControllerProvider);

    return CurrentUserControllerNotifier(ref.read, user?.uid);
  },
);

final videoControllerProvider =
    StateNotifierProvider<VideoControllerNotifier, AsyncValue<List<Video>>>(
  (ref) {
    return VideoControllerNotifier(ref.read);
  },
);

final notificationControllerProvider = StateNotifierProvider<
    NotificationControllerNotifier, List<notification_model.Notification>?>(
  (ref) {
    return NotificationControllerNotifier(ref.read);
  },
);

final commentControllerProvider = StateNotifierProvider<
    CommentControllerNotifier, AsyncValue<List<Comment>?>>((ref) {
  return CommentControllerNotifier(ref.read);
});
