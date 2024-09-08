import 'package:joylink/core/models/poll_model.dart';

abstract class PollState {}

class PollInitialState extends PollState {}
class PollAddedSuccess extends PollState{}

class PollLoadingState extends PollState {}

class PollLoadedState extends PollState {
  final List<Poll> polls;
  PollLoadedState(this.polls);
}
class PollErrorState extends PollState {
  final String message;
  PollErrorState(this.message);
}

class PollVotedSuccess extends PollState{}

class PollDeletedState extends PollState{}

class SuccessDelete extends PollState{}