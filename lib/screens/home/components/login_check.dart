import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

import '../../../User.dart';

class LoginCheck with ChangeNotifier {
  late User user;
  late String isPrinter;

  Future<int> login(String tendang_nhap, String password) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:3000/api/v1/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
          <String, String>{'tendang_nhap': tendang_nhap, 'password': password}),
    );

    if (response.statusCode == 200) {
      this.user = User.fromJson(jsonDecode(response.body));
      isPrinter = jsonDecode(response.body)['isPrinter'].toString();
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('isPrinter', isPrinter);
      return 1;
    } else {
      return 0;
    }
  }

  int? get getUserId => user.user_id;
  String get getIsPrinter => isPrinter;
}
