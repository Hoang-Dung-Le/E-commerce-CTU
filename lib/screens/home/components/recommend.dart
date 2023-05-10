import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:project_ctu/img.dart';
import 'package:project_ctu/screens/details/components/detail_product.dart';
import 'package:project_ctu/screens/details/details_screen.dart';

import '../../../constants.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../products.dart';

class RecomendsPlants extends StatefulWidget {
  const RecomendsPlants({super.key, required this.fac_id});

  @override
  State<RecomendsPlants> createState() => _RecomendsPlantsState(fac_id);
  final String fac_id;
}

class _RecomendsPlantsState extends State<RecomendsPlants> {
  List<Products> products = [];
  List<ImageFromApi> urlImgs = [];
  late Future<ImageFromApi> urlImg;
  bool isLoading = false;
  final String fac_id;

  _RecomendsPlantsState(this.fac_id);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // this.fetchProduct;
    // this.getProducts();
    this.fetchProducts();
  }

  void fetchProducts() async {
    setState(() {
      isLoading = true;
    });
    Future<List<Products>> _futureProducts = getProducts(fac_id);
    List<Products> products_temp = [];
    List<ImageFromApi> urlImgs_temp = [];
    var urlImg;
    await _futureProducts.then((value) async => {
          for (int i = 0; i < value.length; i++)
            {
              products_temp.add(value[i]),
              urlImg = getUrlImgs(value[i].img_id.toString()),
              await urlImg.then((value3) => {
                    if (value3.type != 10)
                      {urlImgs_temp.add(value3), print(value3.url)}
                  })
            }
        });
    setState(() {
      products.addAll(products_temp);
      urlImgs.addAll(urlImgs_temp);
      isLoading = false;
    });
    // print(urlImgs.length);
  }

  Future<List<Products>> getProducts(String fac_id) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:3000/api/v1/getRecommendedProducts'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{"fac_id": fac_id}),
    );

    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);
      var data = result['data'];
      // print(data.length);
      List<Products> products = [];
      // print(data[0]);

      // print(fakedata);
      for (var i = 0; i < data.length; i++) {
        int product_id = data[i]['product_id'];
        int user_id = data[i]['user_id'];
        int price = data[i]['price'];
        int type = data[i]['type'];
        int img_id = data[i]['img_id'];
        int fac_id = data[i]['fac_id'];
        String name = data[i]['name'].toString();
        String subject = data[i]['subject'];
        String author = data[i]['author'];
        String detail = data[i]['detail'];
        int hidden = data[i]['hidden'];
        String product_date = data[i]['product_date'];
        String fakedata =
            '{"product_id":$product_id,"user_id":$user_id,"price":$price, "type":$type,"img_id":$img_id,"fac_id":$fac_id,"name":"$name","subject":"$subject","author":"$author","detail":"$detail","hidden":$hidden,"product_date":"$product_date"}';
        products.add(Products.fromJson(jsonDecode(fakedata)));
      }
      print("gia tri tai constructor: " + products.length.toString());
      return products;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  Future<ImageFromApi> getUrlImgs(String img_id) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:3000/api/v1/getImageFromId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'img_id': img_id}),
    );

    if (response.statusCode == 200) {
      print(jsonDecode(response.body));
      return ImageFromApi.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      // throw Exception('Failed to load img');
      return ImageFromApi(img_id: 0, type: 10, url: '');
    }
  }

  // void fetchProduct() async {
  //   var reponse = await getProducts();
  // }

  @override
  Widget build(BuildContext context) {
    // Future<List<Products>> _futureProducts = getProducts();
    // print(_futureProducts.toString());
    var url_test = "http://192.168.1.17:3000/images/gtcpp.png";
    // D:\Code\School\NodejsTutorial\src\public\images\
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: new AlwaysStoppedAnimation<Color>(Color(0xff4f359b)),
        ),
      );
    } else {
      if (urlImgs.length > 0) {
        url_test = urlImgs[0].url;
      }
      print(url_test.toString() + "test ne");
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: <Widget>[
          RecomendPlantCard(
            image: ip + urlImgs[0].url,
            title: "Samantha",
            country: "Russia",
            price: 440,
            press: () {
              // print("gia tri product" + products.length.toString());
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Detail(
                    product: products[0],
                    url: ip + urlImgs[0].url,
                  ),
                ),
              );
            },
          ),
          RecomendPlantCard(
            image: ip + urlImgs[1].url,
            title: "Angelica",
            country: "Russia",
            price: 440,
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Detail(
                    product: products[1],
                    url: url_test,
                  ),
                ),
              );
            },
          ),
          RecomendPlantCard(
            image: ip + urlImgs[2].url,
            title: "Samantha",
            country: "Russia",
            price: 440,
            press: () {},
          ),
        ],
      ),
    );
  }
}

class RecomendPlantCard extends StatelessWidget {
  const RecomendPlantCard({
    required this.image,
    required this.title,
    required this.country,
    required this.price,
    required this.press,
  }) : super();

  final String image;
  final String title, country;
  final int price;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      // margin: EdgeInsets.only(
      //   left: kDefaultPadding,
      //   top: kDefaultPadding / 2,
      //   bottom: kDefaultPadding * 2.5,
      // ),
      width: size.width * 0.4,
      child: Column(
        children: <Widget>[
          Container(height: 130, child: Image.network(image)),
          GestureDetector(
            onTap: press,
            child: Container(
              padding: EdgeInsets.all(kDefaultPadding / 3),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 10),
                    blurRadius: 50,
                    color: kPrimaryColor.withOpacity(0.23),
                  ),
                ],
              ),
              child: Column(
                children: <Widget>[
                  RichText(
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "$title",
                          style: Theme.of(context).textTheme.button,
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '$price\K',
                    style: Theme.of(context)
                        .textTheme
                        .button
                        ?.copyWith(color: kPrimaryColor),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
