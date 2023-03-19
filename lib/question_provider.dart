import 'package:project_ctu/pages/question.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class QuestionProvider with ChangeNotifier {
  late Question question;

  set setQues(qes_1) => this.question = qes_1;

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

  int? get getQesId => question.qes_id;
  String? get getTitle => question.getTitle;
}
