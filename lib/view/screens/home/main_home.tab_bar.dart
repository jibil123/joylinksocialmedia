import 'package:flutter/material.dart';
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
            backgroundColor: Colors.teal[200],
            leading: const Padding(
            padding: EdgeInsets.only(left: 20), // Adjust padding as needed
            child: SizedBox(
              width: 45, // Adjust the width as needed
              height: 45, // Adjust the height as needed
              child: Image(
                image: AssetImage('assets/images/joylink-logo.png'),
              ),
            ),
          ),
             title: const Text(
            'Home',
            style: TextStyle(fontWeight: FontWeight.bold),
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
          body: const TabBarView(children: [
            HomeScreen(),
            ReelScreen(),
            // Center(child: Text('poll')),
          ]),
        ));
  }
}