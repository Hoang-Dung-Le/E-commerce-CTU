import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:project_ctu/pages/question.dart';
import 'package:project_ctu/pages/questiondetail.dart';
import 'package:project_ctu/pages/uploadQuestion.dart';
import 'package:project_ctu/question_provider.dart';
import 'package:project_ctu/screens/home/components/header_with_seachbox.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:project_ctu/screens/home/components/question_detail.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';

class Question_Display extends StatefulWidget {
  const Question_Display({super.key});

  @override
  State<Question_Display> createState() => _Question_DisplayState();
}

class _Question_DisplayState extends State<Question_Display> {
  List<Question> questions = [];
  bool isLoading = false;

  Future<List<Question>> getQuestion() async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:3000/api/v1/getQuestions'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);
      var data = result['result'];
      List<Question> questions = [];
      for (var i = 0; i < data.length; i++) {
        int qes_id = data[i]['qes_id'];
        int user_id = data[i]['user_id'];
        String title = data[i]['title'];
        String detail = data[i]['detail'];
        int? img_id = data[i]['img_id'];
        String fake_data =
            '{"qes_id":$qes_id, "user_id":$user_id, "title":"$title", "detail":"$detail", "img_id":$img_id}';
        questions.add(Question.fromJson(jsonDecode(fake_data)));
      }

      return questions;
    } else {
      return [];
    }
  }

  void fetchData() async {
    setState(() {
      isLoading = true;
    });
    Future<List<Question>> _futureQes = getQuestion();
    await _futureQes.then((value) => {questions.addAll(value)});
    setState(() {
      print(questions.length);
      isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.fetchData();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: new AlwaysStoppedAnimation<Color>(Color(0xff4f359b)),
        ),
      );
    }
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(bottom: kDefaultPadding * 2.5),
              // It will cover 20% of our total height
              height: size.height * 0.2,
              child: Stack(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(
                      left: kDefaultPadding,
                      right: kDefaultPadding,
                      bottom: 36 + kDefaultPadding,
                    ),
                    height: size.height * 0.2 - 27,
                    decoration: BoxDecoration(
                      color: kPrimaryColor,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(36),
                        bottomRight: Radius.circular(36),
                      ),
                    ),
                    child: Row(
                      children: <Widget>[
                        Text(
                          'Hi Uishopy!',
                          style: Theme.of(context)
                              .textTheme
                              .headline5
                              ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                        ),
                        Spacer(),
                        Image.asset("assets/images/logo.png")
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.symmetric(horizontal: kDefaultPadding),
                      padding:
                          EdgeInsets.symmetric(horizontal: kDefaultPadding),
                      height: 54,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 10),
                            blurRadius: 50,
                            color: kPrimaryColor.withOpacity(0.23),
                          ),
                        ],
                      ),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: TextField(
                              onChanged: (value) {
                                getQuestion();
                              },
                              decoration: InputDecoration(
                                hintText: "Search",
                                hintStyle: TextStyle(
                                  color: kPrimaryColor.withOpacity(0.5),
                                ),
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,

                                // surffix isn't working properly  with SVG
                                // thats why we use row
                                // suffixIcon: SvgPicture.asset("assets/icons/search.svg"),
                              ),
                            ),
                          ),
                          ElevatedButton(
                              onPressed: () {
                                getQuestion();
                              },
                              child:
                                  SvgPicture.asset("assets/icons/search.svg")),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: size.height * 0.7,
              child: ListView.separated(
                itemCount: questions.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => gotoDetail(
                                  context,
                                  questions[index].detail.toString(),
                                  questions[index]
                                      .qes_id
                                      .toString()))); // Print to console
                    },
                    title: Text(questions[index].title.toString()),
                    subtitle: Text('Sample subtitle for item #$index'),
                    leading: Container(
                      height: 50,
                      width: 50,
                      color: Colors.green,
                    ),
                    trailing: Icon(Icons.edit),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return const Divider();
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: (() {
          Navigator.push(
              context, MaterialPageRoute(builder: gotoUploadQuestions));
        }),
        tooltip: 'Increment',
        child: new Icon(Icons.add),
      ),
    );
  }

  void onSubmit() {}
  Widget gotoUploadQuestions(BuildContext context) {
    // print((context).read<QuestionProvider>().getTitle.toString() + " aka");
    return UploadQuestions();
  }

  Widget gotoQuestionDetail(BuildContext context, String qes_id) {
    return QuestionDetail(
      qes_id: qes_id,
    );
  }

  Widget gotoDetail(BuildContext context, String qes, String qes_id) {
    return QuestionPage(
      comments: [],
      question: qes,
      qes_id: qes_id,
    );
  }
}
