import 'package:cloud_firestore/cloud_firestore.dart';

class FetchChat {
  Stream<QuerySnapshot> getMessages(String userId, String otherUserId) {
    final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join("_");
    return firebaseFirestore
        // .collection('users').doc(userId)
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timeStamp', descending: false)
        .snapshots();
  }
}
