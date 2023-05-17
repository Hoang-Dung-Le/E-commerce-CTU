import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project_ctu/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProductPricePage extends StatefulWidget {
  final int currentPrice;
  final String product_id;
  const EditProductPricePage(
      {required this.currentPrice, required this.product_id});

  @override
  _EditProductPricePageState createState() =>
      _EditProductPricePageState(product_id);
}

class _EditProductPricePageState extends State<EditProductPricePage> {
  late TextEditingController _priceController;
  String? errorMessage;
  final String product_id;

  _EditProductPricePageState(this.product_id);

  @override
  void initState() {
    super.initState();
    _priceController =
        TextEditingController(text: widget.currentPrice.toString());
  }

  @override
  void dispose() {
    _priceController.dispose();
    super.dispose();
  }

  Future<void> updatePrice(String price) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:3000/api/v1/updateDetailProduct'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "product_id": product_id,
        "price": price.toString()
      }),
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
                  Navigator.pop(context, price);
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

  String? validatePrice(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập giá';
    }

    try {
      int.parse(value);
      return null; // Giá trị hợp lệ
    } catch (error) {
      return 'Vui lòng nhập giá là số nguyên';
    }
  }

  void updateProduct() {
    String newPrice = _priceController.text;
    String? validationResult = validatePrice(newPrice);
    if (validationResult == null) {
      int parsedPrice = int.parse(newPrice);
      updatePrice(_priceController.text);
      // Navigator.pop(context, parsedPrice);
    } else {
      setState(() {
        errorMessage = validationResult;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chỉnh sửa giá sản phẩm'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Giá hiện tại:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 8),
            Text(
              widget.currentPrice.toString(),
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Giá mới:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 8),
            TextFormField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              validator: validatePrice,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                errorText: errorMessage,
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
