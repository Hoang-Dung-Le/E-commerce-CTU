// import 'dart:async';
// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

// class Question2 {
//   final int id;
//   final String content;

//   Question2({required this.id, required this.content});
// }

// class Comment {
//   final String userId;
//   final String username;
//   final String questionId;
//   final String content;

//   Comment(
//       {required this.userId,
//       required this.username,
//       required this.questionId,
//       required this.content});
// }

// class QuestionPage extends StatefulWidget {
//   final String question;
//   final String qes_id;
//   final List<Comment> comments;

//   QuestionPage(
//       {required this.question, required this.comments, required this.qes_id});

//   @override
//   _QuestionPageState createState() => _QuestionPageState(qes_id: qes_id);
// }

// class _QuestionPageState extends State<QuestionPage> {
//   final TextEditingController _commentController = TextEditingController();
//   List<Comment> _comments = [];
//   final String qes_id;
//   bool isLoading = false;

//   _QuestionPageState({required String this.qes_id});

//   Future<bool> getCmt() async {
//     final prefs = await SharedPreferences.getInstance();
//     final response = await http.post(
//       Uri.parse('http://10.0.2.2:3000/api/v1/getCmt'),
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//       },
//       body: jsonEncode(<String, String>{
//         'qes_id': qes_id,
//       }),
//     );

//     if (response.statusCode == 200) {
//       var result = jsonDecode(response.body)['data'];
//       for (int i = 0; i < result.length; i++) {
//         var temp = result[i]['user_id'].toString();
//         print("tem ne" + temp);
//         // print("user ne: " + prefs.getString('user_id'));
//         var name = result[i]['tendang_nhap'];
//         if (temp == prefs.getString('user_id')) {
//           name = "Bạn";
//         }
//         _comments.add(Comment(
//             userId: result[i]['user_id'].toString(),
//             username: name,
//             questionId: result[i]['qes_id'].toString(),
//             content: result[i]['cmt']));
//       }
//       return true;
//     } else {
//       // If the server did not return a 201 CREATED response,
//       // then throw an exception.
//       throw Exception('Failed to create album.');
//     }
//   }

//   void loading() async {
//     setState(() {
//       isLoading = true;
//     });

//     var result = await getCmt();

//     setState(() {
//       isLoading = false;
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     _comments = widget.comments;
//     loading();
//   }

//   Future<void> _postComment() async {
//     final prefs = await SharedPreferences.getInstance();
//     final response = await http.post(
//       Uri.parse('http://10.0.2.2:3000/api/v1/comment'),
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//       },
//       body: jsonEncode(<String, String>{
//         'qes_id': qes_id,
//         'user_id': prefs.getString('user_id').toString(),
//         'cmt': _commentController.text
//       }),
//     );
//     final Comment comment = Comment(
//       userId:
//           prefs.getString('user_id').toString(), // replace with actual user id
//       username: 'Bạn', // replace with actual username
//       questionId: qes_id,
//       content: _commentController.text,
//     );

//     setState(() {
//       _comments.add(comment);
//       _commentController.clear();
//     });
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
//         title: Text('Question'),
//       ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Text(
//               widget.question,
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//           ),
//           Expanded(
//             child: ListView.builder(
//               itemCount: _comments.length,
//               itemBuilder: (BuildContext context, int index) {
//                 final Comment comment = _comments[index];
//                 return ListTile(
//                   title: Text(comment.username),
//                   subtitle: Text(comment.content),
//                 );
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _commentController,
//                     decoration: InputDecoration(
//                       hintText: 'Add a comment...',
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: 8),
//                 ElevatedButton(
//                   onPressed: _postComment,
//                   child: Text('Post'),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Question2 {
  final int id;
  final String content;

  Question2({required this.id, required this.content});
}

class Comment {
  final String userId;
  final String username;
  final String questionId;
  final String content;

  Comment({
    required this.userId,
    required this.username,
    required this.questionId,
    required this.content,
  });
}

class QuestionPage extends StatefulWidget {
  final String question;
  final String qesId;
  final List<Comment> comments;

  QuestionPage({
    required this.question,
    required this.comments,
    required this.qesId,
  });

  @override
  _QuestionPageState createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  final TextEditingController _commentController = TextEditingController();
  List<Comment> _comments = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _comments = widget.comments;
    loading();
  }

  Future<void> loading() async {
    setState(() {
      isLoading = true;
    });

    await getCmt();

    setState(() {
      isLoading = false;
    });
  }

  Future<void> getCmt() async {
    final prefs = await SharedPreferences.getInstance();
    final response = await http.post(
      Uri.parse('http://10.0.2.2:3000/api/v1/getCmt'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'qes_id': widget.qesId,
      }),
    );

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body)['data'];
      for (int i = 0; i < result.length; i++) {
        final temp = result[i]['user_id'].toString();
        var name = result[i]['tendang_nhap'];
        if (temp == prefs.getString('user_id')) {
          name = 'Bạn';
        }
        final comment = Comment(
          userId: temp,
          username: name,
          questionId: result[i]['qes_id'].toString(),
          content: result[i]['cmt'],
        );
        setState(() {
          _comments.add(comment);
        });
      }
    } else {
      throw Exception('Failed to fetch comments.');
    }
  }

  Future<void> _postComment() async {
    final prefs = await SharedPreferences.getInstance();
    final response = await http.post(
      Uri.parse('http://10.0.2.2:3000/api/v1/comment'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'qes_id': widget.qesId,
        'user_id': prefs.getString('user_id').toString(),
        'cmt': _commentController.text,
      }),
    );

    if (response.statusCode == 200) {
      final Comment comment = Comment(
        userId: prefs.getString('user_id').toString(),
        username: 'Bạn',
        questionId: widget.qesId,
        content: _commentController.text,
      );

      setState(() {
        _comments.add(comment);
        _commentController.clear();
      });
    } else {
      throw Exception('Failed to post comment.');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4F359B)),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Question'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(16.0),
            child: Text(
              widget.question,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: _comments.length,
              itemBuilder: (BuildContext context, int index) {
                final Comment comment = _comments[index];
                return Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: ListTile(
                    title: Text(
                      comment.username,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(comment.content),
                  ),
                );
              },
            ),
          ),
          Divider(),
          Container(
            padding: EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: 'Add a comment...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _postComment,
                  child: Text('Post'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// import 'dart:async';
// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

// class Question {
//   final int id;
//   final String content;

//   Question({required this.id, required this.content});
// }

// class Comment {
//   final String userId;
//   final String username;
//   final String questionId;
//   final String content;

//   Comment({
//     required this.userId,
//     required this.username,
//     required this.questionId,
//     required this.content,
//   });
// }

// class QuestionPage extends StatefulWidget {
//   final Question question;
//   final List<Comment> comments;

//   QuestionPage({
//     required this.question,
//     required this.comments,
//   });

//   @override
//   _QuestionPageState createState() => _QuestionPageState();
// }

// class _QuestionPageState extends State<QuestionPage> {
//   final TextEditingController _commentController = TextEditingController();
//   List<Comment> _comments = [];
//   bool isLoading = false;

//   @override
//   void initState() {
//     super.initState();
//     _comments = widget.comments;
//   }

//   Future<void> _postComment() async {
//     final prefs = await SharedPreferences.getInstance();
//     final response = await http.post(
//       Uri.parse('http://10.0.2.2:3000/api/v1/comment'),
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//       },
//       body: jsonEncode(<String, String>{
//         'qes_id': widget.question.id.toString(),
//         'user_id': prefs.getString('user_id').toString(),
//         'cmt': _commentController.text,
//       }),
//     );

//     if (response.statusCode == 200) {
//       final Comment comment = Comment(
//         userId: prefs.getString('user_id').toString(),
//         username: 'Bạn',
//         questionId: widget.question.id.toString(),
//         content: _commentController.text,
//       );

//       setState(() {
//         _comments.add(comment);
//         _commentController.clear();
//       });
//     } else {
//       throw Exception('Failed to post comment.');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Question'),
//       ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             padding: EdgeInsets.all(16.0),
//             child: Text(
//               widget.question.content,
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//           ),
//           Divider(),
//           Expanded(
//             child: ListView.builder(
//               itemCount: _comments.length,
//               itemBuilder: (BuildContext context, int index) {
//                 final Comment comment = _comments[index];
//                 return Container(
//                   padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//                   child: ListTile(
//                     title: Text(
//                       comment.username,
//                       style: TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                     subtitle: Text(comment.content),
//                   ),
//                 );
//               },
//             ),
//           ),
//           Divider(),
//           Container(
//             padding: EdgeInsets.all(16.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _commentController,
//                     decoration: InputDecoration(
//                       hintText: 'Add a comment...',
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: 8),
//                 ElevatedButton(
//                   onPressed: _postComment,
//                   child: Text('Post'),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

