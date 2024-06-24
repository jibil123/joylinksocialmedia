import 'package:flutter/material.dart';
import 'package:joylink/utils/media_quary.dart';

class ImagePreviewScreen extends StatelessWidget {
  const ImagePreviewScreen({super.key, required this.imageUrl, required this.description});
  final String imageUrl;
  final String description;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body:  Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 10,right: 10),
          child: Column(mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: double.infinity,
                  height: mediaqueryHeight(0.4, context),
                  child: Image.network(imageUrl,fit: BoxFit.fitHeight),  
                ),
                SizedBox(height: mediaqueryHeight(0.01, context),),
                Text(description,style: const TextStyle(fontSize: 18),),
              ],
            ),
        ),
      ),
      );
  }
}