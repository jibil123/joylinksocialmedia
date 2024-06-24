import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:video_player/video_player.dart';
part 'video_preview_event.dart';
part 'video_preview_state.dart';

class VideoPreviewBloc extends Bloc<VideoPreviewEvent, VideoPreviewState> {
  VideoPreviewBloc() : super(VideoPreviewInitial()) {
    on<LoadVideoPreviewEvent>((event, emit) async {
      emit(VideoPreviewLoading());
       try {
       final controller = VideoPlayerController.file(File(event.videoFile.path));
        await controller.initialize();
        // await controller.setLooping(true);
        await controller.play();
        
        emit(VideoPreviewLoaded(controller));
      } catch (e) {
        emit(VideoPreviewError('Failed to load video preview: $e'));
      }
    });

  on<StopVideoPreviewEvent>((event, emit) async {
  if (state is VideoPreviewLoaded) {
    final controller = (state as VideoPreviewLoaded).controller;
    await controller.pause();
    await controller.dispose();
    emit(VideoPreviewStopped());
  }
  });
  }
}
