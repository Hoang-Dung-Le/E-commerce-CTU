import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:project_ctu/common/theme_helper.dart';
import 'package:project_ctu/products.dart';
import 'package:project_ctu/question_provider.dart';
import 'package:project_ctu/screens/home/components/login_check.dart';
import 'package:project_ctu/screens/home/components/printing_shop_screen.dart';
import 'package:project_ctu/screens/home/components/recommend.dart';
import 'package:project_ctu/screens/home/home_screen.dart';
import 'package:project_ctu/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:project_ctu/User.dart';

import '../User.dart';
import '../screens/home/nhap_ma_xn.dart';
import '../screens/home/quen_mat_khau.dart';
import 'registration_page.dart';
import 'widgets/header_widget.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  double _headerHeight = 250;
  Key _formKey = GlobalKey<FormState>();
  TextEditingController _userController = new TextEditingController();
  TextEditingController _passController = new TextEditingController();
  late Future<User> _futureUser;
  late SharedPreferences _prefs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _prefs = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LoginCheck()),
      ],
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: _headerHeight,
                child: HeaderWidget(_headerHeight, true,
                    Icons.login_rounded), //let's create a common header widget
              ),
              SafeArea(
                child: Container(
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                    margin: EdgeInsets.fromLTRB(
                        20, 10, 20, 10), // This will be the login form
                    child: Column(
                      children: [
                        Text(
                          'Hello',
                          style: TextStyle(
                              fontSize: 60, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Signin into your account',
                          style: TextStyle(color: Colors.grey),
                        ),
                        SizedBox(height: 30.0),
                        Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                Container(
                                  child: TextField(
                                    controller: _userController,
                                    decoration: ThemeHelper()
                                        .textInputDecoration('User Name',
                                            'Enter your user name'),
                                  ),
                                  decoration:
                                      ThemeHelper().inputBoxDecorationShaddow(),
                                ),
                                SizedBox(height: 30.0),
                                Container(
                                  child: TextField(
                                    controller: _passController,
                                    obscureText: true,
                                    decoration: ThemeHelper()
                                        .textInputDecoration(
                                            'Password', 'Enter your password'),
                                  ),
                                  decoration:
                                      ThemeHelper().inputBoxDecorationShaddow(),
                                ),
                                SizedBox(height: 15.0),
                                Container(
                                  margin: EdgeInsets.fromLTRB(10, 0, 10, 20),
                                  alignment: Alignment.topRight,
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ForgotPasswordPage()),
                                      );
                                    },
                                    child: Text(
                                      "Forgot your password?",
                                      style: TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  decoration: ThemeHelper()
                                      .buttonBoxDecoration(context),
                                  child: ElevatedButton(
                                    style: ThemeHelper().buttonStyle(),
                                    child: Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(40, 10, 40, 10),
                                      child: Text(
                                        'Sign In'.toUpperCase(),
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                    ),
                                    onPressed: () async {
                                      final prefs =
                                          await SharedPreferences.getInstance();
                                      var result = (context)
                                          .read<LoginCheck>()
                                          .login(_userController.text,
                                              _passController.text);
                                      int temp;
                                      result.then((value) async => {
                                            if (value == 1)
                                              {
                                                await savePassword(
                                                    _passController.text),
                                                await saveLoginStatus(
                                                  true,
                                                  (context)
                                                      .read<LoginCheck>()
                                                      .getUserId
                                                      .toString(),
                                                ),
                                                if (prefs.getString(
                                                        'isPrinter') ==
                                                    '1')
                                                  {
                                                    await Navigator.pushReplacement(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                gotoShop(
                                                                    context)))
                                                  }
                                                else
                                                  {
                                                    await Navigator.pushReplacement(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                goToHome(
                                                                    context)))
                                                  }
                                              }
                                            else
                                              {
                                                showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        title:
                                                            Text('Thông báo'),
                                                        content: Text(
                                                            'Tên tài khoản hoặc mật khẩu không chính xác'),
                                                        actions: [
                                                          ElevatedButton(
                                                            child: Text('Đóng'),
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                          ),
                                                        ],
                                                      );
                                                    })
                                              }
                                          });
                                    },
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.fromLTRB(10, 20, 10, 20),
                                  //child: Text('Don\'t have an account? Create'),
                                  child: Text.rich(TextSpan(children: [
                                    TextSpan(text: "Don\'t have an account? "),
                                    TextSpan(
                                      text: 'Create',
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      RegistrationPage()));
                                        },
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context)
                                              .backgroundColor),
                                    ),
                                  ])),
                                ),
                              ],
                            )),
                      ],
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> saveLoginStatus(bool isLoggedIn, String user_id) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', isLoggedIn);
    prefs.setString('user_id', user_id);
    // prefs.setString('isPrinter', isPrinter);
  }

  Future<void> savePassword(String password) async {
    final prefs = await SharedPreferences.getInstance();

    prefs.setString('password', password);
    // prefs.setString('isPrinter', isPrinter);
  }

  void onClicked() {
    // _futureUser = createUser(_userController.text, _passController.text);

    // _futureUser.then((value) => {
    //       if (value.fac_id != 12)
    //         {
    //           Navigator.pushReplacement(context,
    //               MaterialPageRoute(builder: (context) => goToHome(context)))
    //         }
    //     });
  }

  Widget goToHome(BuildContext context) {
    return HomeScreen();
  }

  Widget gotoShop(BuildContext context) {
    return ProfilePageShop();
  }

  Future<User> createUser(String tendang_nhap, String password) async {
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
      return User.fromJson(jsonDecode(response.body));
    } else {
      return User(
          email: "",
          user_id: 0,
          tendang_nhap: "",
          password: "",
          fac_id: 12,
          img_id: 0);
    }
  }
}
