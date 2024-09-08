import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

class CallInvitationPage extends StatelessWidget {
  const CallInvitationPage(
      {super.key, });

  @override
  Widget build(BuildContext context) {
    return ZegoUIKitPrebuiltCall(
        appID: 377531080,
        callID: '',
        userID: '',
        userName: '',
        config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall(),
        appSign:
            'e75d1110063dfe81225c3844f33e22e11a696cb04f360879994e00646c4ddacb');
  }
}
