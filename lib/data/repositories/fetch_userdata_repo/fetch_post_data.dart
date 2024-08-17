import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:joylink/core/models/fetch_model.dart';

class Repository {
  final _firestore = FirebaseFirestore.instance;

  Future<List<Users>> getUsers() async {
    final querySnapshot = await _firestore.collection('user details').get();
    return querySnapshot.docs
        .map((doc) => Users.fromMap(doc.data(), doc.id))
        .toList();
  }

  Future<List<UserPost>> getUserPosts() async {
    final querySnapshot = await _firestore.collection('user post').get();
    final posts = querySnapshot.docs
        .map((doc) => UserPost.fromMap(doc.data(), doc.id))
        .toList();
    
    final postIds = posts.map((post) => post.postId).toList();
    
    final likesCount = await getLikesCount(postIds);
    final commentsCount = await getCommentsCount(postIds);

    for (var post in posts) {
      post.likesCount = likesCount[post.postId] ?? 0;
      post.commentsCount = commentsCount[post.postId] ?? 0;
    }

    return posts;
  }

  Future<void> deleteUserPost(String postId) async {
    await _firestore.collection('user post').doc(postId).delete();
    await _firestore
          .collection('saved users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .collection('saved post')
          .doc(postId).delete();
  }

  Future<Map<String, int>> getLikesCount(List<String> postIds) async {
    Map<String, int> likesCount = {};
    for (String postId in postIds) {
      var snapshot = await _firestore.collection('user post').doc(postId).collection('likes').get();
      likesCount[postId] = snapshot.size;
    }
    return likesCount;
  }

  Future<Map<String, int>> getCommentsCount(List<String> postIds) async {
    Map<String, int> commentsCount = {};
    for (String postId in postIds) {
      var snapshot = await _firestore.collection('user post').doc(postId).collection('comments').get();
      commentsCount[postId] = snapshot.size;
    }
    return commentsCount;
  }
}
