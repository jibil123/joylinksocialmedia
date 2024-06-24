import 'package:flutter/material.dart';
import 'package:joylink/utils/colors.dart';

class LikeScreen extends StatelessWidget {
  const LikeScreen(
      {super.key,
      required this.onLike,
      required this.likeCount,
      required this.isLiked});
  final VoidCallback onLike;
  final int likeCount;
  final bool isLiked;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: onLike,
        icon: Icon(
          isLiked ? Icons.favorite : Icons.favorite_border,
          color: isLiked ? AppColors.redColor : AppColors.greyColor,
        ));
  }
}
