part of 'theme_bloc.dart';

@immutable
sealed class ThemeEvent {}

class LightThemeEvent extends ThemeEvent{
  final bool isSwitched;

  LightThemeEvent({required this.isSwitched});
}

class DarkThemeEvent extends ThemeEvent{
  final bool isSwitched;

  DarkThemeEvent({required this.isSwitched});
}