import 'package:flutter/material.dart';
import 'package:joylink/utils/media_quary.dart';
import 'package:joylink/view/screens/post_screen/post_screen.dart';
import 'package:joylink/view/screens/post_screen/reel_upload/reel_upload.dart';

class UploadScreen extends StatelessWidget {
  const UploadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Colors.teal[50],
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(100),
            child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(30)
                ),
              child: AppBar(
                backgroundColor: Colors.teal[300],
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
                title: Row(
                  children: [
                         SizedBox(
                        width: 50, // Adjust the width as needed
                        height: 50, // Adjust the height as needed
                        child: Image.asset("assets/images/joylink-logo.png",
                            )),
                            SizedBox(width: mediaqueryHeight(0.01, context),),
                    const Text(
                      'JoylinkShare',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
          ),
          body: TabBarView(children: [
            PostScreen(),
           const UploadVideoScreen(),
            // const Center(child: Text('image')),
          ]),
        ));
  }
}
