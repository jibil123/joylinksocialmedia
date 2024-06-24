import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joylink/model/bloc/savePost/save_post_bloc.dart';
import 'package:joylink/model/model/saved_post_model.dart';

class PopupHomeMenu extends StatelessWidget {
  const PopupHomeMenu({
    super.key,
    required this.savedPostModel,
    required this.isSaveOrNot,
  });
  final SavedPostModel savedPostModel;
  final bool isSaveOrNot;
  @override
  Widget build(BuildContext context) {
    final savePost = BlocProvider.of<SavePostBloc>(context);
    return PopupMenuButton(
      itemBuilder: (context) => [
        isSaveOrNot
            ? PopupMenuItem(
                onTap: () => savePost.add(SavedPostsEvent(
                  postId: savedPostModel.postId,
                  name: savedPostModel.name,
                  date: savedPostModel.date,
                  location: savedPostModel.location,
                  postImage: savedPostModel.postImage,
                  description: savedPostModel.description,
                  profileImage: savedPostModel.profileImage,
                )),
                child: const Text('Save'),
              )
            : PopupMenuItem(
                onTap: () =>
                    savePost.add(UnSavePostEvent(id: savedPostModel.postId)),
                child: const Text('unSave')),
      ],
    );
  }
}
