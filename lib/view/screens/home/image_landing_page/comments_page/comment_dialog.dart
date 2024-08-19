import 'package:flutter/material.dart';
import 'package:joylink/view/screens/home/image_landing_page/comments_page/comment_bottom_sheet.dart';

void showCommentBottomSheet(BuildContext context, String postId) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return CommentBottomSheet(
        postId: postId,
      );
    },
  );
}
