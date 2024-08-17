import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:joylink/core/models/userdetails.dart';
import 'package:meta/meta.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  AuthBloc() : super(AuthInitial()) {
    on<CheckLoginStatusEvent>((event, emit) async {
      User? user;
      try {
        await Future.delayed(const Duration(seconds: 2), () {
          user = _auth.currentUser;
        });

        if (user != null) {
          emit(Authenticated(user));
        } else {
          emit(UnAuthenticated());
        }
      } catch (e) {
        emit(AuthenticatedErrors(message: e.toString()));
      }
    });

    on<SignupEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final userCredential = await _auth.createUserWithEmailAndPassword(
            email: event.user.email.toString(),
            password: event.user.password.toString());
        final user = userCredential.user;
        if (user != null) {
          await user.sendEmailVerification();
          FirebaseFirestore.instance
              .collection('user details')
              .doc(user.uid)
              .set({
            'uid': user.uid,
            'mail': user.email,
            'name': event.user.name,
            'followers': [],
            'following': [],
            'imageUrl': '',
            'coverImage': '',
            'bio': ''
          });
          emit(Authenticated(user));
        } else {
          emit(UnAuthenticated());
        }
      } catch (e) {
        emit(AuthenticatedErrors(message: e.toString()));
      }
    });

    on<LogoutEvent>((event, emit) async {
      try {
        await _auth.signOut();
        emit(UnAuthenticated());
      } catch (e) {
        emit(AuthenticatedErrors(message: e.toString()));
      }
    });

    on<LoginEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final userCredential = await _auth.signInWithEmailAndPassword(
            email: event.email, password: event.password);
        final user = userCredential.user;
        if (user != null) {
          emit(Authenticated(user));
        } else {
          emit(UnAuthenticated());
        }
      } catch (e) {
        emit(AuthenticatedErrors(message: e.toString()));
      }
    });
    on<EmailVarification>((event, emit) async{
       FirebaseAuth.instance.currentUser?.sendEmailVerification();
         
    });
  }
}
