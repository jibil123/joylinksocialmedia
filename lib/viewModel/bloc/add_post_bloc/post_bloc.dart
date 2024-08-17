import 'dart:typed_data';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:joylink/core/models/post_model.dart';
import 'package:joylink/viewmodel/controller/mapSerivces/map_placemark.dart';
import 'package:meta/meta.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:permission_handler/permission_handler.dart';
part 'post_event.dart';
part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  PostModel postModel=PostModel();
  PostBloc() : super(PostInitial()) {
    on<AddPhoto>(_onAddPhoto);
    on<SavePostEvent>(onSavePost);
    on<CancelPostEvent>(onCancelPost);
    on<AddLocationEvent>(onAddLocation);
  }
 void _onAddPhoto(AddPhoto event, Emitter<PostState> emit) {
    postModel.photo=event.photo;
  
    emit(PostPhotoAdded(postModel: postModel));
  }

  void onSavePost(SavePostEvent event, Emitter<PostState> emit) async {
    if(postModel.photo==null){
      emit(AddPhotoBeforeUpload());
      return;
    }
    emit(PostLoadingState());
    try {
      final auth=FirebaseAuth.instance;
      postModel.id= auth.currentUser?.uid;
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref('upload photos')
          .child(DateTime.now().microsecondsSinceEpoch.toString());
      await ref.putData(postModel.photo!);
      String downloadURL = await ref.getDownloadURL();
      DateTime now=DateTime.now();
      String dateOnly=now.toString();
      await FirebaseFirestore.instance.collection('user post').add({
        'uid':postModel.id,
        'description': postModel.description,
        'photoUrl': downloadURL,
        'location':postModel.location,
        'time': dateOnly,
        'likes':[],
      });
      postModel.id=null;
      postModel.location=null;
      postModel.description='';
      postModel.photo=null;
      emit(PostSavedState());
    } catch (e) {
     return;
    }
  }

  void onCancelPost(CancelPostEvent event, Emitter<PostState> emit) {
    postModel.location=null;
    postModel.photo=null;
    postModel.description='';
    emit(PostCanceledState());
  }
  Future< void> onAddLocation(
      AddLocationEvent event, Emitter<PostState> emit) async {
    try {
      final LocationService locationService = LocationService();
      Placemark? currentLocationName;
      Position? currentposition;
      PermissionStatus permissionStatus = await Permission.location.request();
      if(permissionStatus.isGranted){
       
         currentposition = await Geolocator.getCurrentPosition();
      currentLocationName =
          await locationService.getLocationName(currentposition);
          postModel.location=currentLocationName?.name.toString();
          emit(CurrentLocationNameState(postModel: postModel));
      }else{
         postModel.location='';
          emit(CurrentLocationNameState(postModel: postModel));
      }
    } catch (e) {
     return;
    }
  }
}
