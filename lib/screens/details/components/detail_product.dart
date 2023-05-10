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

class Detail extends StatefulWidget {
  const Detail({super.key, required this.product, required this.url});

  @override
  State<Detail> createState() => _DetailState(this.product, this.url);

  final Products product;
  final String url;
}

class _DetailState extends State<Detail> {
  _DetailState(this.product, this.url);
  final Products product;
  final String url;

  String convertTime(String x) {
    DateTime y = DateTime.parse(x);
    final DateFormat formatter = DateFormat('dd.MM.yyyy, HH:mm');
    final String formatted = formatter.format(y);
    return formatted; // 12.05.2022, 15:55
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ChangeNotifierProvider(
      create: (context) => LoginCheck(),
      child: Scaffold(
        appBar: AppBar(leading: Icon(Icons.arrow_back)),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Container(
                height: size.height * 0.4,
                color: Color.fromRGBO(208, 201, 201, 0.762),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      child: Image.network(url),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) {
                          return DetailScreen(
                            url: url,
                          );
                        }));
                      },
                    ),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    product.name.toString(),
                    style: TextStyle(
                        color: Colors.blueGrey,
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            // Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                RichText(
                    text: TextSpan(
                        text: "Môn học: ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black),
                        children: [TextSpan(text: product.subject.toString())]))
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                RichText(
                    text: TextSpan(
                        text: "Tác giả: ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black),
                        children: [TextSpan(text: product.author.toString())]))
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                RichText(
                    text: TextSpan(
                        text: "Chi tiết: ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black),
                        children: [TextSpan(text: product.detail.toString())]))
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                RichText(
                    text: TextSpan(
                        text: "Thời gian đăng: ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black),
                        children: [
                      TextSpan(
                          text: convertTime(product.product_date.toString()))
                    ]))
              ],
            )
            // Text("jha")
          ],
        ),
        bottomNavigationBar: ElevatedButton(
          onPressed: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ChatScreen(
                      userId: prefs.getString('user_id').toString(),
                      recipientId: product.user_id.toString(),
                      serverUrl: 'http://10.0.2.2:3000')),
            );
          },
          child: Text("Nhắn tin với người bán"),
          style: ElevatedButton.styleFrom(side: BorderSide(width: 3.0)),
        ),
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key, required this.url});
  final String url;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Center(
          child: Hero(
            tag: 'imageHero',
            child: Image.network(
              url,
            ),
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}