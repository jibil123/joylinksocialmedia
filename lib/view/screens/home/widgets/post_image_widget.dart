
import 'package:flutter/material.dart';
import 'package:joylink/model/model/saved_post_model.dart';
import 'package:joylink/utils/colors.dart';
import 'package:joylink/utils/media_quary.dart';
import 'package:joylink/view/screens/home/image_preview.dart';

class PostImageWidget extends StatelessWidget {
  const PostImageWidget({
    super.key,
    required this.savedPostModel,
  });

  final SavedPostModel savedPostModel;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ImagePreviewScreen(
                description: savedPostModel.description,
                imageUrl: savedPostModel.postImage,
              ))),
      child: Container(
        width: double.infinity,
        height: mediaqueryHeight(0.2, context),
        decoration: const BoxDecoration(
          color: AppColors.greyColor,
          borderRadius:
              BorderRadius.vertical(bottom: Radius.circular(15)),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'assets/images/cover_photo.jpg',
              fit: BoxFit.cover,
            ),
            Image.network(
              savedPostModel.postImage,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                double? progress = loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null;
                return Center(
                  child: CircularProgressIndicator(
                    value: progress,
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Image.asset(
                  'assets/images/placeholder.png',
                  fit: BoxFit.cover,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
