part of 'theme_bloc.dart';

 class ThemeState {
  final bool isSwitched;
  ThemeState({required this.isSwitched});
}

 class ThemeInitial extends ThemeState {
  ThemeInitial():super(isSwitched: true); 
}
