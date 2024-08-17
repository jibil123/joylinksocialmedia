import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeInitial()) {
    on<LightThemeEvent>((event, emit) {
     return emit(ThemeState(isSwitched:event.isSwitched));
    });
      on<DarkThemeEvent>((event, emit) {
      return emit(ThemeState(isSwitched:event. isSwitched));
    });

  }
}
