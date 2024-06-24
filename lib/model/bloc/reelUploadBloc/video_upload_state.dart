part of 'video_upload_bloc.dart';

@immutable
sealed class VideoUploadState {}

final class VideoUploadInitial extends VideoUploadState {}

class VideoPicking extends VideoUploadState {}

class VideoPicked extends VideoUploadState {
  final XFile video;

  VideoPicked(this.video);
}

class VideoUploading extends VideoUploadState {}

class VideoUploaded extends VideoUploadState {}

class VideoUploadError extends VideoUploadState {
  final String error;

  VideoUploadError(this.error);
}


class VideoUploadProgress extends VideoUploadState {
  final double progress;

  VideoUploadProgress(this.progress);

}