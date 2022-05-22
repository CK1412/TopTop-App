import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toptop_app/providers/providers.dart';
import 'package:toptop_app/utils/custom_exception.dart';

import '../models/video.dart';

class VideoControllerNotifier extends StateNotifier<AsyncValue<List<Video>>> {
  final Reader _reader;
  VideoControllerNotifier(this._reader) : super(const AsyncValue.loading()) {
    retrieveVideos();
  }

  Future<void> retrieveVideos({bool isRefreshing = false}) async {
    if (isRefreshing) state = const AsyncValue.loading();
    try {
      final videos = await _reader(videoServiceProvider).getVideos();
      debugPrint('Get video from firestore');
      if (mounted) {
        state = AsyncValue.data(videos!);
      }
    } on FirebaseException catch (e) {
      state = AsyncValue.error(e);
    }
  }

  Future<void> addVideo(Video video) async {
    try {
      await _reader(videoServiceProvider).addVideo(video);
      state.whenData(
        (videos) => state = AsyncValue.data(videos..add(video)),
      );
    } on FirebaseException catch (e) {
      throw CustomException(message: e.message);
    }
  }

  Future<void> updateVideo({
    required String videoId,
    required Video videoUpdated,
  }) async {
    try {
      await _reader(videoServiceProvider).updateVideo(
        videoId: videoId,
        videoUpdated: videoUpdated,
      );
      state.whenData((videos) {
        state = AsyncValue.data([
          for (final video in videos)
            if (video.id == videoId) videoUpdated else video
        ]);
      });
    } on FirebaseException catch (e) {
      throw CustomException(message: e.message);
    }
  }

  Future<void> deleteVideo({
    required String videoId,
  }) async {
    try {
      await _reader(videoServiceProvider).deleteVideo(
        videoId: videoId,
      );
      state.whenData((videos) {
        state = AsyncValue.data(
          videos..removeWhere((video) => video.id == videoId),
        );
      });
    } on FirebaseException catch (e) {
      throw CustomException(message: e.message);
    }
  }
}
