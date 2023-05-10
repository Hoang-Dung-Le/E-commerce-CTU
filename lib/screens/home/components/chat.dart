import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class ChatScreen extends StatefulWidget {
  final String userId;
  final String recipientId;
  final String serverUrl;

  const ChatScreen({
    Key? key,
    required this.userId,
    required this.recipientId,
    required this.serverUrl,
  }) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late IO.Socket socket;
  final dio = Dio();
  final TextEditingController _textController = TextEditingController();
  final List<String> _messages = [];

  @override
  void initState() {
    super.initState();

    // Connect to the server
    super.initState();

    // Connect to the server
    socket = IO.io(widget.serverUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket.connect();

    // Listen for incoming messages
    socket.on('message', (data) {
      setState(() {
        _messages.add(data);
      });
    });
  }

  @override
  void dispose() {
    socket.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Build the chat UI
    // ...

    void _sendMessage(String message) async {
      // Send message to server
      final response =
          await Dio().post('${widget.serverUrl}/api/v1/message', data: {
        'senderId': widget.userId,
        'recipientId': widget.recipientId,
        'message': message,
      });

      if (response.statusCode == 200) {
        // Message sent successfully
      } else {
        // Error sending message
      }
    }

    void _getChatHistory() async {
      try {
        final response = await http.get(
          Uri.parse(
              '${widget.serverUrl}/chat/history?sender=${widget.userId}&recipient=${widget.recipientId}'),
        );
        final data = json.decode(response.body) as List<dynamic>;
        final messages = data.map((e) => e['message'] as String).toList();
        setState(() {
          _messages.addAll(messages);
        });
      } catch (e) {
        print('Error getting chat history: $e');
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with ${widget.recipientId}'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: _messages[index].startsWith(widget.userId)
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      decoration: BoxDecoration(
                        color: _messages[index].startsWith(widget.userId)
                            ? Colors.blueAccent
                            : Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Text(
                        _messages[index].replaceAll('${widget.userId}: ', ''),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(20),
            ),
            margin: EdgeInsets.all(16),
            child: Row(
              children: [
                SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    _sendMessage(_textController.text);
                    _textController.clear();
                  },
                ),
                SizedBox(width: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
