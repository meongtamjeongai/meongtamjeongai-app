class UserProfile {
  final String username;
  final String? profileImagePath;

  UserProfile({required this.username, this.profileImagePath});

  Map<String, dynamic> toJson() => {
    'username': username,
    'profileImagePath': profileImagePath,
  };
}
