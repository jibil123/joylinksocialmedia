part of 'profile_photo_bloc.dart';

@immutable
sealed class ProfilePhotoState {}

final class ProfilePhotoInitial extends ProfilePhotoState {
  
}
class LoadingprofileState extends ProfilePhotoState{}

class ProfilePictureSelectedState extends ProfilePhotoState {
  final String? imageFile;

  ProfilePictureSelectedState({required this.imageFile});
}

class LoadingCoverState extends ProfilePhotoState{}

class CoverPictureSelectedState extends ProfilePhotoState {
  final String? imageFile;

  CoverPictureSelectedState({required this.imageFile});
}
