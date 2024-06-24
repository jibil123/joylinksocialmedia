import 'package:cloud_firestore/cloud_firestore.dart';

class UserDetails {
  final String userId;
  final String bio;
  final String coverImage;
  final String name;
  final String profilePic;
  final String mail;
  final List<String> followers;
  final List<String> following;
  UserDetails({
    required this.followers,
    required this.following,
    required this.mail,
    required this.bio,
    required this.coverImage,
    required this.userId,
    required this.name,
    required this.profilePic,
  });

  factory UserDetails.fromDocumentSnapshot(DocumentSnapshot data,String uid)  {
    return UserDetails(
      followers: List<String>.from(data['followers'] ?? []),
      following: List<String>.from(data['following'] ?? []),
      userId: uid,
      mail: data['mail'] ?? '',
      name: data['name'] ?? '',
      profilePic: data['imageUrl'] ?? '',
      bio: data['bio'] ?? '',
      coverImage: data['coverImage'] ?? '',
    );
  }
}