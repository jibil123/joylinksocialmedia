import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'edit_details_event.dart';
part 'edit_details_state.dart';

class EditDetailsBloc extends Bloc<EditDetailsEvent, EditDetailsState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  EditDetailsBloc() : super(EditDetailsInitial()) {
    on<FetchUserDataEvent>(_fetchUserData);
    on<UpdateUserDetaislEvent>(_updateUserProfile);
  }
  _fetchUserData(
      FetchUserDataEvent event, Emitter<EditDetailsState> emit) async {
    final user = _auth.currentUser;
    if (user != null) {
      final snapshot = await _firestore.collection('user details').doc(user.uid).get();
      final userData = snapshot.data() as Map<String, dynamic>;
      emit(UserDataFetched(userData: userData));
    } else {
      emit(UserDataFetchedFailed());
    }
  }

  _updateUserProfile(
      UpdateUserDetaislEvent event, Emitter<EditDetailsState> emit) async {
    final user = _auth.currentUser;
    if (user != null) {
      try {
        await _firestore
            .collection('user details')
            .doc(user.uid)
            .update({'name': event.name, 'bio': event.bio});
        emit(UserDataUpdated());
      } catch (e) {
        emit(UserDataUpdatedFailed());
      }
    } else {
      emit(UserDataUpdatedFailed());
    }
  }
}
