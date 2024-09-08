import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joylink/core/models/poll_model.dart';
import 'package:joylink/data/repositories/poll_respository/poll_repository.dart';
import 'package:joylink/viewmodel/bloc/poll_bloc/poll_bloc.dart';
import 'package:joylink/viewmodel/bloc/poll_bloc/poll_event.dart';

class AllPollsPage extends StatefulWidget {
  const AllPollsPage({super.key});

  @override
  State<AllPollsPage> createState() => _AllPollsPageState();
}

class _AllPollsPageState extends State<AllPollsPage> {
  final PollRepository pollRepository = PollRepository();
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: StreamBuilder<List<Poll>>(
        stream: pollRepository.streamAllPolls(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No polls found.'));
          } else {
            final polls = snapshot.data!;
            return ListView.builder(
              itemCount: polls.length,
              itemBuilder: (context, index) {
                final poll = polls[index];
                final totalVotes = poll.votes.length;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Card(
                    elevation: 5.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 3),
                                child: Text(
                                  "${poll.name} : ",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              Flexible(
                                child: Text(
                                  poll.question,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          ...poll.options.asMap().entries.map((entry) {
                            final optionIndex = entry.key;
                            final option = entry.value;
                            final voteCount = poll.votes.values
                                .where((v) => v == optionIndex)
                                .length;
                            final percentage = totalVotes == 0
                                ? 0
                                : (voteCount / totalVotes * 100).toInt();
                            final userVotedOption = poll.votes[userId];
                            return GestureDetector(
                              onTap: userVotedOption == null
                                  ? () {
                                      context.read<PollBloc>().add(
                                            VoteOnPollEvent(poll.pollId, userId,
                                                optionIndex),
                                          );
                                    }
                                  : null, // Disable onTap if user has already voted
                              child: Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 6.0),
                                padding: const EdgeInsets.all(12.0),
                                decoration: BoxDecoration(
                                  color: userVotedOption == optionIndex
                                      ? Colors.blue.withOpacity(0.2)
                                      : Colors.grey.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        option,
                                        style: const TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      '$percentage%',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: userVotedOption == optionIndex
                                            ? Colors.blueAccent
                                            : Colors.grey[700],
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                          const SizedBox(height: 10),
                          Text(
                            'Total Votes: $totalVotes',
                            style: const TextStyle(
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
