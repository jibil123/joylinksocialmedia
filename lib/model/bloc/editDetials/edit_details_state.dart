part of 'edit_details_bloc.dart';

@immutable
sealed class EditDetailsState {}

final class EditDetailsInitial extends EditDetailsState {}

class UserDataFetched extends EditDetailsState{
  final Map<String, dynamic>? userData;

  UserDataFetched({required this.userData});
}

class UserDataFetchedFailed extends EditDetailsState{}

class UserDataUpdated extends EditDetailsState{}

class UserDataUpdatedFailed extends EditDetailsState{}