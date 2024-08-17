import 'package:equatable/equatable.dart';

abstract class EmailVerificationEvent extends Equatable {
  const EmailVerificationEvent();

  @override
  List<Object> get props => [];
}

class StartEmailVerification extends EmailVerificationEvent {}

class CheckEmailVerified extends EmailVerificationEvent {}

class ResendEmailVerification extends EmailVerificationEvent {}
