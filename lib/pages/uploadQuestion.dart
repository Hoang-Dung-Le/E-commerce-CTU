import 'dart:convert';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:project_ctu/common/theme_helper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:project_ctu/pages/question.dart';
import 'package:project_ctu/products.dart';
import 'package:project_ctu/screens/home/components/login_check.dart';
import 'package:project_ctu/user_provider.dart';
import 'dart:io';
import 'package:provider/provider.dart';

import '../screens/home/home_screen.dart';

class UploadQuestions extends StatefulWidget {
  const UploadQuestions({super.key});

  @override
  State<UploadQuestions> createState() => _UploadQuestions();
}

class _UploadQuestions extends State<UploadQuestions> {
  late String img_id_uploaded;

  XFile? image;

  final ImagePicker picker = ImagePicker();

  String? selectedValue;
  TextEditingController _controllerTitle = new TextEditingController();
  TextEditingController _controllerDetail = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LoginCheck(),
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
              child: Form(
            child: Column(
              children: [
                TextField(
                  controller: _controllerTitle,
                  decoration: ThemeHelper().textInputDecoration('Title'),
                ),
                TextField(
                  controller: _controllerDetail,
                  decoration: ThemeHelper().textInputDecoration('Detail'),
                ),

                ElevatedButton(
                  onPressed: () {
                    myAlert();
                  },
                  child: Text('Upload Photo'),
                ),
                SizedBox(
                  height: 10,
                ),
                //if image not null show the image
                //if image null show text
                image != null
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            //to show image, you type like this.
                            File(image!.path),
                            fit: BoxFit.cover,
                            width: MediaQuery.of(context).size.width,
                            height: 300,
                          ),
                        ),
                      )
                    : Text(
                        "No Image",
                        style: TextStyle(fontSize: 20),
                      ),
                ElevatedButton(onPressed: SubmitButton, child: Text('Submit'))
              ],
            ),
          )),
        ),
      ),
    );
  }

  void SubmitButton() {
    // print("img vua upload " + parse(img_id_uploaded).toString());
    print("user id : " + context.read<LoginCheck>().getUserId.toString());
    String user_id = context.read<LoginCheck>().getUserId.toString();
    if (image != null) {
      Future<Question> _futureQuestion = uploadQuestion2(
          user_id,
          _controllerTitle.text.toString(),
          _controllerDetail.text.toString(),
          parse(img_id_uploaded).toString());
    } else {
      Future<Question> _futureQuestion = uploadQuestion1(user_id,
          _controllerTitle.text.toString(), _controllerDetail.text.toString());
    }
  }

  Widget goToHome(BuildContext context) {
    return HomeScreen();
  }

  int parse(string_test) {
    int result = 0;
    for (int i = 0; i < string_test.length; i++) {
      if (int.tryParse(string_test[i]) != null) {
        result = result * 10 + int.parse(string_test[i]);
      }
    }
    return result;
  }

  Future<Question> uploadQuestion2(
      String user_id, String title, String detail, String img_id) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:3000/api/v1/uploadQuestion_2'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "user_id": user_id,
        "title": title,
        "detail": detail,
        "img_id": img_id
      }),
    );

    if (response.statusCode == 200) {
      return Question.fromJson(jsonDecode(response.body));
    } else {
      return Question(
          user_id: 2, title: "chuya ro", detail: "", img_id: 9, qes_id: 2);
    }
  }

  Future<Question> uploadQuestion1(
      String user_id, String title, String detail) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:3000/api/v1/uploadQuestion_2'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "user_id": user_id,
        "title": title,
        "detail": detail
      }),
    );

    if (response.statusCode == 200) {
      return Question.fromJson(jsonDecode(response.body));
    } else {
      return Question(
          user_id: 2, title: "chuya ro", detail: "", img_id: 9, qes_id: 2);
    }
  }

  void myAlert() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: Text('Please choose media to select'),
            content: Container(
              height: MediaQuery.of(context).size.height / 6,
              child: Column(
                children: [
                  ElevatedButton(
                    //if user click this button, user can upload image from gallery
                    onPressed: () {
                      Navigator.pop(context);
                      getImage(ImageSource.gallery);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.image),
                        Text('From Gallery'),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    //if user click this button. user can upload image from camera
                    onPressed: () {
                      Navigator.pop(context);
                      getImage(ImageSource.camera);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.camera),
                        Text('From Camera'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future getImage(ImageSource media) async {
    var img = await picker.pickImage(source: media);
    var request = http.MultipartRequest(
        'POST', Uri.parse('http://10.0.2.2:3000/api/v1/upload'));
    request.files.add(http.MultipartFile.fromBytes(
        'picture', File(img!.path).readAsBytesSync(),
        filename: img!.path));
    var res = await request.send();
    // print(res.headers.keys.toString() + " day la header");
    var res_1 = await res.stream.bytesToString();
    img_id_uploaded = res_1;
    print("day la res 1 " + res_1.toString());
    setState(() {
      image = img;
    });
  }
}
