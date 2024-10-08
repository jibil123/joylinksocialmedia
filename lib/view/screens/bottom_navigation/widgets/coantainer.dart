import 'package:flutter/material.dart';
import 'package:joylink/core/theme/colors/colors.dart';
import 'package:joylink/core/utils/mediaquery/media_query.dart';
import 'package:joylink/view/screens/bottom_navigation/widgets/nav_icons.dart';

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
