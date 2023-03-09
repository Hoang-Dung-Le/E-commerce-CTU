import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:project_ctu/common/theme_helper.dart';
import 'package:project_ctu/products.dart';
import 'package:project_ctu/screens/home/components/login_check.dart';
import 'package:project_ctu/screens/home/components/test_1.dart';
import 'package:project_ctu/screens/home/home_screen.dart';
import 'package:project_ctu/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:project_ctu/User.dart';

import '../User.dart';
import 'forgot_password_page.dart';
import 'profile_page.dart';
import 'registration_page.dart';
import 'widgets/header_widget.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';

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

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LoginCheck(),
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
                                    onPressed: () {
                                      //After successful login we will redirect to profile page. Let's create profile page now
                                      // onClicked();

                                      // _futureUser = createUser(
                                      //     _userController.text,
                                      //     _passController.text);

                                      var result = (context)
                                          .read<LoginCheck>()
                                          .login(_userController.text,
                                              _passController.text);
                                      result.then((value) => {
                                            if (value == 1)
                                              {
                                                Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            goToHome(context)))
                                              }
                                          });

                                      // _futureUser.then((value) => {
                                      //       if (value.fac_id != 12)
                                      //         {
                                      //           // userModel
                                      //           // context
                                      //           //     .read<UserProvider>()
                                      //           //     .user = value,
                                      //           // }
                                      //           // print(Provider.of<UserProvider>(
                                      //           //         context)
                                      //           //     .user
                                      //           //     .toString()),
                                      //           Navigator.pushReplacement(
                                      //               context,
                                      //               MaterialPageRoute(
                                      //                   builder: (context) =>
                                      //                       goToHome(context)))
                                      //         }
                                      //     });
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
