import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project_ctu/components/my_bottom_nav_bar.dart';
import 'package:project_ctu/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../home/my_product_detail_display.dart';

class Product {
  final String product_id;
  final String name;
  final int price;
  final String subject;
  final String detail;
  final String img_id;
  final int hidden;

  Product(
      {required this.product_id,
      required this.name,
      required this.price,
      required this.subject,
      required this.detail,
      required this.img_id,
      required this.hidden});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
        product_id: json['product_id'].toString(),
        name: json['name'],
        price: json['price'],
        subject: json['subject'],
        detail: json['detail'],
        img_id: json['img_id'].toString(),
        hidden: json['hidden']);
  }
}

class ProductGrid extends StatelessWidget {
  var products_url = [];

  Future<bool> hiddenProduct(String product_id) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:3000/api/v1/hiddenProduct'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'product_id': product_id,
      }),
    );

    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      return true;
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw false;
    }
  }

  Future<bool> unHiddenProduct(String product_id) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:3000/api/v1/unHiddenProduct'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'product_id': product_id,
      }),
    );

    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      return true;
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw false;
    }
  }

  Future<List<Product>> _fetchProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final response = await http.post(
      Uri.parse('http://10.0.2.2:3000/api/v1/getMyProducts'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'user_id': prefs.getString('user_id').toString(),
      }),
    );
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body)['data'];
      List<Product> products = [];
      for (var i = 0; i < jsonData.length; i++) {
        final imgResponse = await http.post(
          Uri.parse('http://10.0.2.2:3000/api/v1/getImageFromId'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'img_id': jsonData[i]['img_id'].toString(),
          }),
        );
        final url = jsonDecode(imgResponse.body)['url'];
        final product = Product.fromJson(jsonData[i]);
        products_url.add(url);
        products.add(product);
      }
      return products;
    } else {
      throw Exception('Failed to load products');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: MyBottomNavBar(),
      body: FutureBuilder<List<Product>>(
        future: _fetchProducts(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return GridView.count(
              crossAxisCount: 2,
              children: List.generate(snapshot.data!.length, (index) {
                return Column(
                  children: [
                    InkWell(
                      onTap: (() {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProductManagementPage(
                                      product: snapshot.data![index],
                                    )));
                      }),
                      child: Column(children: [
                        Image.network(
                          ip + products_url[index],
                          fit: BoxFit.cover,
                          width: 90,
                          height: 130,
                        ),
                        Text(
                          snapshot.data![index].name.toString(),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ]),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Row(
                        children: [
                          Text(snapshot.data![index].price.toString()),
                          ElevatedButton.icon(
                              icon: Icon(Icons.check),
                              label: Text(''),
                              onPressed: () {
                                if (snapshot.data![index].hidden == 0) {
                                  var result = hiddenProduct(snapshot
                                      .data![index].product_id
                                      .toString());
                                  result.then((value) => {
                                        if (value == true)
                                          {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        gotoMyProduct(context)))
                                          }
                                      });
                                } else {
                                  var result = unHiddenProduct(snapshot
                                      .data![index].product_id
                                      .toString());
                                  result.then((value) => {
                                        if (value == true)
                                          {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        gotoMyProduct(context)))
                                          }
                                      });
                                }
                              },
                              style: ButtonStyle(
                                minimumSize: MaterialStateProperty.all<Size>(
                                    Size(10, 10)),
                                maximumSize: MaterialStateProperty.all<Size>(
                                    Size(25, 35)),
                                backgroundColor:
                                    MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> states) {
                                    if (snapshot.data![index].hidden == 1) {
                                      return Colors
                                          .grey; // Nếu flag = true, trả về màu đỏ
                                    } else {
                                      return Colors
                                          .blue; // Nếu flag = false, trả về màu xanh
                                    }
                                  },
                                ),
                              ))
                        ],
                      ),
                    )
                  ],
                );
              }),
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget gotoMyProduct(BuildContext context) {
    return ProductGrid();
  }
}
