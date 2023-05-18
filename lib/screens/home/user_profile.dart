import 'package:flutter/material.dart';
import 'package:project_ctu/pages/login_page.dart';
import 'package:project_ctu/screens/details/components/myproducts.dart';
import 'package:project_ctu/screens/home/components/list_shop.dart';
import 'package:project_ctu/screens/home/doi_mat_khau.dart';
import 'package:project_ctu/screens/home/ds_yeu_thich.dart';
import 'package:project_ctu/screens/home/i4.dart';
import 'package:project_ctu/screens/home/message_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'components/mess_user.dart';
import 'mess_shop.dart';

// class ProfileUserPage extends StatefulWidget {
//   @override
//   State<ProfileUserPage> createState() => _ProfileUserPageState();
// }

// class _ProfileUserPageState extends State<ProfileUserPage> {
//   var isLoading = false;
//   late InFoUser i4;

//   var list_fac = [
//     'Trường công nghệ thông tin và truyền thông',
//     'Trường bách khoa',
//     'Trường kinh tế',
//     'Trường Nông nghiệp'
//   ];

//   Future<InFoUser> createInfo() async {
//     final prefs = await SharedPreferences.getInstance();
//     final response = await http.post(
//       Uri.parse('http://10.0.2.2:3000/api/v1/getInfoUser'),
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//       },
//       body: jsonEncode(<String, String>{
//         'user_id': prefs.getString('user_id').toString(),
//       }),
//     );
//     return InFoUser.fromJson(jsonDecode(response.body));
//   }

//   void loading() async {
//     setState(() {
//       isLoading = true;
//     });

//     var result = await createInfo();

//     setState(() {
//       i4 = result;
//       isLoading = false;
//     });
//   }

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     loading();
//   }

//   // initState() async {
//   //   super.initState();
//   //   loading();
//   // }

//   @override
//   Widget build(BuildContext context) {
//     if (isLoading) {
//       return Center(
//         child: CircularProgressIndicator(
//           valueColor: new AlwaysStoppedAnimation<Color>(Color(0xff4f359b)),
//         ),
//       );
//     }

//     Widget gotoLogin(BuildContext context) {
//       return LoginPage();
//     }

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Profile'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.logout),
//             onPressed: () async {
//               // Xóa thông tin đăng nhập và chuyển về trang đăng nhập
//               SharedPreferences prefs = await SharedPreferences.getInstance();
//               await prefs.clear();
//               Navigator.pushReplacement(context,
//                   MaterialPageRoute(builder: (context) => gotoLogin(context)));
//             },
//           ),
//         ],
//       ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Text(
//               'Personal Information',
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//           ListTile(
//             leading: Icon(Icons.person),
//             title: Text('Tên đăng nhập của bạn'),
//             subtitle: Text(i4.tendang_nhap),
//           ),
//           ListTile(
//             leading: Icon(Icons.email),
//             title: Text('Email'),
//             subtitle: Text(i4.email),
//           ),
//           ListTile(
//             leading: Icon(Icons.school),
//             title: Text('Faculty'),
//             subtitle: Text(list_fac[i4.fac_id - 1]),
//           ),
//           ElevatedButton(
//               onPressed: () => {
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => gotoMyProduct(context)))
//                   },
//               child: Text("các sản phẩm bạn đã đăng")),
//           ElevatedButton(
//               onPressed: () => {
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => gotoShop(context)))
//                   },
//               child: Text("Shop in ấn")),
//           ElevatedButton(
//               onPressed: () => {
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => gotoChatPage(context)))
//                   },
//               child: Text("Lịch sử trò chuyện")),
//           ElevatedButton(
//               onPressed: () => {
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => gotoChatShop(context)))
//                   },
//               child: Text("Tin nhắn với shop")),
//           ElevatedButton(
//               onPressed: () => {
//                     Navigator.push(context,
//                         MaterialPageRoute(builder: (context) => doiMK(context)))
//                   },
//               child: Text("đổi mật khẩu"))
//         ],
//       ),
//     );
//   }

//   Widget gotoMyProduct(BuildContext context) {
//     return ProductGrid();
//   }

//   Widget doiMK(BuildContext context) {
//     return ChangePasswordPage();
//   }

//   Widget gotoShop(BuildContext context) {
//     return ListShop();
//   }

//   Widget gotoChatPage(BuildContext context) {
//     return ChatListUser();
//   }

//   Widget gotoChatShop(BuildContext context) {
//     return ChatListShop();
//   }
// }

class ProfileUserPage extends StatefulWidget {
  @override
  State<ProfileUserPage> createState() => _ProfileUserPageState();
}

class _ProfileUserPageState extends State<ProfileUserPage> {
  var isLoading = false;
  late InFoUser userInfo;

  var faculties = [
    'Trường công nghệ thông tin và truyền thông',
    'Trường bách khoa',
    'Trường kinh tế',
    'Trường Nông nghiệp'
  ];

  Future<InFoUser> fetchUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final response = await http.post(
      Uri.parse('http://10.0.2.2:3000/api/v1/getInfoUser'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'user_id': prefs.getString('user_id').toString(),
      }),
    );
    return InFoUser.fromJson(jsonDecode(response.body));
  }

  void loadData() async {
    setState(() {
      isLoading = true;
    });

    var result = await fetchUserInfo();

    setState(() {
      userInfo = result;
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    loadData();
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

    Widget goToLogin(BuildContext context) {
      return LoginPage();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.clear();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => goToLogin(context)));
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Personal Information',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Tên đăng nhập của bạn'),
              subtitle: Text(userInfo.tendang_nhap),
            ),
            ListTile(
              leading: Icon(Icons.email),
              title: Text('Email'),
              subtitle: Text(userInfo.email),
            ),
            ListTile(
              leading: Icon(Icons.school),
              title: Text('Faculty'),
              subtitle: Text(faculties[userInfo.fac_id - 1]),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProductGrid()),
                );
              },
              child: Text("Các sản phẩm bạn đã đăng"),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DSYeuThich()),
                );
              },
              child: Text("Các sản phẩm yêu thích"),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ListShop()),
                );
              },
              child: Text("Shop in ấn"),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChatListUser()),
                );
              },
              child: Text("Lịch sử trò chuyện"),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ChatListShop()));
              },
              child: Text("Tin nhắn với shop"),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChangePasswordPage()),
                );
              },
              child: Text("Đổi mật khẩu"),
            ),
          ],
        ),
      ),
    );
  }
}
