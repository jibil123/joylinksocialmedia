part of 'save_post_bloc.dart';

@immutable
sealed class SavePostState {}

final class SavePostInitial extends SavePostState {}

final class SavedPostsState extends SavePostState{}

final class SavedPostsLoadingState extends SavePostState{}

final class SaveSuccessState extends SavePostState{}

final class SaveFailedState extends SavePostState{}

final class PostAlreadySavedState extends SavePostState{}

final class LoadedSavedPosts extends SavePostState{
  final List<SavedPostModel>savedPosts;

  LoadedSavedPosts({required this.savedPosts});
}

final class LoadingSavedState extends SavePostState{}

final class UnSaveSuccessState extends SavePostState{}