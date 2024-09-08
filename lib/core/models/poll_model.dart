import 'package:cloud_firestore/cloud_firestore.dart';

class Poll {
  final String name;
  final String pollId;
  final String question;
  final List<String> options;
  final String createdBy;
  final DateTime createdAt;
  final Map<String, int> votes; // Maps userId to the index of their selected option

  Poll({
    required this.name,
    required this.pollId,
    required this.question,
    required this.options,
    required this.createdBy,
    required this.createdAt,
    required this.votes,
  });

  factory Poll.fromMap(Map<String, dynamic> map) {
    return Poll(
      name: map['name']?? '',
      pollId: map['pollId'] ?? '',
      question: map['question'] ?? '',
      options: List<String>.from(map['options'] ?? []),
      createdBy: map['createdBy'] ?? '',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      votes: Map<String, int>.from(map['votes'] ?? {}),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name':name,
      'pollId': pollId,
      'question': question,
      'options': options,
      'createdBy': createdBy,
      'createdAt': createdAt,
      'votes': votes,
    };
  }
}
