import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joylink/viewmodel/bloc/user_search_bloc/user_search_bloc.dart';
import 'package:joylink/core/models/search_model.dart';
import 'package:joylink/view/screens/other_profile_screen/other_profile_screen.dart';

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
      backgroundColor: Colors.teal[50],
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100.0), // Increased height
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
          child: AppBar(
            backgroundColor: Colors.teal[300],
            flexibleSpace: Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 24.0, 8.0, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: BlocBuilder<SearchQueryBloc, SearchQueryState>(
                      builder: (context, state) {
                        return TextField(
                          controller: _searchController,
                          decoration: const InputDecoration(
                            hintText: "Search users...",
                            border: InputBorder.none,
                            hintStyle: TextStyle(color: Colors.grey),
                            icon: Icon(Icons.search, color: Colors.grey),
                          ),
                          onChanged: (value) {
                            context.read<SearchQueryBloc>().add(UpdateSearchQuery(value));
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 8.0), // Space between search container and text
                  BlocBuilder<SearchQueryBloc, SearchQueryState>(
                    builder: (context, state) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 10,top: 5),
                        child: Text( 
                          state.query!.isEmpty ? "All users" : "Filtered users",
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: BlocBuilder<SearchQueryBloc, SearchQueryState>(
        builder: (context, state) {
          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('user details').snapshots(),
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
                padding: const EdgeInsets.all(8.0),
                itemCount: users.length,
                itemBuilder: (context, index) {
                  var user = users[index];
                  var userData = user.data() as Map<String, dynamic>;
                  var imageUrl = userData.containsKey('imageUrl') ? userData['imageUrl'] : '';
                  var coverImage = userData.containsKey('coverImage') ? userData['coverImage'] : '';
                  var bio = userData.containsKey('bio') ? userData['bio'] : '';
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: ListTile(
                      onTap: () {
                        if (user['uid'] == FirebaseAuth.instance.currentUser?.uid) {
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
                          following: user['following'],
                        );
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => OtherProfileScreen(userModel: userModel),
                        ));
                      },
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(30.0),
                        child: imageUrl != null && imageUrl.isNotEmpty
                            ? Image.network(imageUrl, width: 50, height: 50, fit: BoxFit.cover)
                            : Image.asset('assets/images/joylink-logo.png', width: 50, height: 50, fit: BoxFit.cover),
                      ),
                      title: Text(
                        user['name'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                      subtitle: Text(
                        user['mail'],
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14.0,
                        ),
                      ),
                    ),
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
