import 'package:flutter/material.dart';
import 'package:joylink/utils/custom_appbar.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const MyAppBar()));
        },
        child: Row(
          children: [
            Image.asset(
              'assets/images/joylink-logo.png',
              height: 30,
              width: 30,
            ),
            const SizedBox(width: 10),
            Text(title),
          ],
        ),
      ),
      
      backgroundColor: Colors.blueAccent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(50), // Adjust the radius as needed
        ),
      ),
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.purple],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(100);
}
