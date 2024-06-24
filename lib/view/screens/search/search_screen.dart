import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joylink/model/bloc/userSearchBloc/user_search_bloc.dart';
import 'package:joylink/model/model/search_model.dart';
import 'package:joylink/view/screens/otherProfileScreen/other_profile_screen.dart';

class UserSearchScreen extends StatelessWidget {
  const UserSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchQueryBloc(),
      child: UserSearchView(),
    );
  }
}

class UserSearchView extends StatelessWidget {
  UserSearchView({super.key});
  final TextEditingController _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<SearchQueryBloc, SearchQueryState>(
          builder: (context, state) {
            return TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: "Search users...",
              ),
              onChanged: (value) {
                context.read<SearchQueryBloc>().add(UpdateSearchQuery(value));
              },
            );
          },
        ),
      ),
      body: BlocBuilder<SearchQueryBloc, SearchQueryState>(
        builder: (context, state) {
          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('user details')
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              var users = snapshot.data!.docs;
              if (state.query!.isNotEmpty) {
                users = users.where((user) {
                  var name = user['name'].toString().toLowerCase();
                  return name.contains(state.query!.toLowerCase());
                }).toList();
              }
              return ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  var user = users[index];
                  var userData = user.data() as Map<String, dynamic>;
                  var imageUrl = userData.containsKey('imageUrl')
                      ? userData['imageUrl']
                      : '';
                  var coverImage = userData.containsKey('coverImage')
                      ? userData['coverImage']
                      : '';
                  var bio = userData.containsKey('bio') ? userData['bio'] : '';
                  return ListTile(
                    onTap: () {
                       if (user['uid'] ==FirebaseAuth.instance.currentUser?.uid) {
                       
                        return;
                      }
                      final UserModel userModel = UserModel(
                          id: user['uid'],
                          name: user['name'],
                          mail: user['mail'],
                          imageUrl: imageUrl,
                          coverImage: coverImage,
                          bio: bio,
                          followers: user['followers'],
                          following: user['following']);
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              OtherProfileScreen(userModel: userModel)));
                    },
                    leading: CircleAvatar(
                      backgroundImage: imageUrl != null && imageUrl.isNotEmpty
                          ? NetworkImage(imageUrl)
                          : const AssetImage('assets/images/joylink-logo.png')
                              as ImageProvider,
                    ),
                    title: Text(user['name']),
                    subtitle: Text(user['mail']),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
