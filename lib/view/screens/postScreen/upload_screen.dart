import 'package:flutter/material.dart';
import 'package:joylink/view/screens/postScreen/post_screen.dart';
import 'package:joylink/view/screens/postScreen/reelUpload/reel_upload.dart';

class UploadScreen extends StatelessWidget {
  const UploadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(tabs: [
              Tab(
                text: 'image',
              ),
              Tab(
                text: 'FlickVid',
              ),
              // Tab(
              //   text: 'poll',
              // ),
            ]),
            title: const Text('post Screen'),
          ),
          body: TabBarView(children: [
            PostScreen(),
           const UploadVideoScreen(),
            // const Center(child: Text('image')),
          ]),
        ));
  }
}
