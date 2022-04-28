import 'package:flutter/material.dart';
import 'package:toptop_app/models/video.dart';
import 'package:toptop_app/services/instance.dart';

class VideoService {
  static final VideoService instance = VideoService._internal();
  VideoService._internal();

  final _collection = fireDatabase.collection('videos');

  final collectionStream = fireDatabase.collection('videos').snapshots();

  //* Add new video
  Future<void> add(Video video) async {
    await _collection.doc(video.id).set(video.toMap()).catchError((e) {
      debugPrint('"Failed to add video: $e"');
    });
    debugPrint('Add video sucessfully!');
  }

  //* Get infor video by id
  Future<Video?> getVideo(String videoId) async {
    final doc = await _collection.doc(videoId).get();
    if (doc.exists) {
      return Video.fromMap(doc.data()!);
    } else {
      return null;
    }
  }

  //* Update video
  Future<void> update({
    required String videoId,
    required Video videoUpdated,
  }) {
    return _collection
        .doc(videoId)
        .update(videoUpdated.toMap())
        .then((value) => debugPrint("Video Updated"))
        .catchError(
          (error) => debugPrint("Failed to update video: $error"),
        );
  }
}
