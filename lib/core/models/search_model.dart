class UserModel {
  final String id;
  final String name;
  final String mail;
  final String imageUrl;
  final String coverImage;
  final String bio;
  final List<dynamic> followers;
  final List<dynamic> following;
  UserModel({
    required this.followers,
    required this.following,
    required this.coverImage,
    required this.id,
    required this.name,
    required this.mail,
    required this.imageUrl,
    required this.bio,
  });

  factory UserModel.fromFirestore(Map<String, dynamic> data) {
    return UserModel(
      followers: List<String>.from(data['followers'] ?? []),
      following: List<String>.from(data['following'] ?? []),
      id: data['id'],
      name: data['name'] ?? '',
      mail: data['mail'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      coverImage: data['coverImage'] ?? '',
      bio: data['bio'] ?? '',
    );
  }
}
