import 'package:flutter/material.dart';
import 'package:flutter_polls/flutter_polls.dart';
import 'package:joylink/view/screens/home/poll_screen/polls.dart';

class PollScreeen extends StatefulWidget {
  const PollScreeen({super.key});

  @override
  State<PollScreeen> createState() => _PollScreeenState();
}

class _PollScreeenState extends State<PollScreeen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.all(20),
        child: ListView.builder(
          itemCount: polls.length,
          itemBuilder: (BuildContext context, int index) {
            final Map<String, dynamic> poll = polls[index];

            final int days = DateTime(
              poll['end_date'].year,
              poll['end_date'].month,
              poll['end_date'].day,
            )
                .difference(DateTime(
                  DateTime.now().year,
                  DateTime.now().month,
                  DateTime.now().day,
                ))
                .inDays;

            bool hasVoted = poll['hasVoted'] ?? false;

            return Container(
              margin: const EdgeInsets.only(bottom: 20),
              child: FlutterPolls(
                pollId: poll['id'].toString(),
                hasVoted: hasVoted,
                userVotedOptionId: poll['userVotedOptionId'].toString(),
                onVoted: (PollOption pollOption, int newTotalVotes) async {
                  /// Simulate HTTP request
                  await Future.delayed(const Duration(seconds: 1));

                  /// If HTTP status is success, return true else false
                  return true;
                },
                pollEnded: days < 0,
                pollTitle: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    poll['question'],
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                pollOptions: List<PollOption>.from(
                  poll['options'].map(
                    (option) => PollOption(
                      id: option['id'].toString(),
                      title: Text(
                        option['title'],
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      votes: option['votes'],
                    ),
                  ),
                ),
                votedPercentageTextStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                metaWidget: Row(
                  children: [
                    const SizedBox(width: 6),
                    const Text(
                      '•',
                    ),
                    const SizedBox(
                      width: 6,
                    ),
                    Text(
                      days < 0 ? "ended" : "ends in $days days",
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}