import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:project_uts/screens/dmfriendlist.dart';
import 'package:project_uts/utils/colors.dart';

class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final List<ChatMessage> _messages = <ChatMessage>[];

  Future<void> _getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final File imageFile = File(pickedFile.path);
      ChatMessage message = ChatMessage(
        text: null,
        isSent: true,
        image: imageFile,
      );
      setState(() {
        _messages.insert(0, message);
      });
    }
  }

  void _handleSubmitted(String text) {
    _textController.clear();
    ChatMessage message = ChatMessage(
      text: text,
      isSent: true,
      image: null,
    );
    setState(() {
      _messages.insert(0, message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF212832),
        leading: Icon(Icons.keyboard_arrow_left, color: Color(0xFFFED36A)),
        title: Row(
          children: [
            Icon(Icons.account_circle, color: Color(0xFFFED36A), size: 30),
            SizedBox(width: 10),
            Text(
              'Username',
              style: TextStyle(
                color: Color(0xFFFED36A),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: const Color(0xFF212832),
      body: Column(
        children: <Widget>[
          Flexible(
            child: ListView.builder(
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (_, int index) => _messages[index],
            ),
          ),
          const Divider(height: 1.0),
          Container(
            decoration: BoxDecoration(color: Theme.of(context).cardColor),
            child: _buildTextComposer(context),
          ),
        ],
      ),
    );
  }

  Widget _buildTextComposer(BuildContext context) {
    return IconTheme(
      data: const IconThemeData(color: Color(0xFFFED36A)),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: _handleSubmitted,
                decoration: const InputDecoration.collapsed(
                  hintText: 'Send a message',
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: () => _handleSubmitted(_textController.text),
            ),
            IconButton(
              icon: const Icon(Icons.photo),
              onPressed: _getImage,
            ),
          ],
        ),
      ),
    );
  }
}

class ChatMessage extends StatelessWidget {
  const ChatMessage(
      {super.key, required this.text, required this.isSent, this.image});

  final String? text;
  final bool isSent;
  final File? image;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(right: 16.0),
            child: const CircleAvatar(
              child: Text('User'),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('User', style: Theme.of(context).textTheme.titleLarge),
                if (image != null)
                  Container(
                    margin: const EdgeInsets.only(top: 5.0),
                    child: Image.file(
                      image!,
                      width: 150.0,
                      height: 150.0,
                    ),
                  )
                else
                  Container(
                    margin: const EdgeInsets.only(top: 5.0),
                    child: Container(
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: isSent ? const Color(0xFFFED36A) : Colors.blue,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Text(
                        text!,
                        style: TextStyle(
                          color:
                              isSent ? const Color(0xFF212832) : Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}