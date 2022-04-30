import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/video.dart';

class VideoService {
  final CollectionReference<Map<String, dynamic>> _collection;
  VideoService(this._collection);

  //* Add new video
  Future<void> addVideo(Video video) async {
    await _collection
        .doc(video.id)
        .set(
          video.toMap(),
        )
        .catchError((e) {
      debugPrint('"Failed to add video: $e"');
    });
    debugPrint('Add video sucessfully!');
  }

  //* Get list video
  Future<List<Video>?> getVideos() async {
    final query = await _collection.get();

    return query.docs
        .map(
          (doc) => Video.fromMap(doc.data()),
        )
        .toList();
  }

  //* Update video
  Future<void> updateVideo({
    required String videoId,
    required Video videoUpdated,
  }) {
    return _collection
        .doc(videoId)
        .update(videoUpdated.toMap())
        .then(
          (value) => debugPrint("Video Updated"),
        )
        .catchError(
          (error) => debugPrint("Failed to update video: $error"),
        );
  }

  //* Delete video
  Future<void> deleteVideo({
    required String videoId,
  }) {
    return _collection
        .doc(videoId)
        .delete()
        .then(
          (value) => debugPrint("Video Deleted"),
        )
        .catchError(
          (error) => debugPrint("Failed to delete video: $error"),
        );
  }
}
