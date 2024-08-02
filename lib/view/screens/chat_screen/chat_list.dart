import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Add this line for date formatting
import 'package:joylink/view/screens/chat_screen/message_screen.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser!.uid;
    return Scaffold(
      backgroundColor: Colors.teal[50],
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: ClipRRect(
          borderRadius:
              const BorderRadius.vertical(bottom: Radius.circular(30)),
          child: AppBar(
            backgroundColor: Colors.teal[300],
            title: const Text(
              'Chat List',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser)
            .collection('chats')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No chats yet'));
          }

          return FutureBuilder(
            future: FirebaseFirestore.instance.collection('user details').get(),
            builder: (context, userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (userSnapshot.hasError) {
                return const Center(child: Text('Error loading users'));
              }
              if (!userSnapshot.hasData) {
                return const Center(child: Text('No user data found'));
              }

              final userDocs = userSnapshot.data!.docs;
              final userMap = {for (var doc in userDocs) doc.id: doc.data()};

              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final chatRoom = snapshot.data!.docs[index];
                  final chatRoomId = chatRoom.id;
                  final receiverId = chatRoomId
                      .split('_')
                      .firstWhere((id) => id != currentUser);
                  final userData = userMap[receiverId] ?? {};
                  final userName = userData['name'] ?? 'No Name';
                  final userProfile = userData['imageUrl'] ?? '';
                  final lastMessage = chatRoom['lastMessage'] ?? '';
                  final timestamp = chatRoom['timestamp'] as Timestamp;

                  // Formatting the timestamp
                  String formattedDate;
                  final DateTime messageDate = timestamp.toDate();
                  final DateTime currentDate = DateTime.now();

                  if (messageDate.year == currentDate.year &&
                      messageDate.month == currentDate.month &&
                      messageDate.day == currentDate.day) {
                    formattedDate =
                        DateFormat.jm().format(messageDate); // Show time
                  } else {
                    formattedDate =
                        DateFormat.yMMMd().format(messageDate); // Show date
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        leading: userProfile.isNotEmpty
                            ? CircleAvatar(
                                backgroundImage: NetworkImage(userProfile),
                              )
                            : const CircleAvatar(
                                child: Icon(Icons.person),
                              ),
                        title: Text(userName),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(lastMessage),
                            Text(formattedDate,
                                style: const TextStyle(color: Colors.grey)),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ChatScreen(receiverId: receiverId,chatUserName:userName ,profileImage:userProfile ),
                            ),
                          );
                        },
                      ),
                      const Divider(
                        color: Colors.grey,
                        thickness: 0.5,
                        indent: 16,
                        endIndent: 16,
                      ),
                    ],
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
