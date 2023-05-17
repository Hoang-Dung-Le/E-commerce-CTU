import 'package:flutter/material.dart';

class Question {
  final String id;
  final String title;
  final String? imageUrl;
  final String content;

  Question({
    required this.id,
    required this.title,
    this.imageUrl,
    required this.content,
  });
}

class QuestionListPage extends StatelessWidget {
  final List<Question> questions = [
    Question(
      id: '1',
      title: 'How to learn Flutter?',
      imageUrl:
          'https://talentbold.com/Upload/news/20210416/211741043_ky-nang-dat-cau-hoi-trong-phong-van-giup-gi-duoc-cho-ban-10.jpg',
      content:
          'I want to learn Flutter, but I don\'t know where to start. Any tips?',
    ),
    Question(
      id: '2',
      title: 'Best practices for responsive design in Flutter?',
      content:
          'What are some best practices for creating responsive layouts in Flutter?',
    ),
    Question(
      id: '3',
      title: 'Flutter vs React Native: Which one should I choose?',
      imageUrl:
          'https://talentbold.com/Upload/news/20210416/211741043_ky-nang-dat-cau-hoi-trong-phong-van-giup-gi-duoc-cho-ban-10.jpg',
      content:
          'I\'m trying to decide between Flutter and React Native for my next project. What are the pros and cons of each?',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Question List'),
      ),
      body: ListView.builder(
        itemCount: questions.length,
        itemBuilder: (context, index) {
          final question = questions[index];
          return Padding(
            padding: EdgeInsets.all(16.0),
            child: Card(
              elevation: 2.0,
              child: InkWell(
                onTap: () {
                  // Xử lý khi người dùng nhấp vào câu hỏi
                  // Ví dụ: Chuyển đến trang chi tiết câu hỏi
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (question.imageUrl != null &&
                        question.imageUrl!.isNotEmpty)
                      Image.network(
                        question.imageUrl!,
                        height: 200.0,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            question.title,
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            question.content,
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              // Xử lý khi người dùng nhấn nút "Danh sách câu hỏi đã đăng"
              // Ví dụ: Chuyển đến trang danh sách câu hỏi đã đăng
            },
            child: Icon(Icons.list),
          ),
          SizedBox(height: 16.0),
          FloatingActionButton(
            onPressed: () {
              // Xử lý khi người dùng nhấn nút "Upload câu hỏi"
              // Ví dụ:
            },
            child: Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
