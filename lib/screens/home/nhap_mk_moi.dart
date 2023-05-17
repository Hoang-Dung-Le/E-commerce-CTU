import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project_ctu/pages/login_page.dart';

class ResetPasswordPage extends StatefulWidget {
  final String email;

  const ResetPasswordPage({super.key, required this.email});
  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState(email);
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  bool _isPasswordValid = true;
  bool _isConfirmPasswordValid = true;

  final String email;

  _ResetPasswordPageState(this.email);

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> updateMK(String email, String mk) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:3000/api/v1/updateMk'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{"email": email, "mk": mk}),
    );

    if (response.statusCode == 200) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Thông báo'),
            content: Text('Đổi mật khẩu thành công'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
                },
                child: Text('okS'),
              ),
            ],
          );
        },
      );
    } else {}
  }

  void _submitForm() {
    final String password = _passwordController.text;
    final String confirmPassword = _confirmPasswordController.text;

    if (password.length < 5) {
      setState(() {
        _isPasswordValid = false;
      });
    } else if (password != confirmPassword) {
      setState(() {
        _isConfirmPasswordValid = false;
      });
    } else {
      // Do something with the new password
      updateMK(email, password);
      print('Submitted password: $password');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nhập mật khẩu mới'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Vui lòng nhập mật khẩu mới:',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Mật khẩu mới',
                border: OutlineInputBorder(),
                errorText: _isPasswordValid
                    ? null
                    : 'Mật khẩu phải chứa ít nhất 5 ký tự',
              ),
              onChanged: (value) {
                setState(() {
                  _isPasswordValid = true;
                });
              },
            ),
            SizedBox(height: 16),
            TextField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Xác nhận mật khẩu mới',
                border: OutlineInputBorder(),
                errorText: _isConfirmPasswordValid
                    ? null
                    : 'Xác nhận mật khẩu không khớp',
              ),
              onChanged: (value) {
                setState(() {
                  _isConfirmPasswordValid = true;
                });
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _submitForm,
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
