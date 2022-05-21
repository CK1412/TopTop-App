import 'dart:convert';

class Video {
  final String id;
  final List userIdLiked;
  int commentCount;
  int shareCount;
  final String songName;
  final String caption;
  final String videoUrl;
  final String thumbnailUrl;
  final DateTime createdDate;
  final DateTime recentUpdatedDate;
  // infor user created
  final String userId;
  final String username;
  final String userAvatarUrl;
  final String type;

  Video({
    required this.id,
    required this.userIdLiked,
    this.commentCount = 0,
    this.shareCount = 0,
    required this.songName,
    this.caption = '',
    required this.videoUrl,
    required this.thumbnailUrl,
    required this.createdDate,
    required this.recentUpdatedDate,
    required this.userId,
    required this.username,
    required this.userAvatarUrl,
    required this.type,
  });

  void increaseCommentCount() => commentCount++;

  void increaseShareCount() => shareCount++;

  Video copyWith({
    String? id,
    List? userIdLiked,
    int? commentCount,
    int? shareCount,
    String? songName,
    String? caption,
    String? videoUrl,
    String? thumbnailUrl,
    DateTime? createdDate,
    required DateTime recentUpdatedDate,
    String? userId,
    String? username,
    String? userAvatarUrl,
    String? type,
  }) {
    return Video(
      id: id ?? this.id,
      userIdLiked: userIdLiked ?? this.userIdLiked,
      commentCount: commentCount ?? this.commentCount,
      shareCount: shareCount ?? this.shareCount,
      songName: songName ?? this.songName,
      caption: caption ?? this.caption,
      videoUrl: videoUrl ?? this.videoUrl,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      createdDate: createdDate ?? this.createdDate,
      recentUpdatedDate: recentUpdatedDate,
      userId: userId ?? this.userId,
      username: username ?? this.username,
      userAvatarUrl: userAvatarUrl ?? this.userAvatarUrl,
      type: type ?? this.type,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      VideoField.id: id,
      VideoField.userIdLiked: userIdLiked,
      VideoField.commentCount: commentCount,
      VideoField.shareCount: shareCount,
      VideoField.songName: songName,
      VideoField.caption: caption,
      VideoField.videoUrl: videoUrl,
      VideoField.thumbnailUrl: thumbnailUrl,
      VideoField.createdDate: createdDate.millisecondsSinceEpoch,
      VideoField.recentUpdatedDate: recentUpdatedDate.millisecondsSinceEpoch,
      VideoField.userId: userId,
      VideoField.username: username,
      VideoField.userAvatarUrl: userAvatarUrl,
      VideoField.type: type,
    };
  }

  factory Video.fromMap(Map<String, dynamic> map) {
    return Video(
      id: map[VideoField.id] ?? '',
      userIdLiked: map[VideoField.userIdLiked] ?? [],
      commentCount: map[VideoField.commentCount]?.toInt() ?? 0,
      shareCount: map[VideoField.shareCount]?.toInt() ?? 0,
      songName: map[VideoField.songName] ?? '',
      caption: map[VideoField.caption] ?? '',
      videoUrl: map[VideoField.videoUrl] ?? '',
      thumbnailUrl: map[VideoField.thumbnailUrl] ?? '',
      createdDate: DateTime.fromMillisecondsSinceEpoch(
        map[VideoField.createdDate],
      ),
      recentUpdatedDate: DateTime.fromMillisecondsSinceEpoch(
        map[VideoField.recentUpdatedDate],
      ),
      userId: map[VideoField.userId] ?? '',
      username: map[VideoField.username] ?? '',
      userAvatarUrl: map[VideoField.userAvatarUrl] ?? '',
      type: map[VideoField.type] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Video.fromJson(String source) => Video.fromMap(json.decode(source));
}

class VideoField {
  static const String id = 'id';
  static const String userIdLiked = 'userIdLiked';
  static const String commentCount = 'commentCount';
  static const String shareCount = 'shareCount';
  static const String songName = 'songName';
  static const String caption = 'caption';
  static const String videoUrl = 'videoUrl';
  static const String thumbnailUrl = 'thumbnailUrl';
  static const String createdDate = 'createdDate';
  static const String recentUpdatedDate = 'recentUpdatedDate';
  static const String userId = 'userId';
  static const String username = 'username';
  static const String userAvatarUrl = 'userAvatarUrl';
  static const String type = 'type';
}
