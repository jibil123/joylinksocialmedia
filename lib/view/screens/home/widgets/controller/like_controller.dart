import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

void toggleLike(BuildContext context, String? userId,List<String> likes,String postId) {
    if (userId == null) {
      return;
    }
    final postRef =
        FirebaseFirestore.instance.collection('user post').doc(postId);
    final isLiked = likes.contains(userId);

    if (isLiked) {
      postRef.update({
        'likes': FieldValue.arrayRemove([userId]),
      });
    } else {
      postRef.update({
        'likes': FieldValue.arrayUnion([userId]),
      });
    }
  }