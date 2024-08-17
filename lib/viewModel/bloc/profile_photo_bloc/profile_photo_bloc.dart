import 'dart:typed_data';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
part 'profile_photo_event.dart';
part 'profile_photo_state.dart';

class ProfilePhotoBloc extends Bloc<ProfilePhotoEvent, ProfilePhotoState> {
  ProfilePhotoBloc() : super(ProfilePhotoInitial()) {
    on<SelectPhotoFromCamAndGal>((event, emit) async {
      try {
        final XFile? image =
            await ImagePicker().pickImage(source: ImageSource.gallery);
        if (image != null) {
          emit(LoadingprofileState());
          Uint8List? selectedImage = await image.readAsBytes();
          String photoName = image.name;
          firebase_storage.Reference ref = firebase_storage
              .FirebaseStorage.instance
              .ref('profile image')
              .child(photoName);
          final metadata =
              firebase_storage.SettableMetadata(contentType: 'image/jpeg');
          await ref.putData(selectedImage, metadata);
          String downloadURL = await ref.getDownloadURL();
          final auth = FirebaseAuth.instance;
          final firestore = FirebaseFirestore.instance;
          final uid = auth.currentUser?.uid;
          if (uid != null) {
            final userDoc =
                await firestore.collection('user details').doc(uid).get();
            if (userDoc.exists) {
              // Update the 'imageUrl' field in the existing user's document
              await firestore
                  .collection('user details')
                  .doc(uid)
                  .update({'imageUrl': downloadURL});
            } else {
              // Create a new document with the 'imageUrl' field
              await firestore
                  .collection('user details')
                  .doc(uid)
                  .set({'imageUrl': downloadURL});
            }
          }
          emit(ProfilePictureSelectedState(imageFile: downloadURL));
        }
      } catch (e) {
        // print(e.toString());
      }
    });

    on<SelectCoverPhotoEvent>((event, emit) async {
      try {
        final XFile? image =
            await ImagePicker().pickImage(source: ImageSource.gallery);
        if (image != null) {
          emit(LoadingCoverState());
          Uint8List? selectedImage = await image.readAsBytes();
          String photoName = image.name;
          firebase_storage.Reference ref = firebase_storage
              .FirebaseStorage.instance
              .ref('cover image')
              .child(photoName);
          final metadata =
              firebase_storage.SettableMetadata(contentType: 'image/jpeg');
          await ref.putData(selectedImage, metadata);
          String downloadURL = await ref.getDownloadURL();
          final auth = FirebaseAuth.instance;
          final firestore = FirebaseFirestore.instance;
          final uid = auth.currentUser?.uid;
          if (uid != null) {
            final userDoc =
                await firestore.collection('user details').doc(uid).get();
            if (userDoc.exists) {
              // Update the 'imageUrl' field in the existing user's document
              await firestore
                  .collection('user details')
                  .doc(uid)
                  .update({'coverImage': downloadURL});
            } else {
              // Create a new document with the 'imageUrl' field
              await firestore
                  .collection('user details')
                  .doc(uid)
                  .set({'coverImage': downloadURL});
            }
          }
          emit(CoverPictureSelectedState(imageFile: downloadURL));
        }
      } catch (e) {
        return;
      }
    });
  }
}
