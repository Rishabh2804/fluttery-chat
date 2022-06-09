import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    const FlutteryChatApp(),
  );
}

final ThemeData kIOSTheme = ThemeData(
  primarySwatch: Colors.orange,
  primaryColor: Colors.grey[100],
  // primaryColorBrightness: Brightness.light,
);

final ThemeData kDefaultTheme = ThemeData(
  colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.purple)
      .copyWith(secondary: Colors.orangeAccent[400]),
);

class FlutteryChatApp extends StatelessWidget {
  const FlutteryChatApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scrollBehavior: const MaterialScrollBehavior(),
      debugShowCheckedModeBanner: false,
      title: 'FlutteryChat',
      theme: defaultTargetPlatform == TargetPlatform.iOS
          ? kIOSTheme
          : kDefaultTheme,
      home: const ChatScreen(),
    );
  }
}

class ChatMessage extends StatelessWidget {
  const ChatMessage({
    required this.msg,
    required this.animationController,
    Key? key,
  }) : super(key: key);

  final String msg;
  final String _name = 'You';
  final AnimationController animationController;

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animationController,
      child: SizeTransition(
        sizeFactor: CurvedAnimation(
            parent: animationController, curve: Curves.decelerate),
        axisAlignment: 0.0,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                margin: const EdgeInsets.only(right: 16.0),
                child: CircleAvatar(
                    backgroundColor: const Color.fromARGB(255, 194, 235, 47),
                    foregroundColor: const Color.fromARGB(255, 26, 124, 237),
                    child:
                        Text(_name[0], style: const TextStyle(fontSize: 24.0))),
              ),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 162, 229, 244),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16.0),
                      bottomLeft: Radius.circular(16.0),
                    ),
                  ),
                  child: Text(
                    msg,
                    style: const TextStyle(fontSize: 16.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final List<ChatMessage> _messages = [];
  final _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isComposing = false;

  @override
  void dispose() {
    for (var message in _messages) {
      message.animationController.dispose();
    }
    super.dispose();
  }

  void _handleSubmitted(String text) {
    // if (text.isEmpty) {
    //   _focusNode.requestFocus();
    //   return;
    // }
    _textController.clear();
    var message = ChatMessage(
      msg: text,
      animationController: AnimationController(
        duration: const Duration(milliseconds: 700),
        vsync: this,
      ),
    );
    setState(() {
      _messages.insert(0, message);
      _isComposing = false;
    });
    _focusNode.requestFocus();
    message.animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FlutteryChat'),
        elevation: Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
      ),
      body: Column(
        children: [
          Flexible(
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              reverse: true,
              itemBuilder: (_, index) => _messages[index],
              itemCount: _messages.length,
            ),
          ),
          const Divider(height: 1.0),
          Container(
            decoration: BoxDecoration(color: Theme.of(context).cardColor),
            child: _buildTextComposer(),
          ),
        ],
      ),
    );
  }

  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).colorScheme.secondary),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            Flexible(
              child: TextField(
                selectionHeightStyle: BoxHeightStyle.max,
                mouseCursor: MaterialStateMouseCursor.textable,
                focusNode: _focusNode,
                controller: _textController,
                scrollController: ScrollController(),
                onSubmitted: _isComposing ? _handleSubmitted : null,
                onChanged: (text) {
                  setState(() {
                    _isComposing = text.isNotEmpty;
                    _focusNode.requestFocus();
                  });
                },
                onEditingComplete: _focusNode.requestFocus,
                decoration: const InputDecoration.collapsed(
                  hintText: 'Send a message',
                  // filled: true,
                  // fillColor: Colors.greenAccent,
                ),
                textInputAction: TextInputAction.newline,
                autofocus: true,
                enableSuggestions: true,
                autocorrect: true,
              ),
            ),
            Container(
              margin:
                  const EdgeInsets.symmetric(horizontal: 4.0, vertical: 6.0),
              child: Theme.of(context).platform == TargetPlatform.iOS
                  ? CupertinoButton(
                      child: const Text('Send'),
                      onPressed: _isComposing
                          ? () => _handleSubmitted(_textController.text)
                          : null)
                  : IconButton(
                      visualDensity: VisualDensity.comfortable,
                      icon: const Icon(Icons.send),
                      onPressed: _isComposing
                          ? () => _handleSubmitted(_textController.text)
                          : null,
                      // hoverColor: Colors.accents[11],
                      // autofocus: true,
                      mouseCursor: MaterialStateMouseCursor.clickable,
                      // focusColor: Colors.cyan,
                      color: Colors.cyan[600],
                      // splashColor: Colors.tealAccent,
                    ),
            )
          ],
        ),
      ),
    );
  }
}
