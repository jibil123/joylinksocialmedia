import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:joylink/core/models/poll_model.dart';

class PollRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addPoll(Poll poll) async {
    await _firestore.collection('polls').doc(poll.pollId).set(poll.toMap());
  }

  Future<void> deletePoll(String pollId) async {
    await FirebaseFirestore.instance.collection('polls').doc(pollId).delete();
  }

  Stream<List<Poll>> streamAllPolls() {
    return _firestore
        .collection('polls')
        .orderBy('createdAt',
            descending: true) // Order by 'createdAt' in descending order
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Poll.fromMap(doc.data())).toList();
    });
  }

  Future<void> voteOnPoll(
    String pollId, String userId, int selectedOption) async {
    final pollDoc = _firestore.collection('polls').doc(pollId);
    await pollDoc.update({
      'votes.$userId': selectedOption,
    });
  }
}
