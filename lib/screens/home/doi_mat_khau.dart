import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ChangePasswordPage extends StatefulWidget {
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  late String _oldPassword;
  late String _newPassword;
  late String _confirmPassword;

  void _submitForm() async {
    final prefs = await SharedPreferences.getInstance();
    final savedPassword = prefs.getString('password');

    if (_oldPassword != savedPassword) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Mật khẩu cũ không đúng'),
          content: Text('Vui lòng nhập lại mật khẩu cũ'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    if (_newPassword != _confirmPassword) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Mật khẩu mới không khớp'),
          content: Text('Vui lòng nhập lại mật khẩu mới'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    final response = await http.post(
      Uri.parse('http://10.0.2.2:3000/api/v1/doiMK'),
      body: {
        'user_id': prefs.getString('user_id'),
        'mk': _newPassword,
      },
    );

    if (response.statusCode == 200) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Đổi mật khẩu thành công'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Đổi mật khẩu thất bại'),
          content: Text('Vui lòng thử lại sau'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Đổi mật khẩu'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Mật khẩu cũ',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Vui lòng nhập mật khẩu cũ';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _oldPassword = value!;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Mật khẩu mới',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Vui lòng nhập mật khẩu mới';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _newPassword = value!;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Nhập lại mật khẩu mới',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Vui lòng nhập lại mật khẩu mới';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _confirmPassword = value!;
                  },
                ),
                SizedBox(height: 24.0),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      _submitForm();
                    }
                  },
                  child: Text('Lưu'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
