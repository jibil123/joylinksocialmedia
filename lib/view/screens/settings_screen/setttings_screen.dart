import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joylink/viewmodel/bloc/auth_bloc/auth_bloc.dart';
import 'package:joylink/viewmodel/bloc/bottom_navigation/bottom_navigation_bloc.dart';
import 'package:joylink/viewmodel/bloc/theme_bloc/theme_bloc.dart';
import 'package:joylink/core/utils/mediaquery/media_query.dart';
import 'package:joylink/view/screens/login_screen/main_login_screen/login_screen.dart';
import 'package:joylink/view/screens/settings_screen/custom_settings_widget.dart';
import 'package:joylink/view/screens/settings_screen/seperate_settings_screens/info.dart';
import 'package:joylink/view/screens/settings_screen/seperate_settings_screens/privacy_policy.dart';
import 'package:joylink/view/screens/settings_screen/seperate_settings_screens/terms_conditions.dart';
import 'package:joylink/core/widgets/custom_alert_dialog/custom_alert_dialog.dart';
import 'package:share_plus/share_plus.dart';

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
        backgroundColor: Colors.teal[50],
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(100.0),
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
            child: AppBar(
              title: Row(
                children: [
                  SizedBox(
                      width: 50, // Adjust the width as needed
                      height: 50, // Adjust the height as needed
                      child: Image.asset(
                        "assets/images/joylink-logo.png",
                      )),
                  SizedBox(
                    width: mediaqueryHeight(0.01, context),
                  ),
                  const Text(
                    'Settings',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ],
              ),
              backgroundColor: Colors.teal[300],
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 10, right: 20, left: 20),
          child: Column(
            children: [
              SettingsItem(
                  icon: Icons.privacy_tip_outlined,
                  text: 'Terms and conditions',
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const TermsConditionsScreen()));
                  }),
              const SizedBox(height: 20),
              SettingsItem(
                  icon: Icons.private_connectivity,
                  text: 'Privacy and policy',
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const PrivacyPolicyScreen()));
                  }),
              const SizedBox(height: 20),
              SettingsItem(
                  icon: Icons.info,
                  text: 'Info',
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const AboutScreen()));
                  }),
              const SizedBox(height: 20),
              SettingsItem(
                  icon: Icons.share,
                  text: 'Share',
                  onTap: () {
                    Share.share(
                        'Get joylinksocialmedia from the Amazon Appstore. Check it out - https://www.amazon.com/dp/B0D7QTRLWJ/ref=apps_sf_sta');
                  }),
              const SizedBox(height: 20),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Version',
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'ABeeZee',
                    ),
                  ),
                  Text(
                    '1.0.0',
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'ABeeZee',
                    ),
                  )
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
                              message: 'Log Out of Joylink',
                              onOkPressed: () {
                                authBloc.add(LogoutEvent());
                                bottomNavBar
                                    .add(BottomNavBarPressed(currentPage: 0));
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (_) =>
                                          const LoginScreenWrapper()),
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
