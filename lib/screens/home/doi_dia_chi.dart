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

class ChangeAddressPage extends StatefulWidget {
  final String dia_chi;

  const ChangeAddressPage({super.key, required this.dia_chi});
  @override
  _ChangeAddressPageState createState() => _ChangeAddressPageState(dia_chi);
}

class _ChangeAddressPageState extends State<ChangeAddressPage> {
  final TextEditingController _addressController = TextEditingController();
  final String _currentAddress;

  _ChangeAddressPageState(this._currentAddress);

  Future<void> update(String name) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var user_id = pref.getString("user_id");
    final response = await http.post(
      Uri.parse('http://10.0.2.2:3000/api/v1/updateDiaChi'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
          <String, String>{'user_id': user_id.toString(), 'dia_chi': name}),
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
    _addressController.dispose();
    super.dispose();
  }

  void _submitForm() {
    String newAddress = _addressController.text;
    // Xử lý logic khi người dùng nhấn nút "Lưu"
    // ...
    update(newAddress);
    // Reset trạng thái của trường nhập liệu
    _addressController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Đổi địa chỉ'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Địa chỉ hiện tại:',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                _currentAddress,
                style: TextStyle(fontSize: 18.0),
              ),
              SizedBox(height: 24.0),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(
                  labelText: 'Nhập địa chỉ mới',
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
