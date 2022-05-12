import 'dart:convert';

class Comment {
  final String id;
  final String commentText;
  final DateTime createdDateTime;
  final String userId;
  final String avatarUrl;
  final String username;
  final String videoId;
  final List userIdLiked;
  Comment({
    required this.id,
    required this.commentText,
    required this.createdDateTime,
    required this.userId,
    required this.avatarUrl,
    required this.username,
    required this.videoId,
    required this.userIdLiked,
  });

  Comment copyWith({
    String? id,
    String? commentText,
    DateTime? createdDateTime,
    String? userId,
    String? avatarUrl,
    String? username,
    String? videoId,
    List? userIdLiked,
  }) {
    return Comment(
      id: id ?? this.id,
      commentText: commentText ?? this.commentText,
      createdDateTime: createdDateTime ?? this.createdDateTime,
      userId: userId ?? this.userId,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      username: username ?? this.username,
      videoId: videoId ?? this.videoId,
      userIdLiked: userIdLiked ?? this.userIdLiked,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      CommentField.id: id,
      CommentField.commentText: commentText,
      CommentField.createdDateTime: createdDateTime.millisecondsSinceEpoch,
      CommentField.userId: userId,
      CommentField.avatarUrl: avatarUrl,
      CommentField.username: username,
      CommentField.videoId: videoId,
      CommentField.userIdLiked: userIdLiked,
    };
  }

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      id: map[CommentField.id] ?? '',
      commentText: map[CommentField.commentText] ?? '',
      createdDateTime: DateTime.fromMillisecondsSinceEpoch(
        map[CommentField.createdDateTime],
      ),
      userId: map[CommentField.userId] ?? '',
      avatarUrl: map[CommentField.avatarUrl] ?? '',
      username: map[CommentField.username] ?? '',
      videoId: map[CommentField.videoId] ?? '',
      userIdLiked: List.from(map[CommentField.userIdLiked]),
    );
  }

  String toJson() => json.encode(toMap());

  factory Comment.fromJson(String source) =>
      Comment.fromMap(json.decode(source));
}

class CommentField {
  static const String id = 'id';
  static const String commentText = 'commentText';
  static const String createdDateTime = 'createdDateTime';
  static const String userId = 'userId';
  static const String avatarUrl = 'avatarUrl';
  static const String username = 'username';
  static const String videoId = 'videoId';
  static const String userIdLiked = 'userIdLiked';
}
