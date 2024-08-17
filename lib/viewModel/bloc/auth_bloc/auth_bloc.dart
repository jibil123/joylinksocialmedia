import 'package:bloc/bloc.dart';
import 'package:joylink/core/models/userdetails.dart';
import 'package:joylink/core/services/auth_service/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService _authService = AuthService();

  AuthBloc() : super(AuthInitial()) {
    on<CheckLoginStatusEvent>((event, emit) async {
      try {
        final user = await _authService.getCurrentUser();
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
        final user = await _authService.signUpUser(
          email: event.user.email.toString(),
          password: event.user.password.toString(),
          name: event.user.name,
        );
        if (user != null) {
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
        await _authService.logoutUser();
        emit(UnAuthenticated());
      } catch (e) {
        emit(AuthenticatedErrors(message: e.toString()));
      }
    });

    on<LoginEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await _authService.loginUser(
          email: event.email,
          password: event.password,
        );
        if (user != null) {
          emit(Authenticated(user));
        } else {
          emit(UnAuthenticated());
        }
      } catch (e) {
        emit(AuthenticatedErrors(message: e.toString()));
      }
    });

    on<EmailVarification>((event, emit) async {
      try {
        await _authService.sendEmailVerification();
      } catch (e) {
        emit(AuthenticatedErrors(message: e.toString()));
      }
    });
  }
}
