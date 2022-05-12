import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:toptop_app/models/comment.dart';

class CommentService {
  final CollectionReference<Map<String, dynamic>> _collection;
  CommentService(this._collection);

  //* Add new comment
  Future<void> addComment(Comment comment) async {
    await _collection
        .doc(comment.id)
        .set(
          comment.toMap(),
        )
        .catchError((e) {
      debugPrint('"Failed to add comment: $e"');
    });
    debugPrint('Add comment sucessfully!');
  }

  //* Get all comment list by video
  Future<List<Comment>?> getCommentByVideo(String videoId) async {
    final query = await _collection.get();

    return query.docs
        .where((doc) => doc.get(CommentField.videoId) == videoId)
        .map(
          (doc) => Comment.fromMap(doc.data()),
        )
        .toList();
  }

  //* Update comment
  Future<void> updateComment({
    required String commentId,
    required Comment commentUpdated,
  }) async {
    return await _collection
        .doc(commentId)
        .update(commentUpdated.toMap())
        .then(
          (value) => debugPrint("Comment Updated"),
        )
        .catchError(
          (error) => debugPrint("Failed to update comment: $error"),
        );
  }

  //* Delete comment
  Future<void> deleteComment({
    required String commentId,
  }) async {
    return await _collection
        .doc(commentId)
        .delete()
        .then(
          (value) => debugPrint("Comment Deleted"),
        )
        .catchError(
          (error) => debugPrint("Failed to delete comment: $error"),
        );
  }
}
