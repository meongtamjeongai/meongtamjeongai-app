class UserProfile {
  final String nickname;
  final String? profileImagePath;

  UserProfile({required this.nickname, this.profileImagePath});

  Map<String, dynamic> toJson() => {
    'nickname': nickname,
    'profileImagePath': profileImagePath,
  };
}
