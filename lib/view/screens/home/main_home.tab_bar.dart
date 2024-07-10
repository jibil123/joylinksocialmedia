import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:joylink/utils/media_quary.dart';
import 'package:joylink/view/screens/chatScreen/chat_list.dart';
import 'package:joylink/view/screens/home/home_screen.dart';
import 'package:joylink/view/screens/home/reelScreen.dart/reel_screen.dart';

class MainHome extends StatelessWidget {
  const MainHome({super.key});
  final bool isSaved = false;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Colors.teal[50],
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(100.0),
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
              child: AppBar(
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
                backgroundColor: Colors.teal[300],
                title: Row(
                  children: [
                         SizedBox(
                        width: 50, // Adjust the width as needed
                        height: 50, // Adjust the height as needed
                        child: Image.asset("assets/images/joylink-logo.png",
                            )),
                            SizedBox(width: mediaqueryHeight(0.01, context),),
                    const Text(
                      'Joylink Feed',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ],
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: IconButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const ChatListScreen()));
                        },
                        icon: const Icon(Icons.chat)),
                  )
                ],
              ),
            ),
          ),
          body: const TabBarView(children: [
            HomeScreen(),
            ReelScreen(),
            // Center(child: Text('poll')),
          ]),
        ));
  }
}
