import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class User {
  int? user_id = 0;
  String? email = "";
  String? tendang_nhap = "";
  String? password = "";
  int? fac_id = 12;
  int? img_id = 0;

  // User() {
  //   this.user_id = 0;
  //   this.email = "";
  //   this.tendang_nhap = "";
  //   this.password = "";
  //   this.fac_id = 12;
  //   this.img_id = 0;
  // }

  User(
      {required this.user_id,
      required this.email,
      required this.tendang_nhap,
      required this.password,
      required this.fac_id,
      required this.img_id});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        user_id: json['user_id'],
        email: json['email'],
        tendang_nhap: json['tendang_nhap'],
        password: json['password'],
        fac_id: json['fac_id'],
        img_id: json['img_id']);
  }

  int get userId => this.userId;
}
