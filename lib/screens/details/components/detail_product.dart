import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:project_ctu/products.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../components/my_bottom_nav_bar.dart';
import '../../home/components/chat.dart';
import '../../home/components/login_check.dart';
import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

class Detail extends StatefulWidget {
  const Detail({Key? key, required this.product, required this.url})
      : super(key: key);

  @override
  _DetailState createState() => _DetailState(product, url);

  final Products product;
  final String url;
}

class _DetailState extends State<Detail> {
  _DetailState(this.product, this.url);

  final Products product;
  final String url;
  late bool isFavorite;
  var isLoading = false;

  String convertTime(String x) {
    DateTime y = DateTime.parse(x);
    final DateFormat formatter = DateFormat('dd.MM.yyyy, HH:mm');
    final String formatted = formatter.format(y);
    return formatted; // 12.05.2022, 15:55
  }

  Future<void> initFav() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var user_id = pref.getString("user_id");
    final response = await http.post(
      Uri.parse('http://10.0.2.2:3000/api/v1/ktYeuThich'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "user_id": user_id.toString(),
        "name": product.name.toString(),
        "author": product.author.toString(),
        "subject": product.subject.toString()
        // "product_date": product.product_date.toString()
      }),
    );

    if (response.statusCode == 200) {
      var check = jsonDecode(response.body)['check'];
      if (check == "0") {
        isFavorite = false;
      } else {
        isFavorite = true;
      }
    }
  }

  Future<void> changeState() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var user_id = pref.getString("user_id");
    final response = await http.post(
      Uri.parse('http://10.0.2.2:3000/api/v1/themIuThich'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "user_id": user_id.toString(),
        "name": product.name.toString(),
        "author": product.author.toString(),
        "subject": product.subject.toString()
      }),
    );

    if (response.statusCode == 200) {
      setState(() {
        isFavorite = !isFavorite;
      });
    }
  }

  void loadData() async {
    setState(() {
      isLoading = true;
    });

    var result = await initFav();

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  // void toggleFavorite() {
  //   setState(() {
  //     isFavorite = !isFavorite;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: new AlwaysStoppedAnimation<Color>(Color(0xff4f359b)),
        ),
      );
    }
    return ChangeNotifierProvider(
      create: (context) => LoginCheck(),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: size.height * 0.4,
              color: Color.fromRGBO(208, 201, 201, 0.762),
              child: Stack(
                children: [
                  GestureDetector(
                    child: Image.network(url),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) {
                        return DetailScreen(url: url);
                      }));
                    },
                  ),
                  Positioned(
                    top: 16.0,
                    right: 16.0,
                    child: IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: Colors.red,
                      ),
                      onPressed: changeState,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                product.name.toString(),
                style: TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Môn học: ${product.subject.toString()}",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Tác giả: ${product.author.toString()}",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Chi tiết: ${product.detail.toString()}",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Thời gian đăng: ${convertTime(product.product_date.toString())}",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
            Spacer(),
            Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(
                            userId: prefs.getString('user_id').toString(),
                            recipientId: product.user_id.toString(),
                            serverUrl: 'http://10.0.2.2:3000',
                          ),
                        ),
                      );
                    },
                    child: Text("Nhắn tin với người bán"),
                    style: ElevatedButton.styleFrom(
                      side: BorderSide(width: 3.0),
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  const DetailScreen({Key? key, required this.url}) : super(key: key);

  final String url;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Center(
          child: Hero(
            tag: 'imageHero',
            child: Image.network(url),
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
