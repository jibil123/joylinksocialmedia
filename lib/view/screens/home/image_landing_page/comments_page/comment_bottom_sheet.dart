import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class CommentBottomSheet extends StatelessWidget {
  final String postId;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final TextEditingController _commentController = TextEditingController();

  CommentBottomSheet({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        height: MediaQuery.of(context).size.height *
            0.5, // Adjust the height as needed
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firebaseFirestore
                    .collection('user post')
                    .doc(postId)
                    .collection('comments')
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('No comments yet'));
                  }
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var commentData = snapshot.data!.docs[index].data()
                          as Map<String, dynamic>;

                      // Handle null timestamp
                      Timestamp? timestamp = commentData['timestamp'];
                      DateTime? dateTime;
                      String formattedDate = '';
                      if (timestamp != null) {
                        dateTime = timestamp.toDate();
                        formattedDate = DateFormat('dd MMM yyyy').format(dateTime);
                      }

                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage:
                              NetworkImage(commentData['userProfileImage']),
                        ),
                        title: Text(commentData['userName']),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(commentData['text']),
                            if (formattedDate.isNotEmpty)
                              Text(
                                formattedDate,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            const Divider(height: 1),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      decoration: InputDecoration(
                        hintText: 'Add a comment...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () async {
                      if (_commentController.text.trim().isEmpty) {
                        return;
                      } else if (_commentController.text.trim().length > 20) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'Comment length should not exceed 20 characters.'),
                          ),
                        );
                        return;
                      }

                      User? currentUser = FirebaseAuth.instance.currentUser;
                      if (currentUser != null) {
                        DocumentSnapshot userDetailsSnapshot =
                            await _firebaseFirestore
                                .collection('user details')
                                .doc(currentUser.uid)
                                .get();
                        if (userDetailsSnapshot.exists) {
                          String userName = userDetailsSnapshot['name'];
                          String userProfileImage =
                              userDetailsSnapshot['imageUrl'];

                          _firebaseFirestore
                              .collection('user post')
                              .doc(postId)
                              .collection('comments')
                              .add({
                            'text': _commentController.text.trim(),
                            'user': currentUser.uid,
                            'userName': userName,
                            'userProfileImage': userProfileImage,
                            'timestamp': FieldValue.serverTimestamp(),
                          });
                          _commentController.clear();
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
