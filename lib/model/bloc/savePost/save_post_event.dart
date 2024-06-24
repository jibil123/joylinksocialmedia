part of 'save_post_bloc.dart';

@immutable
sealed class SavePostEvent {}

class SavedPostsEvent extends SavePostEvent {
  final String postId;
  final String name;
  final String profileImage;
  final String location;
  final String postImage;
  final String date;
  final String description;

  SavedPostsEvent(
      {
      required this.postId,
      required this.name,
      required this.profileImage,
      required this.location,
      required this.postImage,
      required this.date,
      required this.description});
}

class UnSavePostEvent extends SavePostEvent {
  final String id;

  UnSavePostEvent({required this.id});
}

class FetchPostSavedEvent extends SavePostEvent {
  final String currentUserId;

  FetchPostSavedEvent({required this.currentUserId});
}
