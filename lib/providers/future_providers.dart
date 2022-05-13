import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toptop_app/providers/state_notifier_providers.dart';

import '../models/video.dart';

//* get list of videos posted by users
final videosPostedByUserProvider =
    FutureProvider.family<List<Video>?, String>((ref, userId) async {
  final videos = ref.watch(videoControllerProvider).value;
  return videos!.where((video) => video.userId == userId).toList();
});
