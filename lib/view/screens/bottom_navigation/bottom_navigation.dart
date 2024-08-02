import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joylink/model/bloc/bottomNavigation/bottom_navigation_bloc.dart';
import 'package:joylink/view/screens/bottom_navigation/widgets/pages.dart';
import 'package:joylink/view/screens/bottom_navigation/widgets/coantainer.dart';

class BottomNavigationScreen extends StatelessWidget {
  const BottomNavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(     
      body: BlocBuilder<BottomNavigationBloc, BottomNavigationState>(
        builder: (context, state) {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(opacity: animation, child: child);
            },
            child: tabs[state.currentPageIndex],
          );
        },
      ),
      bottomNavigationBar: bottomNavigationBarContainer(context),
    );
  }
}