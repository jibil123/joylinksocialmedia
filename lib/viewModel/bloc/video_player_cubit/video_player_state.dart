part of 'video_player_cubit.dart';

@immutable
sealed class VideoPlayerState {}
class VideoPlayerLoading extends VideoPlayerState {}

class VideoPlayerInitialized extends VideoPlayerState {
  final ChewieController chewieController;

  VideoPlayerInitialized(this.chewieController);
}

class VideoPlayerError extends VideoPlayerState {
  final String errorMessage;

  VideoPlayerError(this.errorMessage);
}