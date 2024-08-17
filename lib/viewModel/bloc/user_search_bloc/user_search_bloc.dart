import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'user_search_event.dart';
part 'user_search_state.dart';

class SearchQueryBloc extends Bloc<SearchQueryEvent, SearchQueryState> {
  SearchQueryBloc() : super(SearchQueryState(query: '')) {
    on<UpdateSearchQuery>((event, emit) {
      emit(SearchQueryState(query: event.query));
    });
  }
}