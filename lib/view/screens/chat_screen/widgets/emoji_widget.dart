
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' as foundation;
class EmojiWidget extends StatelessWidget {
  const EmojiWidget({
    super.key,
    required this.emojiShowing,
    required this.messageController,
  });

  final bool emojiShowing;
  final TextEditingController messageController;

  @override
  Widget build(BuildContext context) {
    return Offstage(
      offstage: !emojiShowing,
      child: SizedBox(
        height: 250,
        child: EmojiPicker(
          onEmojiSelected: (category, emoji) {
            messageController.text += emoji.emoji;
          },
          onBackspacePressed: () {
            messageController.text = messageController.text.characters.skipLast(1).string;
          },
          config: Config(
            height: 256,
            checkPlatformCompatibility: true,
            emojiViewConfig: EmojiViewConfig(
              emojiSizeMax: 28 *
                  (foundation.defaultTargetPlatform == TargetPlatform.iOS
                      ? 1.20
                      : 1.0),
            ),
            swapCategoryAndBottomBar: false,
            skinToneConfig: const SkinToneConfig(),
            categoryViewConfig: const CategoryViewConfig(),
            bottomActionBarConfig: const BottomActionBarConfig(),
            searchViewConfig: const SearchViewConfig(),
          ),
        ),
      ),
    );
  }
}