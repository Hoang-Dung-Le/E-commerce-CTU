import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project_ctu/pages/questiondetail.dart';
import 'dart:convert';

import 'package:project_ctu/pages/uploadQuestion.dart';

class Question {
  final int qesId;
  final int userId;
  final String title;
  final String detail;

  Question({
    required this.qesId,
    required this.userId,
    required this.title,
    required this.detail,
  });
}

class SearchQuestion extends StatefulWidget {
  final String searchName;

  const SearchQuestion({super.key, required this.searchName});
  @override
  _SearchQuestion createState() => _SearchQuestion(searchName);
}

class _SearchQuestion extends State<SearchQuestion> {
  final String searchName;
  List<Question> questions = [];
  bool isLoading = true;
  TextEditingController searchController = TextEditingController();

  _SearchQuestion(this.searchName);

  @override
  void initState() {
    super.initState();
    fetchQuestions();
  }

  Future<void> fetchQuestions() async {
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:3000/api/v1/searchQuestion'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "searchName": searchName
          // "product_date": product.product_date.toString()
        }),
      );
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body)['result'];
        List<Question> questionList = jsonData.map<Question>((item) {
          return Question(
            qesId: item['qes_id'],
            userId: item['user_id'],
            title: item['title'],
            detail: item['detail'],
          );
        }).toList();
        setState(() {
          questions = questionList;
          isLoading = false;
        });
      } else {
        throw Exception('Failed to fetch questions');
      }
    } catch (error) {
      print(error);
      throw Exception('Failed to fetch questions');
    }
  }

  List<Question> searchQuestions(String query) {
    return questions.where((question) {
      final titleLower = question.title.toLowerCase();
      final detailLower = question.detail.toLowerCase();
      final searchLower = query.toLowerCase();
      return titleLower.contains(searchLower) ||
          detailLower.contains(searchLower);
    }).toList();
  }

  Widget buildLoadingIndicator() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget buildQuestionList(List<Question> filteredQuestions) {
    return Scaffold(
      body: ListView.builder(
        itemCount: filteredQuestions.length,
        itemBuilder: (BuildContext context, int index) {
          final detail = filteredQuestions[index].detail;
          final truncatedDetail =
              detail.length <= 100 ? detail : '${detail.substring(0, 100)}...';
          return Card(
            elevation: 2,
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text(
                filteredQuestions[index].title,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                truncatedDetail,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => QuestionPage(
                            comments: [],
                            question: questions[index].detail,
                            qesId: questions[index].qesId.toString(),
                          )),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget buildSearchBar() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: TextField(
        controller: searchController,
        onChanged: (value) {
//           setState(() {
//             // Lọc danh sách câu hỏi khi giá trị trong thanh tìm kiếm thay đổi
//             if (value.length == 0){
//               setState(() {

//               });
//             } else {
// final filteredQuestions = searchQuestions(value);
//             questions = filteredQuestions;
//             }

//           }
//           );
        },
        decoration: InputDecoration(
          hintText: 'Search questions',
          prefixIcon: Icon(Icons.search),
          suffixIcon: IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Xóa giá trị trong thanh tìm kiếm
              // searchController.clear();
              // setState(() {
              //   questions = searchQuestions('');
              // });
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SearchQuestion(
                          searchName: searchController.text,
                        )),
              );
            },
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Widget buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => UploadQuestionScreen()),
        );
      },
      child: Icon(Icons.add),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredQuestions = searchQuestions(searchController.text);

    return Scaffold(
      appBar: AppBar(
        title: Text('Question List'),
      ),
      body: isLoading
          ? buildLoadingIndicator()
          : Column(
              children: [
                buildSearchBar(),
                Expanded(
                  child: buildQuestionList(filteredQuestions),
                ),
              ],
            ),
      floatingActionButton: buildFloatingActionButton(),
    );
  }
}

class QuestionDetailScreen extends StatelessWidget {
  final Question question;

  QuestionDetailScreen({required this.question});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Question Detail'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question.title,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(question.detail),
          ],
        ),
      ),
    );
  }
}
