import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joylink/model/bloc/postBloc/post_bloc.dart';
import 'package:joylink/view/screens/authScreen/utils/customtextformfield.dart';

class LocationScreen extends StatelessWidget {
  LocationScreen({super.key});

  final TextEditingController locationController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    final postbloc= BlocProvider.of<PostBloc>(context);
    return BlocBuilder<PostBloc, PostState>(
      builder: (context, state) {
        if(state is CurrentLocationNameState && state.postModel!.location!.isNotEmpty){
          locationController.text=state.postModel!.location!;
        }else{
          locationController.text='';
        }
        return CustomTextField(
          hintText: 'put your location',
          controller: locationController,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Location is required';
            }
            return null;
          },
          suffixIconData: Icons.location_on,
          onSuffixIconPressed: () {
            postbloc.add(AddLocationEvent());
          },
        );
      },
    );
  }
}