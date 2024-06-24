part of 'profile_photo_bloc.dart';

@immutable
sealed class ProfilePhotoEvent {}

class SelectCoverPhotoEvent extends ProfilePhotoEvent{}

class SelectPhotoFromCamAndGal extends ProfilePhotoEvent{}
  