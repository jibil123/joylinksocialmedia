import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joylink/model/bloc/reel_upload_bloc/video_upload_bloc.dart';
import 'package:joylink/utils/colors.dart';
import 'package:joylink/utils/custom_snackbar.dart';
import 'package:joylink/view/screens/post_screen/reel_upload/video_preview.dart';
import 'package:joylink/viewmodel/bloc/video_preview_bloc/video_preview_bloc.dart';

class UploadVideoScreen extends StatelessWidget {
  const UploadVideoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => VideoUploadBloc()),
        BlocProvider(create: (context) => VideoPreviewBloc()),
      ],
      child: UploadVideoView(),
    );
  }
}

class UploadVideoView extends StatelessWidget {
  final TextEditingController _descriptionController = TextEditingController();

  UploadVideoView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenColor,
      body: BlocConsumer<VideoUploadBloc, VideoUploadState>(
        listener: (context, state) {
          if (state is VideoUploadFailed) {
            CustomSnackBar.showCustomSnackbar(context,
                'Kindly Upload lessthan 10Mb video', AppColors.redColor);
          } else if (state is VideoUploadError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.error)));
          } else if (state is VideoUploaded) {
            context.read<VideoPreviewBloc>().add(StopVideoPreviewEvent());
          }
        },
        builder: (context, state) {
          if (state is VideoPicking) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is VideoPicked) {
            return Padding(
              padding: const EdgeInsets.all(10),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BlocProvider(
                        create: (context) => VideoPreviewBloc()
                          ..add(LoadVideoPreviewEvent(state.video)),
                        child: const VideoPreview(),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _descriptionController,
                              decoration: const InputDecoration(
                                labelText: 'Description',
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    context
                                        .read<VideoUploadBloc>()
                                        .add(CancelBlocEvent());
                                  },
                                  icon: const Icon(
                                    size: 35,
                                    Icons.cancel_outlined,
                                    color: AppColors.redColor,
                                  )),
                              IconButton(
                                  onPressed: () {
                                    context
                                        .read<VideoUploadBloc>()
                                        .add(UploadVideoEvent(
                                          state.video,
                                          _descriptionController.text,
                                        ));
                                  },
                                  icon: const Icon(
                                    size: 35,
                                    Icons.upload,
                                    color: Colors.green,
                                  )),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else if (state is VideoUploadProgress) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Uploading: ${state.progress.toStringAsFixed(2)}%'),
                  CircularProgressIndicator(value: state.progress / 100),
                ],
              ),
            );
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      context.read<VideoUploadBloc>().add(PickVideoEvent());
                    },
                    icon: const Icon(
                      Icons.add_a_photo,
                      size: 100,
                      color: Colors.grey,
                    ),
                  ),
                  const Text('upload ShortVibe')
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
