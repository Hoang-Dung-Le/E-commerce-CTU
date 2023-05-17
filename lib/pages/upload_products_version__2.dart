import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:project_ctu/screens/home/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductUploadPage extends StatefulWidget {
  @override
  _ProductUploadPageState createState() => _ProductUploadPageState();
}

class _ProductUploadPageState extends State<ProductUploadPage> {
  File? _imageFile;
  String? _selectedCategory;
  String? _price;
  String? _productName;
  String? _author;
  String? _subject;
  String? img_id;
  String? _detail;

  int parse(string_test) {
    int result = 0;
    for (int i = 0; i < string_test.length; i++) {
      if (int.tryParse(string_test[i]) != null) {
        result = result * 10 + int.parse(string_test[i]);
      }
    }
    return result;
  }

  Future<void> _uploadProduct() async {
    if (_imageFile == null ||
        _selectedCategory == null ||
        _price == null ||
        _productName == null ||
        _author == null ||
        _subject == null) {
      // Kiểm tra nếu chưa nhập đủ thông tin thì không gửi lên server
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Thông báo'),
            content: Text('Bạn cần nhập đầy đủ thông tin'),
            actions: [
              ElevatedButton(
                child: Text('Đóng'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return;
    }

    if (int.tryParse(_price!) == null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Thông báo'),
            content: Text('Giá tiền phải là số nguyên(đơn vị nghìn)'),
            actions: [
              ElevatedButton(
                child: Text('Đóng'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return;
    }

    var request = http.MultipartRequest(
        'POST', Uri.parse('http://10.0.2.2:3000/api/v1/upload'));
    request.files.add(http.MultipartFile.fromBytes(
        'picture', File(_imageFile!.path).readAsBytesSync(),
        filename: _imageFile!.path));
    var res = await request.send();
    // print(res.headers.keys.toString() + " day la header");
    var res_1 = await res.stream.bytesToString();
    img_id = res_1;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var user_id = prefs.getString('user_id');
    late var fac_id;
    if (_selectedCategory == 'Trường CNTT') {
      fac_id = '1';
    } else if (_selectedCategory == 'Trường Bách Khoa') {
      fac_id = '2';
    } else if (_selectedCategory == 'Trường Kinh Tế') {
      fac_id = '3';
    } else {
      fac_id = '4';
    }

    final response = await http.post(
      Uri.parse('http://10.0.2.2:3000/api/v1/uploadProducts'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "user_id": user_id.toString(),
        "price": _price.toString(),
        "img_id": parse(img_id).toString(),
        "fac_id": fac_id,
        "name": _productName.toString(),
        "subject": _author.toString(),
        "detail": _detail.toString(),
        "author": _author.toString()
      }),
    );
    if (response.statusCode == 200) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Thông báo'),
            content: Text('Upload tài liệu thành công'),
            actions: [
              ElevatedButton(
                child: Text('Đóng'),
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => HomeScreen()));
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
            title: Text('Thông báo'),
            content: Text('Upload tài liệu thất bại'),
            actions: [
              ElevatedButton(
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

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: source);
    setState(() {
      if (pickedImage != null) {
        _imageFile = File(pickedImage.path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Product'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                elevation: 2.0,
                child: InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Choose Image Source'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              _pickImage(ImageSource.camera);
                            },
                            child: Text('Camera'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              _pickImage(ImageSource.gallery);
                            },
                            child: Text('Gallery'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: _imageFile != null
                      ? Image.file(
                          _imageFile!,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          height: 200.0,
                          color: Colors.grey[200],
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.grey[800],
                          ),
                        ),
                ),
              ),
              SizedBox(height: 16.0),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
                items: [
                  DropdownMenuItem(
                    value: 'Trường CNTT',
                    child: Text('Trường CNTT'),
                  ),
                  DropdownMenuItem(
                    value: 'Trường Bách Khoa',
                    child: Text('Trường Bách Khoa'),
                  ),
                  DropdownMenuItem(
                    value: 'Trường Kinh Tế',
                    child: Text('Trường Kinh Tế'),
                  ),
                  DropdownMenuItem(
                    value: 'Trường Nông nghiệp',
                    child: Text('Trường Nông nghiệp'),
                  ),
                ],
                decoration: InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                onChanged: (value) {
                  _price = value;
                },
                decoration: InputDecoration(
                  labelText: 'Price',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                onChanged: (value) {
                  _productName = value;
                },
                decoration: InputDecoration(
                  labelText: 'Product Name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                onChanged: (value) {
                  _author = value;
                },
                decoration: InputDecoration(
                  labelText: 'Author',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                onChanged: (value) {
                  _subject = value;
                },
                decoration: InputDecoration(
                  labelText: 'Subject',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                onChanged: (value) {
                  _detail = value;
                },
                decoration: InputDecoration(
                  labelText: 'Detail',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: (() {
                  _uploadProduct();
                }),
                child: Text('Upload Product'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
