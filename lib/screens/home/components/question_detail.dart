import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:project_ctu/pages/question.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';

class QuestionDetail extends StatefulWidget {
  const QuestionDetail({super.key, required this.qes_id});
  final String qes_id;
  @override
  State<QuestionDetail> createState() => _QuestionDetailState(qes_id);
}

class _QuestionDetailState extends State<QuestionDetail> {
  var isLoading = false;
  late Question question;
  _QuestionDetailState(this.qes_id);
  final String qes_id;
  @override
  void initState() {
    super.initState();
    loading();
  }

  void loading() async {
    setState(() {
      isLoading = true;
    });

    var result = await getQes(qes_id.toString());

    setState(() {
      question = result;
      isLoading = false;
    });
  }

  Future<Question> getQes(String qes_id) async {
    // print(' chay vao ');
    final response = await http.post(
      Uri.parse('http://10.0.2.2:3000/api/v1/getQuestionDetail'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'qes_id': qes_id}),
    );

    // print(response.body);

    if (response.statusCode == 200) {
      return Question.fromJson(jsonDecode(response.body));
      // print("da khori taoL " + question.qes_id.toString());

    } else {
      return Question(
          qes_id: 0, user_id: 0, title: "", detail: "", img_id: null);
    }
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
    return Scaffold(body: Text(question.title.toString()));
  }
}
