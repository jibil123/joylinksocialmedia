import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:joylink/utils/colors.dart';
import 'package:joylink/view/screens/profileScreen/profile_edit_screen.dart';

class ProfileInfo extends StatelessWidget {
  const ProfileInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;
    final firestore = FirebaseFirestore.instance;
    return StreamBuilder<DocumentSnapshot>(
      stream: auth.currentUser != null
          ? firestore
              .collection('user details')
              .doc(auth.currentUser!.uid)
              .snapshots()
          : null,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (!snapshot.hasData || snapshot.data == null) {
          return const Text('No data available');
        }
        final data = snapshot.data!.data() as Map<String, dynamic>?;
        if (data == null) {
          return const Text('Data is null');
        }
        final userName = data['name'] as String?;
        final bio = data['bio'] as String?;
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            userName ?? 'No name',
                            style: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(onPressed:()=> Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const ProfileEditScreen())), icon: const Icon(Icons.edit,color:AppColors.tealColor,))
                        ],
                      ),
                      
                      Text(
                        bio != null ? "Bio    : $bio" : "Bio     : Null",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ],
        );
      },
    );
  }
}
