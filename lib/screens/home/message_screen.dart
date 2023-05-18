import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project_ctu/pages/login_page.dart';
import 'package:project_ctu/screens/home/components/chat.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

// class ChatListPage extends StatefulWidget {
//   @override
//   _ChatListPageState createState() => _ChatListPageState();
// }

// class _ChatListPageState extends State<ChatListPage> {
//   List<String> users = [];
//   List<int> ids = [];
//   var isLoading = false;

//   Future getData() async {
//     final prefs = await SharedPreferences.getInstance();
//     var user_id = prefs.getString('user_id');
//     var response =
//         await http.post(Uri.parse('http://10.0.2.2:3000/api/v1/getListMessage'),
//             headers: <String, String>{
//               'Content-Type': 'application/json; charset=UTF-8',
//             },
//             body: jsonEncode(<String, String>{"user_id": user_id.toString()}));
//     if (response.statusCode == 200) {
//       var data = jsonDecode(response.body)['ds'];
//       for (int i = 0; i < data.length; i++) {
//         users.add(data[i]['tendang_nhap']);
//         ids.add(data[i]['user_id']);
//       }
//     }
//   }

//   void loading() async {
//     setState(() {
//       isLoading = true;
//     });

//     var result = await getData();

//     setState(() {
//       isLoading = false;
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     loading();
//     // getData();
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (isLoading) {
//       return Center(
//         child: CircularProgressIndicator(
//           valueColor: new AlwaysStoppedAnimation<Color>(Color(0xff4f359b)),
//         ),
//       );
//     }
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Chat List'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.logout),
//             onPressed: () {
//               // Đăng xuất khỏi ứng dụng
//             },
//           ),
//         ],
//       ),
//       body: ListView.builder(
//         itemCount: users.length,
//         itemBuilder: (BuildContext context, int index) {
//           return InkWell(
//             onTap: () async {
//               SharedPreferences prefs = await SharedPreferences.getInstance();
//               var user_id = prefs.getString('user_id');
//               Navigator.of(context).push(
//                 MaterialPageRoute(
//                   builder: (context) => ChatScreen(
//                     serverUrl: 'http://10.0.2.2:3000',
//                     userId: user_id.toString(),
//                     recipientId: ids[index].toString(),
//                   ),
//                 ),
//               );
//             },
//             child: Padding(
//               padding:
//                   const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
//               child: Row(
//                 children: [
//                   CircleAvatar(
//                     child: Text(users[index].substring(0, 1)),
//                   ),
//                   SizedBox(width: 16.0),
//                   Text(
//                     users[index],
//                     style: TextStyle(fontSize: 18.0),
//                   ),
//                   Spacer(),
//                   Icon(Icons.arrow_forward_ios),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';

// class ChatListPage extends StatefulWidget {
//   @override
//   _ChatListPageState createState() => _ChatListPageState();
// }

// class _ChatListPageState extends State<ChatListPage> {
//   List<String> users = [];
//   List<int> ids = [];
//   var isLoading = false;

//   Future getData() async {
//     final prefs = await SharedPreferences.getInstance();
//     var user_id = prefs.getString('user_id');
//     var response =
//         await http.post(Uri.parse('http://10.0.2.2:3000/api/v1/getListMessage'),
//             headers: <String, String>{
//               'Content-Type': 'application/json; charset=UTF-8',
//             },
//             body: jsonEncode(<String, String>{"user_id": user_id.toString()}));
//     if (response.statusCode == 200) {
//       var data = jsonDecode(response.body)['ds'];

//       for (int i = 0; i < data.length; i++) {
//         users.add(data[i]['tendang_nhap']);
//         ids.add(data[i]['user_id']);
//       }
//       print(
//           "data length day ne************************************************" +
//               users.length.toString());
//     }
//   }

//   void loading() async {
//     setState(() {
//       isLoading = true;
//     });

//     var result = await getData();

//     setState(() {
//       isLoading = false;
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     loading();
//     // getData();
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (isLoading) {
//       return Center(
//         child: CircularProgressIndicator(
//           valueColor: new AlwaysStoppedAnimation<Color>(Color(0xff4f359b)),
//         ),
//       );
//     }
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Danh sách chat'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.logout),
//             onPressed: () {
//               // Đăng xuất khỏi ứng dụng
//             },
//           ),
//         ],
//       ),
//       body: ListView.builder(
//         itemCount: users.length,
//         itemBuilder: (BuildContext context, int index) {
//           return InkWell(
//             onTap: () async {
//               SharedPreferences prefs = await SharedPreferences.getInstance();
//               var user_id = prefs.getString('user_id');
//               Navigator.of(context).push(
//                 MaterialPageRoute(
//                   builder: (context) => ChatScreen(
//                     serverUrl: 'http://10.0.2.2:3000',
//                     userId: user_id.toString(),
//                     recipientId: ids[index].toString(),
//                   ),
//                 ),
//               );
//             },
//             child: ListTile(
//               leading: CircleAvatar(
//                 child: Text(users[index].substring(0, 1)),
//               ),
//               title: Text(
//                 users[index],
//                 style: TextStyle(fontSize: 18.0),
//               ),
//               trailing: Icon(Icons.arrow_forward_ios),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project_ctu/pages/login_page.dart';
import 'package:project_ctu/screens/home/components/chat.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class ChatListPage extends StatefulWidget {
  @override
  _ChatListPage createState() => _ChatListPage();
}

class _ChatListPage extends State<ChatListPage> {
  List<ChatUser> users = [];
  var isLoading = false;

  Future getData() async {
    final prefs = await SharedPreferences.getInstance();
    var user_id = prefs.getString('user_id');
    var response = await http.post(
      Uri.parse('http://10.0.2.2:3000/api/v1/getListMessageShop'),
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
