import 'package:flutter/material.dart';
import 'package:joylink/view/screens/home/main_home.tab_bar.dart';
import 'package:joylink/view/screens/post_screen/upload_screen.dart';
import 'package:joylink/view/screens/profile_screen/profile_screen.dart';
import 'package:joylink/view/screens/search_screen/search_screen.dart';
import 'package:joylink/view/screens/settings_screen/setttings_screen.dart';

List<Widget> tabs = [
   const MainHome(),
  const UserSearchScreen(),
  const UploadScreen(),
  const SettingScreen(),
   ProfileScreen()
];
