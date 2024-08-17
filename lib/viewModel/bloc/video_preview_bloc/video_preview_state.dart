part of 'video_preview_bloc.dart';

@immutable
sealed class VideoPreviewState {}

final class VideoPreviewInitial extends VideoPreviewState {}

class VideoPreviewLoading extends VideoPreviewState {}

class VideoPreviewLoaded extends VideoPreviewState {
  final VideoPlayerController controller;

  VideoPreviewLoaded(this.controller);
}
class VideoPreviewError extends VideoPreviewState {
  final String error;

  VideoPreviewError(this.error);
}

class VideoPreviewStopped extends VideoPreviewState {}