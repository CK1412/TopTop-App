import 'dart:convert';

class User {
  final String id;
  final String username;
  final String email;
  final String phoneNumber;
  final String avatarUrl;
  final String bio;
  final List followers;
  final List following;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.phoneNumber,
    this.avatarUrl = '',
    this.bio = '',
    this.followers = const [],
    this.following = const [],
  });

  User copyWith({
    String? username,
    String? email,
    String? phoneNumber,
    String? avatarUrl,
    String? bio,
    List? followers,
    List? following,
  }) {
    return User(
      id: id,
      username: username ?? this.username,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      bio: bio ?? this.bio,
      followers: followers ?? this.followers,
      following: following ?? this.following,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      UserField.id: id,
      UserField.username: username,
      UserField.email: email,
      UserField.phoneNumber: phoneNumber,
      UserField.avatarUrl: avatarUrl,
      UserField.bio: bio,
      UserField.followers: followers,
      UserField.following: following,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map[UserField.id] ?? '',
      username: map[UserField.username] ?? '',
      email: map[UserField.email] ?? '',
      phoneNumber: map[UserField.phoneNumber] ?? '',
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
  static const String username = 'username';
  static const String email = 'email';
  static const String phoneNumber = 'phoneNumber';
  static const String avatarUrl = 'avatarUrl';
  static const String bio = 'bio';
  static const String followers = 'followers';
  static const String following = 'following';
}
