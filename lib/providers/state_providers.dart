import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toptop_app/models/video.dart';
import 'package:toptop_app/providers/future_providers.dart';

import '../src/constants.dart';

//* pause/play video
final videoStateProvider = StateProvider<bool>((ref) {
  return true;
});

//* keep controller of current video
final videoPlayerControllerProvider =
    StateProvider<VideoPlayerController?>((ref) {
  return null;
});

//* get total like of videos posted by user Id
final totalLikeVideosPostedByUserProvider =
    StateProvider.family<int, String>((ref, userId) {
  List<Video>? videos;
  ref.watch(videosPostedByUserProvider(userId)).whenData((value) {
    videos = value;
  });
  var likes = videos?.map((e) => e.userIdLiked.length);
  // final totalLike = likes?.reduce((value, element) => value + element);

  return likes?.fold(0, (previousValue, element) => previousValue! + element) ??
      0;
});

// //* build layout search state
final searchStateProvider = StateProvider<SearchState>((ref) {
  return SearchState.buildInitData;
});

final searchTextProvider = StateProvider<String>((ref) {
  return '';
});
