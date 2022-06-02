import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/comment.dart';
import '../providers/providers.dart';
import '../utils/custom_exception.dart';

class CommentControllerNotifier
    extends StateNotifier<AsyncValue<List<Comment>?>> {
  final Reader _reader;

  CommentControllerNotifier(this._reader) : super(const AsyncValue.loading());

  // get list reversed by Date
  Future<void> retrieveCommentsByVideo(String videoId) async {
    try {
      final comments =
          await _reader(commentServiceProvider).getCommentByVideo(videoId);

      comments!.sort(
        (a, b) => b.createdDate.compareTo(a.createdDate),
      );

      if (mounted) {
        state = AsyncValue.data(comments);
      }
    } on FirebaseException catch (e) {
      state = AsyncValue.error(e);
    }
  }

  // insert index 0
  Future<void> addComment(Comment comment) async {
    try {
      await _reader(commentServiceProvider).addComment(comment);
      if (mounted) {
        state = AsyncValue.data(state.value!..insert(0, comment));
      }
    } on FirebaseException catch (e) {
      throw CustomException(message: e.message);
    }
  }

  Future<void> updateComment({
    required String commentId,
    required Comment commentUpdated,
  }) async {
    try {
      await _reader(commentServiceProvider).updateComment(
        commentId: commentId,
        commentUpdated: commentUpdated,
      );
      state.whenData((comments) {
        state = AsyncValue.data([
          for (final video in comments!)
            if (video.id == commentId) commentUpdated else video
        ]);
      });
    } on FirebaseException catch (e) {
      throw CustomException(message: e.message);
    }
  }

  Future<void> deleteComment({
    required String commentId,
  }) async {
    try {
      await _reader(commentServiceProvider).deleteComment(
        commentId: commentId,
      );
      state.whenData((comments) {
        state = AsyncValue.data(
          comments!..removeWhere((comment) => comment.id == commentId),
        );
      });
    } on FirebaseException catch (e) {
      throw CustomException(message: e.message);
    }
  }
}
