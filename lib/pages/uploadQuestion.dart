import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project_ctu/pages/question_ver2.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UploadQuestionScreen extends StatefulWidget {
  @override
  _UploadQuestionScreenState createState() => _UploadQuestionScreenState();
}

class _UploadQuestionScreenState extends State<UploadQuestionScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController detailController = TextEditingController();

  Future<void> uploadQuestion() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var user_id = pref.getString("user_id");
    final url = Uri.parse('http://10.0.2.2:3000/api/v1/uploadQuestion_2');
    final response = await http.post(
      url,
      body: {
        'user_id': user_id.toString(),
        'title': titleController.text,
        'detail': detailController.text,
      },
    );

    if (response.statusCode == 200) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Thông báo'),
            content: Text('Đăng câu hỏi thành công'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => QuestionListScreen()),
                  );
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Thông báo'),
            content: Text('Có lỗi xảy ra'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  Widget buildTitleTextField() {
    return TextFormField(
      controller: titleController,
      decoration: InputDecoration(
        labelText: 'Title',
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter a title';
        }
        return null;
      },
    );
  }

  Widget buildDetailTextField() {
    return TextFormField(
      controller: detailController,
      maxLines: 5,
      decoration: InputDecoration(
        labelText: 'Detail',
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter a detail';
        }
        return null;
      },
    );
  }

  Widget buildSubmitButton() {
    return ElevatedButton(
      onPressed: () {
        if (formKey.currentState!.validate()) {
          uploadQuestion();
        }
      },
      child: Text('Submit'),
    );
  }

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Question'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              buildTitleTextField(),
              SizedBox(height: 16),
              buildDetailTextField(),
              SizedBox(height: 16),
              buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: UploadQuestionScreen(),
  ));
}
