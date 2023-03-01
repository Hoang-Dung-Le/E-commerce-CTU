import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:project_ctu/components/my_bottom_nav_bar.dart';
import 'package:project_ctu/pages/login_page.dart';
import 'package:project_ctu/screens/home/components/body.dart';

// class HomeScreen extends StatefulWidget {
//   @override
// Widget build(BuildContext context) {
//   return Scaffold(
//     // appBar: AppBar(
//     //   leading: IconButton(
//     //     onPressed: () {
//     //       Navigator.push(
//     //         context,
//     //         MaterialPageRoute(builder: (context) => LoginPage()),
//     //       );
//     //     },
//     //     icon: Icon(Icons.arrow_back_ios),
//     //   ),
//     // ),
//     body: Body(),
//     bottomNavigationBar: MyBottomNavBar(),
//   );
// }

//   @override
//   State<StatefulWidget> createState() {
//     throw UnimplementedError();
//   }
// }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var hhee = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   leading: IconButton(
      //     onPressed: () {
      //       Navigator.push(
      //         context,
      //         MaterialPageRoute(builder: (context) => LoginPage()),
      //       );
      //     },
      //     icon: Icon(Icons.arrow_back_ios),
      //   ),
      // ),
      body: Body(),
      bottomNavigationBar: MyBottomNavBar(),
    );
  }
}
