import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:joylink/model/bloc/cubit/video_player_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joylink/view/screens/home/reelScreen.dart/video_player_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserReelScreen extends StatelessWidget {
  const UserReelScreen({super.key, required this.currentUserId});
  final String currentUserId;
  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return const Scaffold(
        body: Center(child: Text('No user logged in')),
      );
    }

    // final currentUserId = currentUser.uid;
    // Log the current user ID

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Reel Page'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('videos')
            .where('uid', isEqualTo: currentUserId)
            .orderBy('uploadedAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            if (kDebugMode) {
              print('Error: ${snapshot.error}');
            }
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No videos found'));
          }

          final videos = snapshot.data!.docs;
          if (kDebugMode) {
            print('Number of videos: ${videos.length}');
          } // Log the number of videos

          return PageView.builder(
            scrollDirection: Axis.vertical,
            itemCount: videos.length,
            itemBuilder: (context, index) {
              final videoData = videos[index].data() as Map<String, dynamic>;
              final videoUrl = videoData['url'];
              final userName = videoData['name'];
              final profileImage = videoData['profile'];
              final likes = List<String>.from(videoData['likes'] ?? []);
              final description = videoData['description'];
              final videoId = videos[index].id;
              final uid = videoData['uid'];


              return BlocProvider(
                create: (_) => VideoPlayerBloc(videoUrl),
                child: VideoPlayerWidget(
                  videoId: videoId,
                  userName: userName,
                  profileImage: profileImage,
                  likes: likes,
                  description: description,
                  uid: uid,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
