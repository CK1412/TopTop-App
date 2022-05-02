import 'dart:convert';

class Video {
  String id;
  List userIdLiked;
  int commentCount;
  int shareCount;
  String songName;
  String caption;
  String videoUrl;
  String thumbnailUrl;
  // infor user created
  String userId;
  String username;
  String userAvatarUrl;

  Video({
    required this.id,
    this.userIdLiked = const [],
    this.commentCount = 0,
    this.shareCount = 0,
    required this.songName,
    this.caption = '',
    required this.videoUrl,
    this.thumbnailUrl = '',
    required this.userId,
    required this.username,
    required this.userAvatarUrl,
  });

  Video copyWith({
    String? id,
    List? userIdLiked,
    int? commentCount,
    int? shareCount,
    String? songName,
    String? caption,
    String? videoUrl,
    String? thumbnailUrl,
    String? userId,
    String? username,
    String? userAvatarUrl,
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
      userId: userId ?? this.userId,
      username: username ?? this.username,
      userAvatarUrl: userAvatarUrl ?? this.userAvatarUrl,
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
      VideoField.userId: userId,
      VideoField.username: username,
      VideoField.userAvatarUrl: userAvatarUrl,
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
      userId: map[VideoField.userId] ?? '',
      username: map[VideoField.username] ?? '',
      userAvatarUrl: map[VideoField.userAvatarUrl] ?? '',
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
  static const String userId = 'userId';
  static const String username = 'username';
  static const String userAvatarUrl = 'userAvatarUrl';
}
