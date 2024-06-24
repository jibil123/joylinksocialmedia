import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joylink/model/bloc/editDetials/edit_details_bloc.dart';
import 'package:joylink/view/screens/authScreen/utils/custom_button.dart';
import 'package:joylink/view/screens/authScreen/utils/customtextformfield.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  late EditDetailsBloc userProfileBloc;

  @override
  void initState() {
    userProfileBloc = BlocProvider.of<EditDetailsBloc>(context);
    userProfileBloc.add(FetchUserDataEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: BlocListener<EditDetailsBloc, EditDetailsState>(
        listener: (context, state) {
          if (state is UserDataUpdated) {
            Navigator.pop(context);
          }
        },
        child: BlocBuilder<EditDetailsBloc, EditDetailsState>(
          builder: (context, state) {
            if (state is UserDataFetched) {
              final userData = state.userData;
              final name = userData?['name'] as String?;
              final bio = userData?['bio'] as String?;
              nameController.text = name ?? '';
              bioController.text = bio ?? '';
            }
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formkey,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    CustomTextField(
                        hintText: 'Name',
                        controller: nameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'please enter the bio';
                          }
                          return null;
                        }),
                    const SizedBox(height: 10),
                    CustomTextField(
                      maxLines: 5, 
                        hintText: 'Bio',
                        controller: bioController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'please enter the bio';
                          }
                          return null;
                        }),
                        const SizedBox(height: 20,),
                        CustomButton(buttonText: 'Submit', onPressed: (){
                          submitForm();
                        })
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
  void submitForm(){
    if(_formkey.currentState!.validate()){
      final newName = nameController.text;
      final newBio = bioController.text;
      userProfileBloc.add(UpdateUserDetaislEvent(name: newName, bio: newBio));
    }
  }
}
