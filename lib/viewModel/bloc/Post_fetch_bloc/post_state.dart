part of 'post_bloc.dart';

@immutable
sealed class PostFetchState {}

final class PostInitial extends PostFetchState {}

class PostLoading extends PostFetchState {}

class PostLoaded extends PostFetchState {
  final List<Users> users;
  final List<UserPost> sortedPosts;

  PostLoaded(this.users, List<UserPost> posts)
  : sortedPosts = posts
          ..sort((a, b) => b.dateAndTime.compareTo(a.dateAndTime));
}

class PostError extends PostFetchState {
  final String error;

  PostError(this.error);
}
