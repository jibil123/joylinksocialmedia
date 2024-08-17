import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:joylink/core/models/search_model.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> followUser(String currentUserId, String targetUserId) async {
    final currentUserRef = _firestore.collection('user details').doc(currentUserId);
    final targetUserRef = _firestore.collection('user details').doc(targetUserId);

    await _firestore.runTransaction((transaction) async {
      transaction.update(currentUserRef, {
        'following': FieldValue.arrayUnion([targetUserId])
      });
      transaction.update(targetUserRef, {
        'followers': FieldValue.arrayUnion([currentUserId])
      });
    });
  }

  Future<void> unfollowUser(String currentUserId, String targetUserId) async {
    final currentUserRef = _firestore.collection('user details').doc(currentUserId);
    final targetUserRef = _firestore.collection('user details').doc(targetUserId);

    await _firestore.runTransaction((transaction) async {
      transaction.update(currentUserRef, {
        'following': FieldValue.arrayRemove([targetUserId])
      });
      transaction.update(targetUserRef, {
        'followers': FieldValue.arrayRemove([currentUserId])
      });
    });
  }

    Future<UserModel> fetchUser(String userId) async {
    try {
      DocumentSnapshot userDoc = await _firestore.collection('user details').doc(userId).get();
      if (userDoc.exists) {
        return UserModel.fromFirestore(userDoc.data() as Map<String, dynamic>);
      } else {
        throw Exception("User not found");
      }
    } catch (e) {
      throw Exception("Failed to fetch user: $e");
    }
  }

  Future<List<String>> fetchFollowing(String userId) async {
    try {
      DocumentSnapshot userDoc = await _firestore.collection('user details').doc(userId).get();
      if (userDoc.exists) {
        Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
        return List<String>.from(data['following']);
      } else {
        throw Exception("User not found");
      }
    } catch (e) {
      throw Exception("Failed to fetch following list: $e");
    }
  }
}
