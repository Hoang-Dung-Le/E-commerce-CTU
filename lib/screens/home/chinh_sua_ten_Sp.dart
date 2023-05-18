import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project_ctu/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../details/components/myproducts.dart';

class EditProductNamePage extends StatefulWidget {
  final String currentName;
  final String product_id;

  const EditProductNamePage(
      {required this.currentName, required this.product_id});

  @override
  _EditProductNamePageState createState() =>
      _EditProductNamePageState(product_id);
}

class _EditProductNamePageState extends State<EditProductNamePage> {
  late TextEditingController _nameController;
  final String product_id;

  _EditProductNamePageState(this.product_id);

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.currentName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> updateName(String name) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:3000/api/v1/updateNameProduct'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body:
          jsonEncode(<String, String>{"product_id": product_id, "name": name}),
    );

    if (response.statusCode == 200) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Thông báo"),
            content: Text("Cập nhật thành công"),
            actions: [
              TextButton(
                child: Text('Đóng'),
                onPressed: () {
                  Navigator.pop(context);
                },
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
            title: Text("Thông báo"),
            content: Text("Đã có lỗi xảy ra"),
            actions: [
              TextButton(
                child: Text('Đóng'),
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => ProductGrid()));
                },
              ),
            ],
          );
        },
      );
    }
  }

  void updateProduct() {
    String newName = _nameController.text;
    // Thực hiện cập nhật sản phẩm với tên mới
    // ...
    updateName(_nameController.text);
    // Quay trở lại trang quản lý sản phẩm và truyền tên mới
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chỉnh sửa tên sản phẩm'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Tên hiện tại:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 8),
            Text(
              widget.currentName,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Tên mới:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 8),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: updateProduct,
              child: Text('Cập nhật'),
            ),
          ],
        ),
      ),
    );
  }
}
