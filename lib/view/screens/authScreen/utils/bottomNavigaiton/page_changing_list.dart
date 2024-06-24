import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joylink/model/bloc/bottomNavigation/bottom_navigation_bloc.dart';

int bottomBarIconColor(context) {
  return BlocProvider.of<BottomNavigationBloc>(context, listen: true)
      .state
      .currentPageIndex;
}
