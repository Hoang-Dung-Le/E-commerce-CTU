import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:email_validator/email_validator.dart';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:project_ctu/pages/login_page.dart';
import 'package:project_ctu/screens/home/components/printing_shop_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangePhoneNumberPage extends StatefulWidget {
  final String sdt;

  const ChangePhoneNumberPage({super.key, required this.sdt});
  @override
  _ChangePhoneNumberPageState createState() => _ChangePhoneNumberPageState(sdt);
}

class _ChangePhoneNumberPageState extends State<ChangePhoneNumberPage> {
  final TextEditingController _phoneNumberController = TextEditingController();
  final String _currentPhoneNumber;

  _ChangePhoneNumberPageState(this._currentPhoneNumber);

  Future<void> update(String name) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var user_id = pref.getString("user_id");
    final response = await http.post(
      Uri.parse('http://10.0.2.2:3000/api/v1/updateSDT'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
          <String, String>{'user_id': user_id.toString(), 'sdt': name}),
    );

    if (response.statusCode == 200) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Thông báo'),
            content: Text('Cập nhật thành công'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProfilePageShop()));
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

  @override
  void dispose() {
    _phoneNumberController.dispose();
    super.dispose();
  }

  void _submitForm() {
    String newPhoneNumber = _phoneNumberController.text;
    // Xử lý logic khi người dùng nhấn nút "Lưu"
    // ...
    update(newPhoneNumber);
    // Reset trạng thái của trường nhập liệu
    _phoneNumberController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Đổi số điện thoại'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Số điện thoại hiện tại:',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                _currentPhoneNumber,
                style: TextStyle(fontSize: 18.0),
              ),
              SizedBox(height: 24.0),
              TextFormField(
                controller: _phoneNumberController,
                decoration: InputDecoration(
                  labelText: 'Nhập số điện thoại mới',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Lưu'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
