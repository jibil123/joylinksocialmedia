import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:joylink/model/model/saved_post_model.dart';
import 'package:joylink/viewModel/firebase/savePost/save_post.dart';
import 'package:meta/meta.dart';

part 'save_post_event.dart';
part 'save_post_state.dart';

class SavePostBloc extends Bloc<SavePostEvent, SavePostState> {
  SavePostBloc() : super(SavePostInitial()) {
    FirebaseSavePost firebaseSavePost = FirebaseSavePost();
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    on<SavedPostsEvent>((event, emit) async {
      final String currentUserId = firebaseAuth.currentUser!.uid;
      emit(SavedPostsLoadingState());
      try {
        bool isSaved =
            await firebaseSavePost.isPostSaved(event.postId, currentUserId);
        if (isSaved) {
          emit(PostAlreadySavedState());
        } else {
          await firebaseSavePost.savePost({
            'id': event.postId,
            'name': event.name,
            'profileImage': event.profileImage,
            'location': event.location,
            'postImage': event.postImage,
            'date': event.date,
            'description': event.description
          }, currentUserId);
          emit(SaveSuccessState());
        }
      } catch (e) {
        emit(SaveFailedState());
        throw(e.toString());
      }
    });
    on<UnSavePostEvent>((event, emit) async {
      final String currentUserId = firebaseAuth.currentUser!.uid;
      try {
        await firebaseSavePost.unSavePost(event.id, currentUserId);
        emit(UnSaveSuccessState());
      } catch (e) {
        throw(e.toString());
      }
    });

    on<FetchPostSavedEvent>((event, emit) async {
      emit(LoadingSavedState());
      try {
        final String currentUserId = event.currentUserId;
        final datas = await firebaseSavePost.getSavedPosts(currentUserId);
        emit(LoadedSavedPosts(savedPosts: datas));
      } catch (e) {
        throw(e.toString());
      }
    });
  }
}
