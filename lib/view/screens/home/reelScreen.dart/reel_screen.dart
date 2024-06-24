import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:joylink/model/bloc/cubit/video_player_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joylink/view/screens/home/reelScreen.dart/video_player_widget.dart';

class ReelScreen extends StatelessWidget {
  const ReelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('videos')
            .orderBy('uploadedAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final videos = snapshot.data!.docs;
          
          if (videos.isEmpty) {
            return const Center(
              child: Text(
                'No Videos Available',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            );
          }

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
