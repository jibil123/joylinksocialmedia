import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joylink/model/bloc/PostFetchBloc/post_bloc.dart';
import 'package:joylink/model/bloc/postBloc/post_bloc.dart';
import 'package:joylink/utils/colors.dart';
import 'package:joylink/utils/media_quary.dart';
import 'package:joylink/view/screens/authScreen/utils/custom_elevated_button.dart';
import 'package:joylink/view/screens/authScreen/utils/customtextformfield.dart';
import 'package:joylink/view/screens/postScreen/location_screen.dart';
import 'package:joylink/view/screens/postScreen/post_photo.dart';

class PostScreen extends StatelessWidget {
  PostScreen({
    super.key,
  });

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    final postbloc = BlocProvider.of<PostBloc>(context);
    final postFetchBloc = BlocProvider.of<PostFetchBloc>(context);
    return BlocConsumer<PostBloc, PostState>(
      listener: (context, state) {
        if (state is PostSavedState) {
          descriptionController.text='';
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Successfully done'),
            backgroundColor: AppColors.primaryColor,
          ));
         postFetchBloc.add(FetchPostsEvent());
        }
        if (state is PostCanceledState) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Upload canceled'),
            backgroundColor: AppColors.redColor,
          ));
        }
        if (state is AddPhotoBeforeUpload) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please add a photo before upload'),
              backgroundColor: AppColors.redColor,
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is PostLoadingState) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return  Padding(
              padding: const EdgeInsets.all(15),
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      const PostPhotoScreen(),
                      SizedBox(
                        height: mediaqueryHeight(0.03, context),
                      ),
                      LocationScreen(),
                      SizedBox(
                        height: mediaqueryHeight(0.03, context),
                      ),
                      CustomTextField(
                          maxLines: 4,
                          hintText: 'Enter description',
                          controller: descriptionController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Enter the description';
                            } else {
                              return null;
                            }
                          }),
                      SizedBox(
                        height: mediaqueryHeight(0.03, context),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CustomElevatedButton(
                              label: 'Save',
                              onPressed: () {
                                postbloc.postModel.description =
                                    descriptionController.text;
                                postbloc.add(SavePostEvent());
                              },
                              icon: Icons.save),
                          CustomElevatedButton(
                              label: 'Cancel',
                              onPressed: () {
                                descriptionController.text='';
                                postbloc.add(CancelPostEvent());
                              },
                              icon: Icons.cancel)
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
        }
      },
    );
  }
}
