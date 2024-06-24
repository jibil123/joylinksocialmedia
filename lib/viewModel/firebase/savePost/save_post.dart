import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:joylink/model/model/saved_post_model.dart';

class FirebaseSavePost {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<List<SavedPostModel>> getSavedPosts(String userId) async {
    final querySnapshot = await _firebaseFirestore
        .collection('saved users')
        .doc(userId)
        .collection('saved post')
        .get();
    return querySnapshot.docs
        .map((doc) => SavedPostModel.fromMap(doc.data(), doc.id))
        .toList();
  }

  Future<bool> isPostSaved(String id, String userId) async {
    final doc = await _firebaseFirestore
        .collection('saved users')
        .doc(userId)
        .collection('saved post')
        .where('id', isEqualTo: id)
        .get();
    return doc.docs.isNotEmpty;
  }

  Future<void> savePost(Map<String, dynamic> savePost, String userId) async {
    try {
      await _firebaseFirestore
          .collection('saved users')
          .doc(userId)
          .collection('saved post')
          .add(savePost);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> unSavePost(String postId, String userId) async {
    try {
       await _firebaseFirestore
          .collection('saved users')
          .doc(userId)
          .collection('saved post')
          .doc(postId).delete();
    } catch (e) {
      throw(e.toString());
    }
  }
}
