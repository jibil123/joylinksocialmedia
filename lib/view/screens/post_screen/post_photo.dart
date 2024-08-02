import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:joylink/model/bloc/postBloc/post_bloc.dart';
import 'package:joylink/utils/colors.dart';
import 'package:joylink/utils/media_quary.dart';

class PostPhotoScreen extends StatelessWidget {
  const PostPhotoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final postBloc = BlocProvider.of<PostBloc>(context);
    return BlocConsumer<PostBloc, PostState>(
      listener: (context, state) {
        if (state is PostPhotoAdded) {
          
        }
      },
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
              color: AppColors.greyColor,
              border: Border.all(color: AppColors.whiteColor, width: 5),
              borderRadius: BorderRadius.circular(20)),
          width: mediaqueryWidth(9, context),
          height: mediaqueryHeight(0.3, context),
          child: postBloc.postModel.photo!=null
              ? Image.memory(postBloc.postModel.photo!, fit: BoxFit.cover)
              : Center(
                  child: IconButton(
                      onPressed: () async {
                        final picker = ImagePicker();
                        final pickedFile =
                            await picker.pickImage(source: ImageSource.gallery);
                        if (pickedFile != null) {
                          final imageBytes = await pickedFile.readAsBytes();
                          postBloc.add(AddPhoto(photo: imageBytes));
                        }
                      },
                      icon: const Icon(
                        Icons.add_a_photo_outlined,
                        size: 65,
                      ))),
        );
      },
    );
  }
}