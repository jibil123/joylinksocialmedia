part of 'post_bloc.dart';

@immutable
sealed class PostFetchEvent {}

class FetchPostsEvent extends PostFetchEvent {}

class DeletePostEvent extends PostFetchEvent {
  final String postId;

  DeletePostEvent({required this.postId});
}