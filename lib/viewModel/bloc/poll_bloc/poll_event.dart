
import 'package:joylink/core/models/poll_model.dart';

abstract class PollEvent {}

class AddPollEvent extends PollEvent {
  final Poll poll;
  AddPollEvent(this.poll);
}

class FetchAllPollsEvent extends PollEvent {}

class FetchUserPollsEvent extends PollEvent {
  final String userId;
  FetchUserPollsEvent(this.userId);
}
class VoteOnPollEvent extends PollEvent {
  final String pollId;
  final String userId;
  final int selectedOption;

  VoteOnPollEvent(this.pollId, this.userId, this.selectedOption);
}

class DeletePollEvent extends PollEvent{
  final String pollId;
  DeletePollEvent(this.pollId);
}
