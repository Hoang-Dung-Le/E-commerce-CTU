import 'dart:io';

import 'package:flutter/material.dart';
import 'package:project_ctu/User.dart';
import 'package:project_ctu/constants.dart';
import 'package:project_ctu/pages/login_page.dart';
import 'package:project_ctu/question_provider.dart';
import 'package:project_ctu/screens/home/components/chat.dart';
import 'package:project_ctu/screens/home/components/login_check.dart';
import 'package:project_ctu/screens/home/home_screen.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  // HttpOverrides.global = MyHttpOverrides();
  // connectAndListen();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LoginCheck()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Plant App',
        theme: ThemeData(
          scaffoldBackgroundColor: kBackgroundColor,
          primaryColor: kPrimaryColor,
          textTheme: Theme.of(context).textTheme.apply(bodyColor: kTextColor),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: FutureBuilder<bool>(
          future: isLoggedIn(),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data == true) {
              return HomeScreen();
            } else {
              return LoginPage();
            }
          },
        ),
      ),
    );
  }
}

Future<bool> isLoggedIn() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('isLoggedIn') ?? false;
}
