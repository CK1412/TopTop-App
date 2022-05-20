import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

class User {
  final String id;
  final String username;
  final String email;
  final String phoneNumber;
  final String avatarUrl;
  final String bio;
  final List followers;
  final List following;
  final DateTime createdDate;
  final DateTime recentUpdatedDate;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.phoneNumber,
    required this.avatarUrl,
    this.bio = '',
    required this.followers,
    required this.following,
    required this.createdDate,
    required this.recentUpdatedDate,
  });

  User copyWith({
    String? id,
    String? username,
    String? email,
    String? phoneNumber,
    String? avatarUrl,
    String? bio,
    List? followers,
    List? following,
    DateTime? createdDate,
    required DateTime recentUpdatedDate,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      bio: bio ?? this.bio,
      followers: followers ?? this.followers,
      following: following ?? this.following,
      createdDate: createdDate ?? this.createdDate,
      recentUpdatedDate: recentUpdatedDate,
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
      UserField.createdDate: createdDate.millisecondsSinceEpoch,
      UserField.recentUpdatedDate: recentUpdatedDate.millisecondsSinceEpoch,
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
      createdDate: DateTime.fromMillisecondsSinceEpoch(
        map[UserField.createdDate],
      ),
      recentUpdatedDate: DateTime.fromMillisecondsSinceEpoch(
        map[UserField.recentUpdatedDate],
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  factory User.fromFirebaseAuth(firebase_auth.User user) => User(
        id: user.uid,
        username: user.displayName ?? '',
        email: user.email ?? '',
        phoneNumber: user.phoneNumber ?? '',
        avatarUrl: user.photoURL ?? '',
        followers: [],
        following: [],
        createdDate: DateTime.now(),
        recentUpdatedDate: DateTime.now(),
      );
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
  static const String createdDate = 'createdDate';
  static const String recentUpdatedDate = 'recentUpdatedDate';
}
