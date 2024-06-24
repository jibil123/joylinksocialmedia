import 'package:chewie/chewie.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joylink/model/bloc/cubit/video_player_cubit.dart';
import 'package:joylink/utils/media_quary.dart';
import 'package:joylink/view/screens/home/reelScreen.dart/controller/functions.dart';

class VideoPlayerWidget extends StatelessWidget {
  final String videoId;
  final String userName;
  final String profileImage;
  final List<String> likes;
  final String description;
  final String uid;
  const VideoPlayerWidget({
    super.key,
    required this.uid,
    required this.videoId,
    required this.userName,
    required this.profileImage,
    required this.likes,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    final isLiked = likes.contains(currentUser?.uid);
   
    return Stack(
      fit: StackFit.expand,
      children: [
        BlocBuilder<VideoPlayerBloc, VideoPlayerState>(
          builder: (context, state) {
            if (state is VideoPlayerInitialized) {
              return SizedBox.expand(
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: state.chewieController.videoPlayerController.value
                            .size.width,
                    height: state.chewieController.videoPlayerController.value
                            .size.height,
                    child: Chewie(controller: state.chewieController),
                  ),
                ),
              );
            } else if (state is VideoPlayerLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is VideoPlayerError) {
              return Center(child: Text('Error: ${state.errorMessage}'));
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.transparent, Colors.black54],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        Positioned(
          bottom: 16,
          left: 16,
          right: 16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: mediaqueryWidth(0.08, context),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(profileImage),
                      radius: 24,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      userName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      isLiked ? Icons.favorite : Icons.favorite_border,
                      color: isLiked ? Colors.red : Colors.white,
                    ),
                    onPressed: () {
                        toggleLike(context, currentUser?.uid,likes,videoId);
                    },
                  ),
                  Text(
                    '${likes.length} likes',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  
}
