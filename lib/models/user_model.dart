class UserModel {
  final String uid;
  final String email;
  final String name;
  final String username;
  final String bio;
  final String profilePic;
  final String bannerPic;
  final List<String> followers;
  final List<String> following;
  final bool isTwitterBlue;

  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    required this.username,
    required this.bio,
    required this.profilePic,
    required this.bannerPic,
    required this.followers,
    required this.following,
    required this.isTwitterBlue,
  });

  UserModel copyWith({
    String? uid,
    String? email,
    String? name,
    String? username,
    String? bio,
    String? profilePic,
    String? bannerPic,
    List<String>? followers,
    List<String>? following,
    bool? isTwitterBlue,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      name: name ?? this.name,
      username: username ?? this.username,
      bio: bio ?? this.bio,
      profilePic: profilePic ?? this.profilePic,
      bannerPic: bannerPic ?? this.bannerPic,
      followers: followers ?? this.followers,
      following: following ?? this.following,
      isTwitterBlue: isTwitterBlue ?? this.isTwitterBlue,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email,
      'name': name,
      'username': username,
      'bio': bio,
      'profilePic': profilePic,
      'bannerPic': bannerPic,
      'followers': followers,
      'following': following,
      'isTwitterBlue': isTwitterBlue,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      username: map['username'] ?? '',
      followers: List<String>.from(map['followers'] ?? []),
      following: List<String>.from(map['following'] ?? []),
      profilePic: map['profilePic'] ?? '',
      bannerPic: map['bannerPic'] ?? '',
      uid: map['\$id'] ?? '',
      bio: map['bio'] ?? '',
      isTwitterBlue: map['isTwitterBlue'] ?? false,
    );
  }

  @override
  String toString() {
    return 'UserModel(uid: $uid, email: $email, name: $name, username: $username, bio: $bio, profilePic: $profilePic, bannerPic: $bannerPic, followers: $followers, following: $following, isTwitterBlue: $isTwitterBlue)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;
    return other.uid == uid && other.email == email && other.name == name && other.username == username && other.bio == bio && other.profilePic == profilePic && other.bannerPic == bannerPic && other.followers == followers && other.following == following && other.isTwitterBlue == isTwitterBlue;
  }

  @override
  int get hashCode {
    return uid.hashCode ^ email.hashCode ^ name.hashCode ^ username.hashCode ^ bio.hashCode ^ profilePic.hashCode ^ bannerPic.hashCode ^ followers.hashCode ^ following.hashCode ^ isTwitterBlue.hashCode;
  }
}
