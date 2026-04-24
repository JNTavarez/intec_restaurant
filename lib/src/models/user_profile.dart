class UserProfile {
  final String uid;
  final String name;
  final String username;
  final String bio;
  final String profileImageUrl;

  UserProfile({
    required this.uid,
    required this.name,
    required this.username,
    required this.bio,
    required this.profileImageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'full_name': name,
      'user_name': username,
      'bio': bio,
      'profile_image': profileImageUrl,
    };
  }

  factory UserProfile.fromFirestore(Map<String, dynamic> map, String id) {
    return UserProfile(
      uid: id,
      name: map['full_name'] ?? '',
      username: map['user_name'] ?? '',
      bio: map['bio'] ?? '',
      profileImageUrl: map['profile_image'] ?? '',
    );
  }
}