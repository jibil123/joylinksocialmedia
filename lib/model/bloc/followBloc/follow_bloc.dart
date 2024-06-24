import 'package:bloc/bloc.dart';
import 'package:joylink/model/model/search_model.dart';
import 'package:joylink/viewModel/firebase/follow_unfollow/follow_unfollow.dart';
import 'package:meta/meta.dart';

part 'follow_event.dart';
part 'follow_state.dart';

class FollowBloc extends Bloc<FollowEvent, FollowState> {
  final UserService userService;
  FollowBloc(this.userService) : super(FollowInitial()) {
    on<FollowUserEvent>((event, emit) async {
      try {
        await userService.followUser(event.currentUserId, event.targetUserId);       
        UserModel updatedUser = await userService.fetchUser(event.currentUserId);
        emit(FollowSuccess(updatedUser));
      } catch (e) {
        emit(FollowFailure(e.toString()));
      }
    });
    on<UnfollowUserEvent>((event, emit) async {
      try {
        await userService.unfollowUser(event.currentUserId, event.targetUserId);
         List<String> updatedUserIds = await userService.fetchFollowing(event.currentUserId);
         emit(FollowUpdated(updatedUserIds));
      } catch (e) {
        emit(FollowFailure(e.toString()));
      }
    });
  }
}
