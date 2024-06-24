import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:joylink/viewModel/firebase/userRepo/user_repo.dart';

part 'video_upload_event.dart';
part 'video_upload_state.dart';

class VideoUploadBloc extends Bloc<VideoUploadEvent, VideoUploadState> {
  final ImagePicker _picker = ImagePicker();
  UserRepo userRepo=UserRepo();
  VideoUploadBloc() : super(VideoUploadInitial()) {
    on<PickVideoEvent>((event, emit) async {
      emit(VideoPicking());
      try {
        final video = await _picker.pickVideo(source: ImageSource.gallery);
        if (video != null) {
          emit(VideoPicked(video));
        } else {
          emit(VideoUploadInitial());
        }
      } catch (e) {
        emit(VideoUploadError('Failed to pick video: $e'));
      }
    });

  on<UploadVideoEvent>((event, emit) async {
      emit(VideoUploading());
      try {
        final storageRef = FirebaseStorage.instance.ref().child('videos/${event.video.name}.3PG');
        final uploadTask = storageRef.putFile(File(event.video.path));
         uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
          final progress = (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
          emit(VideoUploadProgress(progress));
        });
        final snapshot = await uploadTask.whenComplete(() => {});
        final videoUrl = await snapshot.ref.getDownloadURL();
        String uid = FirebaseAuth.instance.currentUser!.uid;
       final userDetails=await userRepo.getUserData(uid);
        await FirebaseFirestore.instance.collection('videos').add({
          'url': videoUrl,
          'uploadedAt': Timestamp.now(),
          'uid':userDetails?.userId,
          'profile':userDetails?.profilePic,
          'name':userDetails?.name,
          'likes':[],
          'description':event.description,
          'email':userDetails?.mail
        });
        emit(VideoUploaded());
        
      } catch (e) {
        emit(VideoUploadError('Failed to upload video: $e'));
      }
    });

  }
}
