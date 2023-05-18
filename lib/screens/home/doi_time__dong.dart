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
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class ChangeClosingTimePage extends StatefulWidget {
  final String time_mo;

  const ChangeClosingTimePage({super.key, required this.time_mo});
  @override
  _ChangeClosingTimePage createState() => _ChangeClosingTimePage(time_mo);
}

class _ChangeClosingTimePage extends State<ChangeClosingTimePage> {
  DateTime _currentOpeningTime = DateTime.now();
  final String time_mo;

  _ChangeClosingTimePage(this.time_mo);

  void _showTimePicker() {
    DatePicker.showTimePicker(
      context,
      showSecondsColumn: false,
      onChanged: (dateTime) {
        setState(() {
          _currentOpeningTime = dateTime;
        });
      },
    );
  }

  Future<void> update(String name) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var user_id = pref.getString("user_id");
    final response = await http.post(
      Uri.parse('http://10.0.2.2:3000/api/v1/updateTimeMo'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'user_id': user_id.toString(),
        'thoi_gian_mo': name
      }),
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Đổi thời gian đóng cửa'),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Thời đóng cửa hiện tại:',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              time_mo.toString(),
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: _showTimePicker,
              child: Text('Chọn thời gian mới'),
            ),
            ElevatedButton(
                onPressed: (() {
                  update(_currentOpeningTime.toString());
                }),
                child: Text('submit'))
          ],
        ),
      ),
    );
  }
}
