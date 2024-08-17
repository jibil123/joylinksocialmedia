part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

class CheckLoginStatusEvent extends AuthEvent{}

class LoginEvent extends AuthEvent{
  final String email;
  final String password;
  LoginEvent({required this.email,required this.password});
}

class SignupEvent extends AuthEvent{
  final UserModelDetails user;
  SignupEvent({required this.user});
}

class LogoutEvent extends AuthEvent{}

class EmailVarification extends AuthEvent{}