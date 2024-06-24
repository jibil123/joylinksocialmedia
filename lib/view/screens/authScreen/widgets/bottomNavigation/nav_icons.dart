  import 'package:flutter/material.dart';
import 'package:joylink/view/screens/authScreen/widgets/bottomNavigation/item_creater.dart';

Row bottomNavIconsAndContainers(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        bottomNavIcons(context, Icons.home, 0),
        bottomNavIcons(context, Icons.search_outlined, 1),
        bottomNavIcons(context, Icons.add, 2),
        bottomNavIcons(context, Icons.settings, 3),
        bottomNavIcons(context, Icons.person, 4),
      ]);
  }