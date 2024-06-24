import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joylink/model/bloc/videoPreviewBloc/video_preview_bloc.dart';
import 'package:video_player/video_player.dart';

class VideoPreview extends StatelessWidget {
  const VideoPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VideoPreviewBloc, VideoPreviewState>(
      builder: (context, state) {
        if (state is VideoPreviewLoading) {
          return const CircularProgressIndicator();
        } else if (state is VideoPreviewLoaded) {
          return SizedBox(
            width: 300,
            height: 533.33, // 9:16 aspect ratio
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: state.controller.value.size.width,
                height: state.controller.value.size.height,
                child: VideoPlayer(state.controller),
              ),
            ),
          );
        } else if (state is VideoPreviewError) {
          return Text('Error: ${state.error}');
        }
         else {
          return Container(
            width: 300,
            height: 300,
            color: Colors.grey[300],
            child: const Center(child: Icon(Icons.videocam, size: 100)),
          );
        }
      },
    );
  }
}
