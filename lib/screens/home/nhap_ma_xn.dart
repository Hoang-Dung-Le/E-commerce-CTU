import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project_ctu/screens/home/nhap_mk_moi.dart';

class ConfirmationCodeInput extends StatefulWidget {
  final String maxn;
  final String email;

  const ConfirmationCodeInput(
      {super.key, required this.maxn, required this.email});
  @override
  _ConfirmationCodeInputState createState() =>
      _ConfirmationCodeInputState(maxn, email);
}

class _ConfirmationCodeInputState extends State<ConfirmationCodeInput> {
  final String maxn;
  final String email;
  final List<TextEditingController> _controllers = List.generate(
    4,
    (_) => TextEditingController(),
  );

  _ConfirmationCodeInputState(this.maxn, this.email);

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  String getConfirmationCode() {
    String code = '';
    for (final controller in _controllers) {
      code += controller.text;
    }
    return code;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Nhập mã xác nhận")),
      body: Padding(
        padding: const EdgeInsets.only(top: 40),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                4,
                (index) => SizedBox(
                  width: 60,
                  child: TextField(
                    controller: _controllers[index],
                    maxLength: 1,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      counterText: '',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        FocusScope.of(context).nextFocus();
                      }
                    },
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final confirmationCode = getConfirmationCode();
                // Do something with the confirmation code
                if (confirmationCode == maxn) {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ResetPasswordPage(email: email)));
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Thông báo'),
                        content: Text('Mã xác nhận sai'),
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
                }
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
