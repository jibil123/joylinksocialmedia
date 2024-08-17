part of 'follow_bloc.dart';

@immutable
sealed class FollowEvent {}

class FollowUserEvent extends FollowEvent {
  final String currentUserId;
  final String targetUserId;

  FollowUserEvent({ required this.currentUserId,required this.targetUserId});
}

class UnfollowUserEvent extends FollowEvent {
  final String currentUserId;
  final String targetUserId;

  UnfollowUserEvent(this.currentUserId, this.targetUserId);
}
