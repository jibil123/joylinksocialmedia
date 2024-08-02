class Users {
  final String userId;
  final String bio;
  final String coverImage;
  final String name;
  final String profilePic;
  final String mail;
  final List<String> followers;
  final List<String> following;
  Users({
    required this.followers,
    required this.following,
    required this.mail,
    required this.bio,
    required this.coverImage,
    required this.userId,
    required this.name,
    required this.profilePic,
  });

  factory Users.fromMap(Map<String, dynamic> data, String documentId) {
    return Users(
      followers: List<String>.from(data['followers'] ?? []),
      following: List<String>.from(data['following'] ?? []),
      userId: documentId,
      mail: data['mail'] ?? '',
      name: data['name'] ?? '',
      profilePic: data['imageUrl'] ?? '',
      bio: data['bio'] ?? '',
      coverImage: data['coverImage'] ?? '',
    );
  }
}
class UserPost {
  final String postId;
  final String userId;
  final String image;
  final String description;
  final String location;
  final String dateAndTime;
  
  int likesCount;
  int commentsCount;

  UserPost({
    required this.dateAndTime,
    required this.location,
    required this.postId,
    required this.userId,
    required this.image,
    required this.description,
    this.likesCount = 0,
    this.commentsCount = 0,
  });

  factory UserPost.fromMap(Map<String, dynamic> data, String documentId) {
    return UserPost(
      dateAndTime: data['time'] ?? '',
      location: data['location'] ?? '',
      postId: documentId,
      userId: data['uid'] ?? '',
      image: data['photoUrl'] ?? '',
      description: data['description'] ?? '',
      likesCount: data['likesCount'] ?? 0,  // Ensure these fields exist in your Firestore documents
      commentsCount: data['commentsCount'] ?? 0,  // Ensure these fields exist in your Firestore documents
    );
  }
}
