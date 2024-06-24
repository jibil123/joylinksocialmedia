import 'package:flutter/material.dart';
import 'package:joylink/utils/colors.dart';
import 'package:joylink/utils/media_quary.dart';
import 'package:joylink/view/screens/authScreen/widgets/bottomNavigation/nav_icons.dart';

Container bottomNavigationBarContainer(BuildContext context) {
  return Container(
    margin: EdgeInsets.all(mediaqueryHeight(0.02, context)),
    width: double.infinity, 
    decoration: BoxDecoration(
        color:AppColors.blackColor, borderRadius: BorderRadius.circular(20)),
    height: mediaqueryHeight(0.09, context),
    child: bottomNavIconsAndContainers(context),
  );
}
