import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat Room',
      theme: ThemeData(
        brightness: Brightness.dark, // Dark mode
        scaffoldBackgroundColor: Colors.black, // Set scaffold background color to black
      ),
      home: ChatRoom(),
    );
  }
}

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  final List<ChatMessage> _messages = [];
  final TextEditingController _textController = TextEditingController();

  void _handleSubmitted(String text) {
    _textController.clear();
    var message = ChatMessage(
      text: text,
      isSentByMe: true, // Assuming all messages are sent by 'me' for this example
    );
    setState(() {
      _messages.insert(0, message);
      _messages.insert(0, ChatMessage(text: 'Hello, how are you?', isSentByMe: false));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Chat Room',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.menu, color: Colors.white),
            onPressed: () {
              // Handle menu action
            },
          ),
        ],
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(8.0), // Set padding of 8 to the entire screen
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                reverse: true,
                itemCount: _messages.length,
                itemBuilder: (context, index) => _messages[index],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8),
              color: Colors.black, // Set input field container color to black
              child: SafeArea(
                child: Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.add, color: Colors.white),
                      onPressed: () {},
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.black, // Set background color to black
                          border: Border.all(color: Colors.grey), // Set border color to grey
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _textController,
                                onSubmitted: _handleSubmitted,
                                decoration: InputDecoration(
                                  hintText: 'Send a message',
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: InputBorder.none, // Hide the default TextField border
                                ),
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.arrow_upward, color: Colors.white),
                              onPressed: () => _handleSubmitted(_textController.text),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatMessage extends StatelessWidget {
  final String text;
  final bool isSentByMe;

  ChatMessage({required this.text, required this.isSentByMe});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
      isSentByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (!isSentByMe)
          CircleAvatar(
            backgroundImage: NetworkImage('https://placekitten.com/200/200'), // replace with actual image URL
            radius: 16,
          ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment:
            isSentByMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: isSentByMe ? Colors.blue : Colors.grey[300],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  text,
                  style: TextStyle(color: isSentByMe ? Colors.white : Colors.black),
                ),
              ),
            ],
          ),
        ),
        if (isSentByMe)
          CircleAvatar(
            backgroundImage: NetworkImage('https://placekitten.com/200/200'), // replace with your profile image URL
            radius: 16,
          ),
      ],
    );
  }
}
