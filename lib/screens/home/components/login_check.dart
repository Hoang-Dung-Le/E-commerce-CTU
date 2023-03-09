import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';

import '../../../User.dart';

class LoginCheck with ChangeNotifier {
  late User user;

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
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      // print(response.body.runtimeType);
      // usermodel.user = User.fromJson(jsonDecode(response.body));
      // return User.fromJson(jsonDecode(response.body));
      this.user = User.fromJson(jsonDecode(response.body));
      return 1;
    } else {
      // return User(
      //     email: "",
      //     user_id: 0,
      //     tendang_nhap: "",
      //     password: "",
      //     fac_id: 12,
      //     img_id: 0);
      return 0;
    }
  }

  int? get getUserId => user.user_id;
}
