import 'package:bloc/bloc.dart';
import 'package:joylink/model/model/fetch_model.dart';
import 'package:joylink/viewModel/firebase/fetchData/fetch_post_data.dart';
import 'package:meta/meta.dart';

part 'post_event.dart';
part 'post_state.dart';

class PostFetchBloc extends Bloc<PostFetchEvent, PostFetchState> {
  final Repository repository;
  PostFetchBloc({required this.repository}) : super(PostInitial()) {
    on<FetchPostsEvent>((event, emit) async {
      emit(PostLoading());
      try {
       final users = await repository.getUsers();
        final posts = await repository.getUserPosts();
        emit(PostLoaded(users, posts));
      } catch (e) {
        emit(PostError(e.toString()));
      }
    });

    on<DeletePostEvent>((event, emit) async {
      try {
        await repository.deleteUserPost(event.postId);
        // After successful deletion, you can refetch the posts or update the local state
        add(FetchPostsEvent());
      } catch (e) {
        emit(PostError(e.toString()));
      }
    });
  }
}
