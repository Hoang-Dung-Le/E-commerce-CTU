import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project_ctu/pages/login_page.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants.dart';
import '../doi_mat_khau.dart';
import '../message_screen.dart';

class ProfilePageShop extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePageShop> {
  String imageUrl = '';
  String name = '';
  String address = '';
  String email = '';
  String phone = '';
  String openTime = '';
  String closeTime = '';
  var isLoading = false;

  Future getData() async {
    final prefs = await SharedPreferences.getInstance();
    var user_id = prefs.getString('user_id');
    var response =
        await http.post(Uri.parse('http://10.0.2.2:3000/api/v1/getInfoShop'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, String>{"user_id": user_id.toString()}));
    if (response.statusCode == 200) {
      var data = json.decode(response.body)['check'];
      setState(() {
        imageUrl = ip + data[0]['url'];
        name = data[0]['ten_cua_hang'];
        address = data[0]['dia_chi'];
        email = data[0]['email'];
        phone = data[0]['sdt'];
        openTime = data[0]['thoi_gian_mo'];
        closeTime = data[0]['thoi_gian_dong'];
      });
    }
  }

  void loading() async {
    setState(() {
      isLoading = true;
    });

    var result = await getData();

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    loading();
    // getData();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: new AlwaysStoppedAnimation<Color>(Color(0xff4f359b)),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.clear();
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => gotoLogin(context)));
              },
              icon: Icon(Icons.logout))
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(imageUrl),
            SizedBox(height: 20),
            Text(name),
            Text(address),
            Text(email),
            Text(phone),
            Text('Open time: $openTime - Close time: $closeTime'),
            ElevatedButton(
                onPressed: () => {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => doiMK(context)))
                    },
                child: Text("đổi mật khẩu"))
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            IconButton(
              icon: Icon(Icons.message),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ChatListPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget doiMK(BuildContext context) {
    return ChangePasswordPage();
  }

  Widget gotoLogin(BuildContext context) {
    return LoginPage();
  }
}
