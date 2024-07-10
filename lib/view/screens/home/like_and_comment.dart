import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:joylink/view/screens/home/widgets/comment_dialog.dart';

class LikeAndCommentButtons extends StatelessWidget {
  final String postId;

  const LikeAndCommentButtons({
    super.key, 
    required this.postId,
  });

  Stream<DocumentSnapshot> postStream(String postId) {
    return FirebaseFirestore.instance.collection('user post').doc(postId).snapshots();
  }

  Stream<QuerySnapshot> commentsStream(String postId) {
    return FirebaseFirestore.instance.collection('user post').doc(postId).collection('comments').snapshots();
  }

  Future<void> toggleLike(String postId) async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    DocumentReference postRef = FirebaseFirestore.instance.collection('user post').doc(postId);
    DocumentSnapshot postSnapshot = await postRef.get();

    if (postSnapshot.exists) {
      List likes = postSnapshot['likes'] ?? [];
      if (likes.contains(currentUser.uid)) {
        postRef.update({
          'likes': FieldValue.arrayRemove([currentUser.uid])
        });
      } else {
        postRef.update({
          'likes': FieldValue.arrayUnion([currentUser.uid])
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: postStream(postId),
      builder: (context, postSnapshot) {
        if (!postSnapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!postSnapshot.data!.exists) {
          return const Center(child: Text('Post does not exist.'));
        }

        var post = postSnapshot.data!;
        List likes = post['likes'] ?? [];
        int likeCount = likes.length;
        bool isLiked = likes.contains(FirebaseAuth.instance.currentUser?.uid);

        return StreamBuilder<QuerySnapshot>(
          stream: commentsStream(postId),
          builder: (context, commentSnapshot) {
            if (!commentSnapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            int commentCount = commentSnapshot.data!.docs.length;

            return SizedBox(
              height: 35,
              child: Row(
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          isLiked ? Icons.favorite : Icons.favorite_border,
                          color: isLiked ? Colors.red : Colors.black,
                        ),
                        onPressed: () => toggleLike(postId),
                      ),
                      Text('$likeCount'),
                    ],
                  ),
                  const SizedBox(width: 10,),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.comment,),
                        onPressed: () {
                          showCommentBottomSheet(
                            context,
                            postId,
                          );
                        },
                      ),
                      Text('$commentCount'),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
