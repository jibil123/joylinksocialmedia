part of 'google_auth_bloc.dart';

@immutable
sealed class GoogleAuthState {}


final class GoogleAuthInitial extends GoogleAuthState {}

final class GoogleAuthLoading extends GoogleAuthState {}

final class GoogleAuthSuccess extends GoogleAuthState {}

final class GoogleAuthError extends GoogleAuthState {}
