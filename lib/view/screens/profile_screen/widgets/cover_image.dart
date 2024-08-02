import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joylink/model/bloc/profilePhoto/profile_photo_bloc.dart';

class CoverImage extends StatelessWidget {
  const CoverImage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final coverbloc = BlocProvider.of<ProfilePhotoBloc>(context);
    final auth = FirebaseAuth.instance;
    final firestore = FirebaseFirestore.instance;

      Widget placeholder = const Stack(
      alignment: Alignment.center,
      children: [
        Image(
          height: 250,
          width: double.infinity,
          image: AssetImage('assets/images/cover_photo.jpg'),
          fit: BoxFit.cover,
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.add_a_photo,
              size: 50.0,
            ),
            SizedBox(height: 8.0), // Space between icon and text
            Text(
              'Add A Cover Photo',
              style: TextStyle(              
                fontSize: 16.0,fontWeight: FontWeight.bold
              ),
            ),
          ],
        ),
      ],
    );


    return StreamBuilder<DocumentSnapshot>(
      stream: auth.currentUser != null
          ? firestore
              .collection('user details')
              .doc(auth.currentUser!.uid)
              .snapshots()
          : null,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || !snapshot.data!.exists) {
          return placeholder;
        }

        final data = snapshot.data!.data() as Map<String, dynamic>?;
        final imageUrl = data?['coverImage'] as String?;

        return BlocBuilder<ProfilePhotoBloc, ProfilePhotoState>(
          builder: (context, state) {
            if (state is LoadingCoverState) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return GestureDetector(
              onTap: () {
                coverbloc.add(SelectCoverPhotoEvent());
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black54,
                    width: 4,
                  ),
                ),
                child: imageUrl != null
                    ? FadeInImage.assetNetwork(
                        placeholder: 'assets/images/cover_photo.jpg',
                        image: imageUrl,
                        height:250,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        fadeInDuration: const Duration(milliseconds: 500),
                        imageErrorBuilder: (context, error, stackTrace) {
                          return placeholder; // Fallback UI if image fails to load
                        },
                      )
                    : placeholder,
              ),
            );
          },
        );
      },
    );
  }
}
