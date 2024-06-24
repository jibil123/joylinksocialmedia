import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joylink/model/bloc/cubit/video_player_cubit.dart';
import 'package:chewie/chewie.dart';

class VideoPlayerScreen extends StatelessWidget {
  final String url;

  const VideoPlayerScreen({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => VideoPlayerBloc(url),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Video'),
          backgroundColor: Colors.blueAccent,
        ),
        body: BlocBuilder<VideoPlayerBloc, VideoPlayerState>(
          builder: (context, state) {
            if (state is VideoPlayerLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is VideoPlayerError) {
              return Center(child: Text(state.errorMessage));
            } else if (state is VideoPlayerInitialized) {
              return Center(
                child: AspectRatio(
                  aspectRatio: state.chewieController.aspectRatio!,
                  child: Chewie(controller: state.chewieController),
                ),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
