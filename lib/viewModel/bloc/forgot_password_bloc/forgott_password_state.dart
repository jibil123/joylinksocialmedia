part of 'forgott_password_bloc.dart';

@immutable
sealed class ForgottPasswordState {}

final class ForgottPasswordInitial extends ForgottPasswordState {}

class ResetLoadingState extends ForgottPasswordState{}

 class ResetErrorState extends ForgottPasswordState{}

class ResetSuccssState extends ForgottPasswordState{}
