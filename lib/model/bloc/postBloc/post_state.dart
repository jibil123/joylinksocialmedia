part of 'post_bloc.dart';

@immutable
sealed class PostState {}

final class PostInitial extends PostState {}

class PostPhotoAdded extends PostState {
  final PostModel postModel;

  PostPhotoAdded({required this.postModel});
}

class PostDescriptionUpdatedState extends PostState {
  final String description;

  PostDescriptionUpdatedState({required this.description});
}

class PostSavedState extends PostState {}

class PostCanceledState extends PostState {}

class PostLoadingState extends PostState {}

class CurrentLocationNameState extends PostState{
  final PostModel? postModel;

  CurrentLocationNameState({ this.postModel});
  
}

class AddPhotoBeforeUpload extends PostState{
}
