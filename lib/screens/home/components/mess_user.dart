import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project_ctu/pages/login_page.dart';
import 'package:project_ctu/screens/home/components/chat.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class ChatListUser extends StatefulWidget {
  @override
  _ChatListUser createState() => _ChatListUser();
}

class _ChatListUser extends State<ChatListUser> {
  List<ChatUser> users = [];
  var isLoading = false;

  Future getData() async {
    final prefs = await SharedPreferences.getInstance();
    var user_id = prefs.getString('user_id');
    var response = await http.post(
      Uri.parse('http://10.0.2.2:3000/api/v1/getListMessageUser'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{"user_id": user_id.toString()}),
    );
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['ds'];
      var isReads = jsonDecode(response.body)['isRead'];
      // print("_____________isread" + isReads);
      for (int i = 0; i < data.length; i++) {
        users.add(ChatUser(
            username: data[i]['tendang_nhap'],
            isRead: isReads[i] == 1 ? true : false,
            user_id: data[i]['user_id'].toString()));
      }
    }
  }

  void loading() async {
    setState(() {
      isLoading = true;
    });

    var result = await getData();

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    loading();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: new AlwaysStoppedAnimation<Color>(Color(0xff4f359b)),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Danh sách chat'),
      ),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              var user_id = prefs.getString('user_id');
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ChatScreen(
                    serverUrl: 'http://10.0.2.2:3000',
                    userId: user_id.toString(),
                    recipientId: users[index].user_id.toString(),
                  ),
                ),
              );
            },
            child: ListTile(
              leading: CircleAvatar(
                child: Text(users[index].username.substring(0, 1)),
              ),
              title: Text(
                users[index].username,
                style: TextStyle(fontSize: 18.0),
              ),
              trailing: users[index].isRead
                  ? Icon(Icons.check_circle, color: Colors.green)
                  : Icon(Icons.check_circle_outline, color: Colors.grey),
            ),
          );
        },
      ),
    );
  }
}

class ChatUser {
  final String username;
  final bool isRead;
  final String user_id;

  ChatUser(
      {required this.username, required this.isRead, required this.user_id});
}
