import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project_ctu/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../details/components/myproducts.dart';

class EditProductDescriptionPage extends StatefulWidget {
  final String currentDescription;
  final String product_id;

  const EditProductDescriptionPage(
      {required this.currentDescription, required this.product_id});

  @override
  _EditProductDescriptionPageState createState() =>
      _EditProductDescriptionPageState(product_id);
}

class _EditProductDescriptionPageState
    extends State<EditProductDescriptionPage> {
  late TextEditingController _descriptionController;
  final String product_id;

  _EditProductDescriptionPageState(this.product_id);

  @override
  void initState() {
    super.initState();
    _descriptionController =
        TextEditingController(text: widget.currentDescription);
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> updateMota(String detail) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:3000/api/v1/updateDetailProduct'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
          <String, String>{"product_id": product_id, "detail": detail}),
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
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => ProductGrid()));
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
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  void updateProduct() {
    String newDescription = _descriptionController.text;
    // Thực hiện cập nhật sản phẩm với miêu tả mới
    // ...
    updateMota(_descriptionController.text);
    // Quay trở lại trang quản lý sản phẩm và truyền miêu tả mới
    // Navigator.pop(context, newDescription);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chỉnh sửa miêu tả sản phẩm'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Miêu tả hiện tại:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 8),
            Text(
              widget.currentDescription,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Miêu tả mới:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 8),
            TextFormField(
              controller: _descriptionController,
              maxLines: 3,
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
