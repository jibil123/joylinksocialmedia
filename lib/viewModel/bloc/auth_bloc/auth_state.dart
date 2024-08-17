part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final User?user ;
  Authenticated(this.user);
}

class UnAuthenticated extends AuthState{}

class AuthenticatedErrors extends AuthState{

  final String message;
  AuthenticatedErrors({required this.message});
}
