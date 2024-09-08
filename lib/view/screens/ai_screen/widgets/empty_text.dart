  import 'package:flutter/material.dart';

Widget buildEmptyState(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 50,
            color: Colors.grey,
          ),
          SizedBox(height: 10),
          Text(
            "No messages yet.\nStart a conversation!",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }