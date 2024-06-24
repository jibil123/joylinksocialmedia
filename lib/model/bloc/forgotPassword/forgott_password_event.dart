part of 'forgott_password_bloc.dart';

@immutable
sealed class ForgottPasswordEvent {}

class ResetPasswordEvent extends ForgottPasswordEvent{
  final String email;

  ResetPasswordEvent({required this.email});
}


