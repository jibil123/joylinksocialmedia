import 'package:flutter/material.dart';
import 'package:joylink/view/screens/home/main_home.tab_bar.dart';
import 'package:joylink/view/screens/postScreen/upload_screen.dart';
import 'package:joylink/view/screens/profileScreen/profile_screen.dart';
import 'package:joylink/view/screens/search/search_screen.dart';
import 'package:joylink/view/screens/settingsScreen/setttings_screen.dart';

List<Widget> tabs = [
   const MainHome(),
  const UserSearchScreen(),
  const UploadScreen(),
  const SettingScreen(),
   ProfileScreen()
];
