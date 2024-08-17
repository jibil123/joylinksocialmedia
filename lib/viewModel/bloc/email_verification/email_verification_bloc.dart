import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'email_verification_event.dart';
import 'email_verification_state.dart';

class EmailVerificationBloc
    extends Bloc<EmailVerificationEvent, EmailVerificationState> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  Timer? _timer;

  EmailVerificationBloc() : super(EmailVerificationInitial()) {
    on<StartEmailVerification>(_onStartEmailVerification);
    on<CheckEmailVerified>(_onCheckEmailVerified);
    on<ResendEmailVerification>(_onResendEmailVerification);
  }

  void _onStartEmailVerification(
      StartEmailVerification event, Emitter<EmailVerificationState> emit) async {
    emit(EmailVerificationInProgress());

    try {
      await _firebaseAuth.currentUser?.sendEmailVerification();

      _timer = Timer.periodic(
          const Duration(seconds: 3), (timer) => add(CheckEmailVerified()));
    } catch (e) {
      emit(EmailVerificationFailure(e.toString()));
    }
  }

  void _onCheckEmailVerified(
      CheckEmailVerified event, Emitter<EmailVerificationState> emit) async {
    await _firebaseAuth.currentUser?.reload();

    if (_firebaseAuth.currentUser!.emailVerified) {
      _timer?.cancel();
      emit(EmailVerificationSuccess());
    } else {
      emit(EmailVerificationInProgress());
    }
  }

  void _onResendEmailVerification(
      ResendEmailVerification event, Emitter<EmailVerificationState> emit) async {
    try {
      await _firebaseAuth.currentUser?.sendEmailVerification();
    } catch (e) {
      emit(EmailVerificationFailure(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
