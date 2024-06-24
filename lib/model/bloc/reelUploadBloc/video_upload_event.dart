part of 'video_upload_bloc.dart';

@immutable
sealed class VideoUploadEvent {}

class PickVideoEvent extends VideoUploadEvent {}

class UploadVideoEvent extends VideoUploadEvent {
  final XFile video;
  final String description;

  UploadVideoEvent(this.video, this.description);
}