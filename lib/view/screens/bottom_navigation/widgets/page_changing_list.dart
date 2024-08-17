import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joylink/viewmodel/bloc/bottom_navigation/bottom_navigation_bloc.dart';

int bottomBarIconColor(context) {
  return BlocProvider.of<BottomNavigationBloc>(context, listen: true)
      .state
      .currentPageIndex;
}
