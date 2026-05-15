import 'package:flutter/material.dart';

class ChatBoardScreen extends StatefulWidget {
  @override
  _ChatBoardScreenState createState() => _ChatBoardScreenState();
}

class _ChatBoardScreenState extends State<ChatBoardScreen> {
  final TextEditingController messageController = TextEditingController();
  List<Map<String, dynamic>> messages = [];

  void sendMessage() {
    final text = messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      messages.insert(0, {"text": text, "isMe": true});
    });

    messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Support Chat"),
        backgroundColor: Color(0xFF30588C),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                reverse: true,
                padding: EdgeInsets.all(10),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final msg = messages[index];

                  return Align(
                    alignment:
                        msg["isMe"]
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.symmetric(vertical: 4),
                      decoration: BoxDecoration(
                        color:
                            msg["isMe"]
                                ? Color(0xFF30588C)
                                : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        msg["text"],
                        style: TextStyle(
                          color: msg["isMe"] ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      decoration: InputDecoration(
                        hintText: "Type a message...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(width: 6),

                  IconButton(
                    icon: Icon(Icons.send, color: Color(0xFF30588C)),
                    onPressed: sendMessage,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }
}
