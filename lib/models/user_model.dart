class UserModel {
  final String uid;
  final String email;
  final String name;
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
      uid: map['\$id'] as String,
      email: map['email'] as String,
      name: map['name'] as String,
      bio: map['bio'] as String,
      profilePic: map['profilePic'] as String,
      bannerPic: map['bannerPic'] as String,
      followers: List<String>.from((map['followers'] as List<String>)),
      following: List<String>.from((map['following'] as List<String>)),
      isTwitterBlue: map['isTwitterBlue'] as bool,
    );
  }

  @override
  String toString() {
    return 'UserModel(uid: $uid, email: $email, name: $name, bio: $bio, profilePic: $profilePic, bannerPic: $bannerPic, followers: $followers, following: $following, isTwitterBlue: $isTwitterBlue)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;
    return other.uid == uid && other.email == email && other.name == name && other.bio == bio && other.profilePic == profilePic && other.bannerPic == bannerPic && other.followers == followers && other.following == following && other.isTwitterBlue == isTwitterBlue;
  }

  @override
  int get hashCode {
    return uid.hashCode ^ email.hashCode ^ name.hashCode ^ bio.hashCode ^ profilePic.hashCode ^ bannerPic.hashCode ^ followers.hashCode ^ following.hashCode ^ isTwitterBlue.hashCode;
  }
}