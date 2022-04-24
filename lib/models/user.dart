import 'dart:convert';

class User {
  final String uid;
  final String name;
  final String email;
  final String phoneNumber;
  final String avatarUrl;
  final String bio;
  final List followers;
  final List following;

  User({
    required this.uid,
    required this.name,
    required this.email,
    required this.phoneNumber,
    this.avatarUrl = '',
    this.bio = '',
    this.followers = const [],
    this.following = const [],
  });

  User copyWith({
    String? uid,
    String? name,
    String? email,
    String? phoneNumber,
    String? avatarUrl,
    String? bio,
    List? followers,
    List? following,
  }) {
    return User(
      uid: this.uid,
      name: name ?? this.name,
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
      UserField.uid: uid,
      UserField.name: name,
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
      uid: map[UserField.uid] ?? '',
      name: map[UserField.name] ?? '',
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
  static const String uid = 'uid';
  static const String name = 'name';
  static const String email = 'email';
  static const String phoneNumber = 'phoneNumber';
  static const String avatarUrl = 'avatarUrl';
  static const String bio = 'bio';
  static const String followers = 'followers';
  static const String following = 'following';
}
