import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:joylink/model/repo/googleRepo/google_auth_repo.dart';
import 'package:meta/meta.dart';

part 'google_auth_event.dart';
part 'google_auth_state.dart';

class GoogleAuthBloc extends Bloc<GoogleAuthEvent, GoogleAuthState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleAuthBloc() : super(GoogleAuthInitial()) {
    on<SigninEvent>(_signinWithGoogle);
    on<CheckGoogleStatusEvent>((event, emit) async {
      User? user;
      try {
        await Future.delayed(const Duration(seconds: 2), () {
          user = _auth.currentUser;
        });

        if (user != null) {
          emit(GoogleAuthSuccess());
        } else {
          emit(GoogleAuthError());
        }
      } catch (e) {
        return;
      }
    });
  }

  final AuthRepository authRepository = AuthRepository();

  Future<void> _signinWithGoogle(
      SigninEvent event, Emitter<GoogleAuthState> emit) async {
    emit(GoogleAuthLoading());
    // await FirebaseAuth.instance.signOut();
    final user = await authRepository.signinWithGoogle();
    if (user != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection('user details')
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        emit(GoogleAuthSuccess());
      } else {
        final name = user.email?.split('@').first;
        // print(name);
        FirebaseFirestore.instance
            .collection('user details')
            .doc(user.uid)
            .set({
          'uid': user.uid,
          'mail': user.email,
          'name': name,
          'followers': [],
          'following': [],
          'imageUrl': '',
          'coverImage': '',
          'bio': ''
        });
        emit(GoogleAuthSuccess());
      }

      // print('success');
    } else {
      emit(GoogleAuthError());
    }
  }
}
