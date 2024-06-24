 import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

void toggleLike(BuildContext context, String? userId,List<String> likes,String videoId) {
    if (userId == null) {
      return;
    }
    final videoRef =
        FirebaseFirestore.instance.collection('videos').doc(videoId);
    final isLiked = likes.contains(userId);

    if (isLiked) {
      videoRef.update({
        'likes': FieldValue.arrayRemove([userId]),
      });
    } else {
      videoRef.update({
        'likes': FieldValue.arrayUnion([userId]),
      });
    }
  }