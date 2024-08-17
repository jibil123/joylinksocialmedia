part of 'user_search_bloc.dart';

@immutable
abstract class SearchQueryEvent {}

class FetchUsersEvent extends SearchQueryEvent {}

class UpdateSearchQuery extends SearchQueryEvent {
  final String query;

  UpdateSearchQuery(this.query);
}