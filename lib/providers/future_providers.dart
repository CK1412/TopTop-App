import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toptop_app/providers/providers.dart';

import '../models/video.dart';

//* get list of videos posted by users
final videosPostedByUserProvider =
    FutureProvider.family<List<Video>?, String>((ref, userId) async {
  return await ref.watch(videoServiceProvider).getVideosPostedByUserId(userId);
});
