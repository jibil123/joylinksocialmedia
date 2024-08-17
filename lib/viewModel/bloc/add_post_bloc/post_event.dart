part of 'post_bloc.dart';

@immutable
sealed class PostEvent {}

class AddPhoto extends PostEvent {
  final Uint8List photo;

  AddPhoto({required this.photo});
}

class SavePostEvent extends PostEvent {
}

class CancelPostEvent extends PostEvent {}

class AddLocationEvent extends PostEvent{}

