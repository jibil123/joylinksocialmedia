part of 'edit_details_bloc.dart';

@immutable
sealed class EditDetailsEvent {}

class FetchUserDataEvent extends EditDetailsEvent{}

class UpdateUserDetaislEvent extends EditDetailsEvent{
    final String name;
  final String bio;

  UpdateUserDetaislEvent({required this.name, required this.bio});

}