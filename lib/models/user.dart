import 'dart:convert';

class User {
  final String id;
  final String userId;
  final String name;
  final String email;
  final String avatarUrl;
  final String bio;
  final List followers;
  final List following;

  User({
    required this.id,
    this.userId = '',
    required this.name,
    required this.email,
    this.avatarUrl = '',
    this.bio = '',
    this.followers = const [],
    this.following = const [],
  });

  User copyWith({
    String? userId,
    String? name,
    String? email,
    String? avatarUrl,
    String? bio,
    List? followers,
    List? following,
  }) {
    return User(
      id: id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      bio: bio ?? this.bio,
      followers: followers ?? this.followers,
      following: following ?? this.following,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      UserField.id: id,
      UserField.userId: userId,
      UserField.name: name,
      UserField.email: email,
      UserField.avatarUrl: avatarUrl,
      UserField.bio: bio,
      UserField.followers: followers,
      UserField.following: following,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map[UserField.id] ?? '',
      userId: map[UserField.userId] ?? '',
      name: map[UserField.name] ?? '',
      email: map[UserField.email] ?? '',
      avatarUrl: map[UserField.avatarUrl] ?? '',
      bio: map[UserField.bio] ?? '',
      followers: List.from(map[UserField.followers]),
      following: List.from(map[UserField.following]),
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));
}

class UserField {
  static const String id = 'id';
  static const String userId = 'userId';
  static const String name = 'name';
  static const String email = 'email';
  static const String avatarUrl = 'avatarUrl';
  static const String bio = 'bio';
  static const String followers = 'followers';
  static const String following = 'following';
}
