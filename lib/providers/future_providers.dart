import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toptop_app/providers/providers.dart';
import 'package:toptop_app/providers/state_notifier_providers.dart';

import '../models/video.dart';
import '../models/user.dart' as user_model;

//* get list of videos posted by users
final videosPostedByUserProvider =
    FutureProvider.family<List<Video>?, String>((ref, userId) async {
  final videos = ref.watch(videoControllerProvider).value;
  return videos!.where((video) => video.userId == userId).toList();
});

//* get user by ID
final userByIdProvider =
    FutureProvider.autoDispose.family<user_model.User?, String>(
  (ref, id) async {
    return ref.watch(userServiceProvider).getUserByID(id);
  },
);

// * get video by ID
final videoByIdProvider = FutureProvider.autoDispose.family<Video?, String>(
  (ref, id) async {
    return ref.watch(videoServiceProvider).getVideoById(id);
  },
);
