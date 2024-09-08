import 'package:bloc/bloc.dart';
import 'package:joylink/data/repositories/poll_respository/poll_repository.dart';
import 'package:joylink/viewmodel/bloc/poll_bloc/poll_event.dart';
import 'package:joylink/viewmodel/bloc/poll_bloc/poll_state.dart';

class PollBloc extends Bloc<PollEvent, PollState> {
  final PollRepository pollRepository;

  PollBloc(this.pollRepository) : super(PollInitialState()) {

    on<DeletePollEvent>((event, emit)async {
      try{
        await pollRepository.deletePoll(event.pollId);
        emit(SuccessDelete());
      }catch(e){
        // print(e.toString());
      }
    },);
    on<AddPollEvent>((event, emit) async {
      emit(PollLoadingState());
      try {
        await pollRepository.addPoll(event.poll);
        emit(PollInitialState()); // Reset state after adding poll
        emit(PollAddedSuccess());
      } catch (e) {
        emit(PollErrorState(e.toString()));
      }
    });

    on<VoteOnPollEvent>((event, emit) async {
      emit(PollLoadingState());
      try {
        await pollRepository.voteOnPoll(event.pollId, event.userId, event.selectedOption);
        emit(PollVotedSuccess());
      } catch (e) {
        emit(PollErrorState(e.toString()));
      }
    });



  }
}