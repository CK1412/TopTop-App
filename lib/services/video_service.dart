import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:toptop_app/models/video.dart';

class VideoService {
  static final VideoService instance = VideoService._internal();
  VideoService._internal();

  final _collection = FirebaseFirestore.instance.collection('videos');

  final collectionStream =
      FirebaseFirestore.instance.collection('videos').snapshots();

  Future<void> addVideo(Video video) async {
    await _collection.doc(video.id).set(video.toMap()).catchError((e) {
      debugPrint('"Failed to add video: $e"');
    });
    debugPrint('Add video sucessfully!');
  }

  Future<Video?> getVideo(String videoId) async {
    final doc = await _collection.doc(videoId).get();
    if (doc.exists) {
      return Video.fromMap(doc.data()!);
    } else {
      return null;
    }
  }

  Future<void> updateVideo({
    required String videoId,
    required Video videoUpdated,
  }) {
    return _collection
        .doc(videoId)
        .update(videoUpdated.toMap())
        .then((value) => debugPrint("User Updated"))
        .catchError(
          (error) => debugPrint("Failed to update user: $error"),
        );
  }
}
