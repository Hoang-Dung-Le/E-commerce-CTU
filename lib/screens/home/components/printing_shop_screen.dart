import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project_ctu/pages/login_page.dart';
import 'package:project_ctu/screens/home/doi_dia_chi.dart';
import 'package:project_ctu/screens/home/doi_sdt.dart';
import 'package:project_ctu/screens/home/doi_ten_shoop.dart';
import 'package:project_ctu/screens/home/doi_time__dong.dart';
import 'package:project_ctu/screens/home/doi_time_mo.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants.dart';
import '../doi_mat_khau.dart';
import '../message_screen.dart';

// class ProfilePageShop extends StatefulWidget {
//   @override
//   _ProfilePageState createState() => _ProfilePageState();
// }

// class _ProfilePageState extends State<ProfilePageShop> {
//   String imageUrl = '';
//   String name = '';
//   String address = '';
//   String email = '';
//   String phone = '';
//   String openTime = '';
//   String closeTime = '';
//   var isLoading = false;

//   Future getData() async {
//     final prefs = await SharedPreferences.getInstance();
//     var user_id = prefs.getString('user_id');
//     var response =
//         await http.post(Uri.parse('http://10.0.2.2:3000/api/v1/getInfoShop'),
//             headers: <String, String>{
//               'Content-Type': 'application/json; charset=UTF-8',
//             },
//             body: jsonEncode(<String, String>{"user_id": user_id.toString()}));
//     if (response.statusCode == 200) {
//       var data = json.decode(response.body)['check'];
//       setState(() {
//         imageUrl = ip + data[0]['url'];
//         name = data[0]['ten_cua_hang'];
//         address = data[0]['dia_chi'];
//         email = data[0]['email'];
//         phone = data[0]['sdt'];
//         openTime = data[0]['thoi_gian_mo'];
//         closeTime = data[0]['thoi_gian_dong'];
//       });
//     }
//   }

//   void loading() async {
//     setState(() {
//       isLoading = true;
//     });

//     var result = await getData();

//     setState(() {
//       isLoading = false;
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     loading();
//     // getData();
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (isLoading) {
//       return Center(
//         child: CircularProgressIndicator(
//           valueColor: new AlwaysStoppedAnimation<Color>(Color(0xff4f359b)),
//         ),
//       );
//     }
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Profile'),
//         automaticallyImplyLeading: false,
//         actions: [
//           IconButton(
//               onPressed: () async {
//                 SharedPreferences prefs = await SharedPreferences.getInstance();
//                 await prefs.clear();
//                 Navigator.pushReplacement(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => gotoLogin(context)));
//               },
//               icon: Icon(Icons.logout))
//         ],
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Image.network(imageUrl),
//             SizedBox(height: 20),
//             Text(name),
//             Text(address),
//             Text(email),
//             Text(phone),
//             Text('Open time: $openTime - Close time: $closeTime'),
//             ElevatedButton(
//                 onPressed: () => {
//                       Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) => doiMK(context)))
//                     },
//                 child: Text("đổi mật khẩu"))
//           ],
//         ),
//       ),
//       bottomNavigationBar: BottomAppBar(
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             IconButton(
//               icon: Icon(Icons.arrow_back),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//             IconButton(
//               icon: Icon(Icons.message),
//               onPressed: () {
//                 Navigator.of(context).push(
//                   MaterialPageRoute(
//                     builder: (context) => ChatListPage(),
//                   ),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget doiMK(BuildContext context) {
//     return ChangePasswordPage();
//   }

//   Widget gotoLogin(BuildContext context) {
//     return LoginPage();
//   }
// }

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
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.network(
                  imageUrl,
                  width: 150,
                  height: 150,
                ),
              ),
              SizedBox(height: 20),
              buildInfoRowName('Shop Name', name),
              buildInfoRowDiaChi('Address', address),
              buildInfoRow2('Email', email),
              buildInfoRowSDT('Phone', phone),
              buildInfoRowTimeMo('Open time', openTime),
              buildInfoRowTimeDong('Close time', closeTime),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => doiMK(context),
                    ),
                  ),
                },
                child: Text("Change Password"),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(Icons.home),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ProfilePageShop(),
                  ),
                );
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

  Widget buildInfoRow2(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey[300]!,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(value),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildInfoRowName(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey[300]!,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(value),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChangeShopNamePage(
                            ten_cua_hang: name,
                          )));
            },
            icon: Icon(Icons.edit),
          ),
        ],
      ),
    );
  }

  Widget buildInfoRowSDT(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey[300]!,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(value),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChangePhoneNumberPage(sdt: phone)));
            },
            icon: Icon(Icons.edit),
          ),
        ],
      ),
    );
  }

  Widget buildInfoRowDiaChi(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey[300]!,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(value),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChangeAddressPage(
                            dia_chi: address,
                          )));
            },
            icon: Icon(Icons.edit),
          ),
        ],
      ),
    );
  }

  Widget buildInfoRowTimeMo(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey[300]!,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(value),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChangeOpeningTimePage(
                            time_mo: openTime,
                          )));
            },
            icon: Icon(Icons.edit),
          ),
        ],
      ),
    );
  }

  Widget buildInfoRowTimeDong(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey[300]!,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(value),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChangeClosingTimePage(
                            time_mo: closeTime,
                          )));
            },
            icon: Icon(Icons.edit),
          ),
        ],
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
