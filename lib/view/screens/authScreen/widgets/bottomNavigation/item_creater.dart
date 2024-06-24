  import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joylink/model/bloc/bottomNavigation/bottom_navigation_bloc.dart';
import 'package:joylink/utils/colors.dart';
import 'package:joylink/utils/media_quary.dart';
import 'package:joylink/view/screens/authScreen/utils/bottomNavigaiton/page_changing_list.dart';

Material bottomNavIcons(
      BuildContext context, IconData icon, int itemPosition) {
    final isSelected = bottomBarIconColor(context) == itemPosition;
    const selectedColor = AppColors.primaryColor;
    const deselectedColor = AppColors.blackColor;

    return Material(
      borderRadius: BorderRadius.circular(90),
      color: isSelected ? selectedColor : deselectedColor,
      child: InkWell(
        borderRadius: BorderRadius.circular(90),
        onTap: () {
          context
              .read<BottomNavigationBloc>()
              .add(BottomNavBarPressed(currentPage: itemPosition));
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          padding: EdgeInsets.all(mediaqueryWidth(0.02, context)),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isSelected ? selectedColor : deselectedColor,
          ),
          child: Icon(
            icon,
            color: isSelected ? AppColors.blackColor : AppColors.whiteColor,
          ),
        ),
      ),
    );
  }