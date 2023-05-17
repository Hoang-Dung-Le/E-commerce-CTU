import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadQuestionPage extends StatefulWidget {
  @override
  _UploadQuestionPageState createState() => _UploadQuestionPageState();
}

class _UploadQuestionPageState extends State<UploadQuestionPage> {
  File? _imageFile;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedImage != null) {
        _imageFile = File(pickedImage.path);
      }
    });
  }

  void _uploadQuestion() {
    final String title = _titleController.text;
    final String content = _contentController.text;

    // Thực hiện xử lý upload câu hỏi
    // Ví dụ: Gửi dữ liệu lên server, lưu câu hỏi vào cơ sở dữ liệu, vv.

    // Reset form
    _imageFile = null;
    _titleController.clear();
    _contentController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Question'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 200.0,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  border: Border.all(color: Colors.grey[400]!),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: _imageFile != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.file(
                          _imageFile!,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Center(
                        child: Icon(Icons.add_a_photo,
                            size: 64.0, color: Colors.grey[400]),
                      ),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: 'Enter title',
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _contentController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Enter content',
                labelText: 'Content',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: _uploadQuestion,
              child: Text('Upload Question'),
            ),
          ],
        ),
      ),
    );
  }
}
