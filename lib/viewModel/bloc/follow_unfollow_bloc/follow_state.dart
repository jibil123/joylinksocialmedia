part of 'follow_bloc.dart';

@immutable
sealed class FollowState {}

final class FollowInitial extends FollowState {}

class FollowSuccess extends FollowState {
  final UserModel user;

  FollowSuccess(this.user);
}

class FollowFailure extends FollowState {
  final String error;

  FollowFailure(this.error);
}

class FollowUpdated extends FollowState {
  final List<String> updatedUserIds;
  FollowUpdated(this.updatedUserIds);
}