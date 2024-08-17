import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joylink/viewmodel/bloc/follow_unfollow_bloc/follow_bloc.dart';
import 'package:joylink/core/models/search_model.dart';
import 'package:joylink/view/screens/other_profile_screen/other_profile_screen.dart';
import 'package:joylink/viewmodel/firebase/follow_unfollow/follow_unfollow.dart';

class FollowingListScreen extends StatelessWidget {
  final List<dynamic> initialUserIds;

  FollowingListScreen({super.key, required this.initialUserIds});

  final firestore = FirebaseFirestore.instance;
  final firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Following'),
      ),
      body: BlocProvider(
        create: (context) => FollowBloc(UserService()),
        child: BlocBuilder<FollowBloc, FollowState>(
          builder: (context, state) {
            List<dynamic> userIds = initialUserIds;
            if (state is FollowUpdated) {
              userIds = state.updatedUserIds;
            }

            if (userIds.isEmpty) {
              return const Center(
                child: Text(
                  'No users to display.',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              );
            }

            return StreamBuilder<QuerySnapshot>(
              stream: firestore
                  .collection('user details')
                  .where(FieldPath.documentId, whereIn: userIds)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Something went wrong: ${snapshot.error}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text(
                      'No users found.',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  );
                }

                final userDocs = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: userDocs.length,
                  itemBuilder: (context, index) {
                    final data = userDocs[index].data() as Map<String, dynamic>?;
                    final otherUserId = data?['uid'] ?? '';

                    return ListTile(
                      onTap: () {
                        if (data != null) {
                          UserModel userModel = UserModel(
                            followers: data['followers'] ?? [],
                            following: data['following'] ?? [],
                            coverImage: data['coverImage'] ?? '',
                            id: data['uid'] ?? '',
                            name: data['name'] ?? 'Unknown',
                            mail: data['mail'] ?? 'Unknown',
                            imageUrl: data['imageUrl'] ?? '',
                            bio: data['bio'] ?? '',
                          );
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => OtherProfileScreen(
                                userModel: userModel,
                              ),
                            ),
                          );
                        }
                      },
                      leading: CircleAvatar(
                        backgroundImage: (data?['imageUrl'] != null && data!['imageUrl'].isNotEmpty)
                            ? NetworkImage(data['imageUrl'])
                            : const AssetImage('assets/images/joylink-logo.png') as ImageProvider,
                      ),
                      title: Text(data?['name'] ?? 'Unknown'),
                      subtitle: Text(data?['mail'] ?? 'Unknown'),
                      trailing: 
                           TextButton(
                              onPressed: () {
                                context.read<FollowBloc>().add(UnfollowUserEvent(
                                      firebaseAuth.currentUser!.uid,
                                      otherUserId,
                                    ));
                              },
                              child:
                               const Text(
                                'UnFollow',
                                style: TextStyle(color: Colors.blue),
                              ),
                            )
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
