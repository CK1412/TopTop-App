import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toptop_app/controllers/user_controller.dart';

import '../models/user.dart' as user_models;
import '../controllers/auth_controller.dart';

// final authControllerProvider =
//     StateNotifierProvider<AuthControllerNotifier, user_models.User?>(
//   (ref) {
//     return AuthControllerNotifier(ref.read);
//   },
// );

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
