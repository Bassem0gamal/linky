import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatWidget extends StatelessWidget {
  final bool isMe;
  final String name;
  final String text;
  final DateTime date;

  const ChatWidget(
      {super.key,
      required this.name,
      required this.text,
      required this.date,
        required this.isMe,});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
      margin: const EdgeInsets.only(top: 20),
      child: Card(
        color: isMe ? Colors.lightBlueAccent : Colors.grey[200],
        child: Wrap(
          children: [
            Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
              child: Column(
                children: [
                  Text(text,style: TextStyle(fontSize: 16),),
                  Text(DateFormat('HH:mm').format(date), textAlign: TextAlign.right,),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
