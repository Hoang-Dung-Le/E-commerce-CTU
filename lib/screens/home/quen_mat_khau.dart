import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:project_ctu/screens/home/nhap_ma_xn.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _submitForm() {
    final String email = _emailController.text;
    // Do something with the email (e.g., send password reset link)
    getMaXN(email);
  }

  Future<void> getMaXN(String email) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:3000/api/v1/getMaXacNhan'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
      }),
    );

    if (response.statusCode == 200) {
      var check = jsonDecode(response.body)['check'];
      if (check == '0') {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Thông báo'),
              content: Text(
                  'Email bạn nhập không đúng hoặc có sự cố về đường truyền'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Đóng'),
                ),
              ],
            );
          },
        );
      } else {
        var maxn = jsonDecode(response.body)['code'];
        await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ConfirmationCodeInput(
                      maxn: maxn,
                      email: email,
                    )));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quên mật khẩu'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Vui lòng nhập email của bạn để khôi phục mật khẩu:',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _submitForm,
              child: Text('Xác nhận'),
            ),
          ],
        ),
      ),
    );
  }
}
