import 'package:equatable/equatable.dart';

abstract class EmailVerificationState extends Equatable {
  const EmailVerificationState();

  @override
  List<Object> get props => [];
}

class EmailVerificationInitial extends EmailVerificationState {}

class EmailVerificationInProgress extends EmailVerificationState {}

class EmailVerificationSuccess extends EmailVerificationState {}

class EmailVerificationFailure extends EmailVerificationState {
  final String error;

  const EmailVerificationFailure(this.error);

  @override
  List<Object> get props => [error];
}
