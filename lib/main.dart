import 'package:flutter/material.dart';

void main() {
  runApp(
    const FlutteryChatApp(),
  );
}

class FlutteryChatApp extends StatelessWidget {
  const FlutteryChatApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FlutteryChat',
      home: ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _textController = TextEditingController();

  void _handleSubmitted(String text) {
    _textController.clear();
    
  }

  Widget _buildTextComposer() {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: TextField(
          controller: _textController,
          onSubmitted: _handleSubmitted,
          decoration:
              const InputDecoration.collapsed(hintText: 'Send a message'),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FlutteryChat'),
      ),
      body: _buildTextComposer(),
    );
  }
}
