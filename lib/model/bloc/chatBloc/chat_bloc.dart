import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:joylink/model/model/message_model.dart';
import 'package:meta/meta.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(ChatInitial()) {
    on<SendMessage>(sendMessage);
    on<ToggleEmoji>(toggleEmoji);
    on<SendMediaMessage>(sendMediaMessage);
  }
  sendMessage(SendMessage event, Emitter<ChatState> emit) async {
    final FirebaseAuth firebaseAth = FirebaseAuth.instance;
    final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    final String currentUser = firebaseAth.currentUser!.uid;
    final String receiverId = event.reciverId;
    final Timestamp timestamp = Timestamp.now();
    final String trimMessage;

    if(event.message.length>15){
       trimMessage='${event.message.substring(0,15)}...';
    }else{
      trimMessage=event.message;
    }

    Message newMessage = Message(
        senterId: currentUser,
        receiverId: event.reciverId,
        message: event.message,
        timestamp: timestamp);
    List<String> ids = [currentUser, event.reciverId];
    ids.sort();
    String chatRoomId = ids.join("_");

    await firebaseFirestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .add(newMessage.toMap());
    await firebaseFirestore
        .collection('users')
        .doc(currentUser)
        .collection('chats')
        .doc(chatRoomId)
        .set({
      'receiverId': receiverId,
      'lastMessage': trimMessage,
      'timestamp': Timestamp.now(),
    });


    // Also add the message to the receiver's chat messages
    await firebaseFirestore
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(chatRoomId)
        .set({
      'receiverId': currentUser,
      'lastMessage': trimMessage,
      'timestamp': Timestamp.now(),
    });
  }

   void toggleEmoji(ToggleEmoji event, Emitter<ChatState> emit) {
    if (state is EmojiToggled) {
      final isEmojiVisible = !(state as EmojiToggled).isEmojiVisible;
      emit(EmojiToggled(isEmojiVisible));
    } else {
      emit(EmojiToggled(true));
    }
  }
   sendMediaMessage(SendMediaMessage event, Emitter<ChatState> emit) async {
    final FirebaseAuth firebaseAth = FirebaseAuth.instance;
    final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    final FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    final String currentUser = firebaseAth.currentUser!.uid;
    final String receiverId = event.reciverId;
    final Timestamp timestamp = Timestamp.now();
    final String fileName = DateTime.now().millisecondsSinceEpoch.toString();

    // Upload the media file to Firebase Storage
    final Reference storageReference = firebaseStorage
        .ref()
        .child('chat_media')
        .child(fileName);
    final UploadTask uploadTask = storageReference.putFile(event.file);

    // Get the URL of the uploaded file
    final TaskSnapshot taskSnapshot = await uploadTask;
    final String downloadUrl = await taskSnapshot.ref.getDownloadURL();

    Message newMessage = Message(
        senterId: currentUser,
        receiverId: event.reciverId,
        message: event.mediaType == 'image' ? '[Image]' : '[Video]',
        mediaUrl: downloadUrl,
        mediaType: event.mediaType,
        timestamp: timestamp);
    List<String> ids = [currentUser, event.reciverId];
    ids.sort();
    String chatRoomId = ids.join("_");

    await firebaseFirestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .add(newMessage.toMap());

    await firebaseFirestore
        .collection('users')
        .doc(currentUser)
        .collection('chats')
        .doc(chatRoomId)
        .set({
      'receiverId': receiverId,
      'lastMessage': newMessage.message,
      'timestamp': Timestamp.now(),
    });

    await firebaseFirestore
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(chatRoomId)
        .set({
      'receiverId': currentUser,
      'lastMessage': newMessage.message,
      'timestamp': Timestamp.now(),
    });
  }
}
