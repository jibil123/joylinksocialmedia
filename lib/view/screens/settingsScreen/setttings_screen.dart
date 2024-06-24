import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joylink/model/bloc/auth_bloc/auth_bloc.dart';
import 'package:joylink/model/bloc/bottomNavigation/bottom_navigation_bloc.dart';
import 'package:joylink/model/bloc/themeBloc/theme_bloc.dart';
import 'package:joylink/utils/colors.dart';
import 'package:joylink/view/screens/authScreen/mainLoginScreen/login_screen.dart';
import 'package:joylink/view/screens/settingsScreen/custom_settings_widget.dart';
import 'package:joylink/view/screens/settingsScreen/seperate_settings_screens/info.dart';
import 'package:joylink/view/screens/settingsScreen/seperate_settings_screens/privacy_policy.dart';
import 'package:joylink/view/screens/settingsScreen/seperate_settings_screens/terms_conditions.dart';
import 'package:joylink/view/screens/widgets/custom_alert_dialog.dart';
// import 'package:package_info_plus/package_info_plus.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  // Future<String> _getAppVersion() async {
  //   final packageInfo = await PackageInfo.fromPlatform();
  //   return packageInfo.version;
  // }

  @override
  Widget build(BuildContext context) {
    final authBloc = BlocProvider.of<AuthBloc>(context);
    BlocProvider.of<ThemeBloc>(context);
    final bottomNavBar = BlocProvider.of<BottomNavigationBloc>(context);
    
    return Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
          backgroundColor: AppColors.tealColor,
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 10, right: 20, left: 20),
          child: Column(
            children: [
              SettingsItem(
                  icon: Icons.privacy_tip_outlined,
                  text: 'Terms and conditions',
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) =>  const TermsConditionsScreen ()));
                  }),
              const SizedBox(height: 20),
              SettingsItem(
                  icon: Icons.private_connectivity,
                  text: 'Privacy and policy',
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) =>  const PrivacyPolicyScreen()));
                  }),
              const SizedBox(height: 20),
              SettingsItem(
                  icon: Icons.info,
                  text: 'Info',
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const AboutScreen()));
                  }),
              const SizedBox(height: 20),
              // SettingsItem(icon: Icons.share, text: 'Share', onTap: () {}),
              // const SizedBox(height: 20),
              // FutureBuilder<String>(
              //   future: _getAppVersion(),
              //   builder: (context, snapshot) {
              //     if (snapshot.connectionState == ConnectionState.waiting) {
              //       return const CircularProgressIndicator();
              //     } else if (snapshot.hasError) {
              //       return const Text('Error loading version');
              //     } else {
              //       return SettingsItem(
              //         icon: Icons.info_outline,
              //         text: 'Version ${snapshot.data}',
              //         onTap: () {},
              //       );
              //     }
              //   },
              // ),
              const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Version', style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
              fontFamily: 'ABeeZee',
            ),),
                  Text('1.0.0', style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
              fontFamily: 'ABeeZee',
            ),)
                ],
              ),
              const SizedBox(height: 20),
              SettingsItem(
                  icon: Icons.logout,
                  text: 'Log out',
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) => CustomAlertDialog(
                              title: "Log out",
                              message: 'exit from JoyLink',
                              onOkPressed: () {
                                authBloc.add(LogoutEvent());
                                bottomNavBar.add(BottomNavBarPressed(currentPage: 0));
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(builder: (_) => const LoginScreenWrapper()),
                                  (route) => false,
                                );
                              },
                              childName: 'Ok',
                            ));
                  }),
              const SizedBox(height: 10),
            ],
          ),
        ));
  }
}
 