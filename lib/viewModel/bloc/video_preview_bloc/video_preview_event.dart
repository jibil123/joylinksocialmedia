part of 'video_preview_bloc.dart';

@immutable
sealed class VideoPreviewEvent {}


class LoadVideoPreviewEvent extends VideoPreviewEvent {
  final XFile videoFile;

  LoadVideoPreviewEvent(this.videoFile);
}

class StopVideoPreviewEvent extends VideoPreviewEvent {}