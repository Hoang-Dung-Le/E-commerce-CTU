import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';

import 'package:project_ctu/products.dart';
import 'package:project_ctu/screens/home/components/recommend.dart';

import '../../../components/my_bottom_nav_bar.dart';
import '../../../constants.dart';
import '../../details/details_screen.dart';

class SearchDocument extends StatefulWidget {
  const SearchDocument({super.key, required this.searchName});

  final String searchName;
  @override
  State<SearchDocument> createState() => _SearchDocumentState(searchName);
}

class _SearchDocumentState extends State<SearchDocument> {
  _SearchDocumentState(this.searchName);
  final String searchName;
  List<Products> products = [];
  List<String> urlImages = [];
  TextEditingController _searchController = new TextEditingController();

  var isLoading = false;

  Future<int> getData(String searchName) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:3000/api/v1/searchProducts'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{"searchName": searchName}),
    );

    if (response.statusCode == 200) {
      final List<Products> result = [];
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      extractedData['result'].forEach((data) {
        result.add(Products(
            user_id: data['user_id'],
            price: data['price'],
            type: data['type'],
            img_id: data['img_id'],
            fac_id: data['fac_id'],
            name: data['name'],
            subject: data['subject'],
            author: data['author'],
            detail: data['detail'],
            hidden: data['hidden'],
            product_date: data['product_date']));
      });
      products = result;
      await fetchingImage();
      print("size url " + urlImages.length.toString());
      return 1;
    } else {
      return 0;
    }
  }

  Future<int> fetchingImage() async {
    List<String> temp_urls = [];
    for (var i = 0; i < products.length; i++) {
      print("loa dimg");
      print(products[i].img_id);
      if (products[i].img_id != null) {
        print("ohYeah");
        final response = await http.post(
          Uri.parse('http://10.0.2.2:3000/api/v1/getImageFromId'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(
              <String, String>{"img_id": products[i].img_id.toString()}),
        );
        if (response.statusCode == 200) {
          final extractedData =
              json.decode(response.body) as Map<String, dynamic>;
          temp_urls.add(ip + extractedData['url']);
          print(ip + extractedData['url']);
          // print("size thoi diem hien tai " + temp_urls.length.toString());
        }
      } else {
        temp_urls.add(ip + "no_img");
        // print("size thoi diem hien tai " + temp_urls.length.toString());
      }
    }
    urlImages = temp_urls;
    return 1;
  }

  void fetchData() async {
    setState(() {
      isLoading = true;
    });
    await getData(searchName);
    // await fetchingImag();
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.fetchData();
  }

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
    return Scaffold(
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(bottom: kDefaultPadding * 2.5),
            // It will cover 20% of our total height
            height: size.height * 0.2,
            child: Stack(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(
                    left: kDefaultPadding,
                    right: kDefaultPadding,
                    bottom: 36 + kDefaultPadding,
                  ),
                  height: size.height * 0.2 - 27,
                  decoration: BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(36),
                      bottomRight: Radius.circular(36),
                    ),
                  ),
                  child: Row(
                    children: <Widget>[
                      Text(
                        'Hi Uishopy!',
                        style: Theme.of(context).textTheme.headline5?.copyWith(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      Spacer(),
                      Image.asset("assets/images/logo.png")
                    ],
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.symmetric(horizontal: kDefaultPadding),
                    padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
                    height: 54,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0, 10),
                          blurRadius: 50,
                          color: kPrimaryColor.withOpacity(0.23),
                        ),
                      ],
                    ),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            onChanged: (value) {},
                            decoration: InputDecoration(
                              hintText: "Search",

                              hintStyle: TextStyle(
                                color: kPrimaryColor.withOpacity(0.5),
                              ),
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              // surffix isn't working properly  with SVG
                              // thats why we use row
                              // suffixIcon: SvgPicture.asset("assets/icons/search.svg"),
                            ),
                          ),
                        ),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SearchDocument(
                                            searchName: _searchController.text
                                                .toString(),
                                          )));
                            },
                            child: SvgPicture.asset("assets/icons/search.svg")),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text("Search for: " + searchName),
          ),
          Flexible(
            child: GridView.builder(
                itemCount: products.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 30),
                itemBuilder: (context, index) {
                  return RecomendPlantCard(
                    image: urlImages[index],
                    title: products[index].name.toString(),
                    country: "Russia",
                    price: 440,
                    press: () {
                      // print("gia tri product" + products.length.toString());
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailsScreen(),
                        ),
                      );
                    },
                  );
                }),
          ),
        ],
      ),
      bottomNavigationBar: MyBottomNavBar(),
    );
  }
}
