import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';

import 'package:project_ctu/products.dart';
import 'package:project_ctu/screens/details/components/detail_product.dart';
import 'package:project_ctu/screens/home/components/recommend.dart';

import '../../../components/my_bottom_nav_bar.dart';
import '../../../constants.dart';
import '../../details/details_screen.dart';

class FilterDialog extends StatefulWidget {
  final List<String> authors;
  final List<String> subjects;
  final String searchName;
  FilterDialog(
      {required this.authors,
      required this.subjects,
      required this.searchName});
  // @override
  @override
  _FilterDialogState createState() => _FilterDialogState(
      authors: authors, subjects: subjects, searchName: searchName);
}

class _FilterDialogState extends State<FilterDialog> {
  bool _isChecked = false;
  final List<String> authors;
  String author_value = '';
  String selection_value = '';

  String sort_lection = '';
  List<String> subjects;
  List<String> sort_selections = [
    '',
    'A-Z',
    'Z-A',
    'Giá tăng dần',
    'Giá giảm dần'
  ];
  List<String> fac_list = ["", "CNTT", "Bách Khoa", "Kinh tế", "Nông nghiệp"];
  final String searchName;
  String subject_value = '';
  String fac_value = '';
  String fac_id = '0';

  _FilterDialogState(
      {required this.authors,
      required this.subjects,
      required this.searchName});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Filter'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Tác giả'),
          DropdownButton(
              value: author_value,
              items: authors.map((item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  author_value = value!;
                });
              }),
          Text('Môn học'),
          DropdownButton(
              value: subject_value,
              items: subjects.map((item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  subject_value = value!;
                });
              }),
          Text('Sắp xếp'),
          DropdownButton(
              value: selection_value,
              items: sort_selections.map((item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: ((value) {
                if (value == sort_selections[0]) {
                  setState(() {
                    selection_value = value!;
                    sort_lection = '';
                  });
                } else if (value == sort_selections[1]) {
                  setState(() {
                    selection_value = value!;
                    sort_lection = '1';
                  });
                } else if (value == sort_selections[2]) {
                  setState(() {
                    selection_value = value!;
                    sort_lection = '2';
                  });
                } else if (value == sort_selections[3]) {
                  setState(() {
                    selection_value = value!;
                    sort_lection = '3';
                  });
                } else if (value == sort_selections[4]) {
                  setState(() {
                    selection_value = value!;
                    sort_lection = '4';
                  });
                }
              })),
          Text('Trường'),
          DropdownButton(
              value: fac_value,
              items: fac_list.map((item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: (value) {
                if (value == fac_list[0]) {
                  setState(() {
                    fac_value = value!;
                    fac_id = '0';
                  });
                } else if (value == fac_list[1]) {
                  setState(() {
                    fac_value = value!;
                    fac_id = '1';
                  });
                } else if (value == fac_list[2]) {
                  setState(() {
                    fac_value = value!;
                    fac_id = '2';
                  });
                } else if (value == fac_list[3]) {
                  setState(() {
                    fac_value = value!;
                    fac_id = '3';
                  });
                } else if (value == fac_list[4]) {
                  setState(() {
                    fac_value = value!;
                    fac_id = '4';
                  });
                }
              }),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            print('auhor:' + author_value);
            print('subject: ' + subject_value);
            // Perform filtering
            Navigator.pop(context);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SearchDocument(
                          searchName: searchName.toString(),
                          sort_selection: sort_lection.toString(),
                          author: author_value.toString(),
                          subject: subject_value.toString(),
                          fac_id: fac_id,
                        )));
          },
          child: Text('Apply'),
        ),
      ],
    );
  }
}

class SearchDocument extends StatefulWidget {
  const SearchDocument(
      {super.key,
      required this.searchName,
      required this.sort_selection,
      required this.author,
      required this.subject,
      required this.fac_id});

  final String searchName;
  final String sort_selection;
  final String author;
  final String subject;
  final String fac_id;
  @override
  State<SearchDocument> createState() =>
      _SearchDocumentState(searchName, sort_selection, author, subject, fac_id);
}

class _SearchDocumentState extends State<SearchDocument> {
  _SearchDocumentState(this.searchName, this.sort_selection, this.subject,
      this.author, this.fac_id);
  final String searchName;
  final String author;

  final String sort_selection;
  final String subject;
  List<Products> products = [];
  List<String> urlImages = [];
  TextEditingController _searchController = new TextEditingController();
  List<String> authors = [''];
  List<String> subjects = [''];
  final String fac_id;

  var isLoading = false;

  Future<int> getData(String searchName, String sort_selection, String author,
      String subject, String fac_id) async {
    print('auhor:' + author);
    print('subject: ' + subject);
    final response = await http.post(
      Uri.parse('http://10.0.2.2:3000/api/v1/searchProducts'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "searchName": searchName,
        "sort_selection": sort_selection,
        "author": author,
        "subject": subject,
        "fac_id": fac_id
      }),
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
      var tacgia = jsonDecode(response.body)['authors'];
      for (int i = 0; i < tacgia.length; i++) {
        authors.add(tacgia[i]['author']);
      }
      var monhocs = jsonDecode(response.body)['subjects'];
      for (int i = 0; i < monhocs.length; i++) {
        subjects.add(monhocs[i]['subject']);
      }
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
    await getData(searchName, sort_selection, subject, author, fac_id);
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
                      padding:
                          EdgeInsets.symmetric(horizontal: kDefaultPadding),
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
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Nhập từ khóa',
                          prefixIcon: IconButton(
                            icon: Icon(Icons.search),
                            onPressed: () {
                              // Hành động khi nút tìm kiếm được nhấn
                              // print('Tìm kiếm: ' + searchController.text);
                            },
                          ),
                        ),
                        controller: _searchController,
                        onSubmitted: (value) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SearchDocument(
                                        searchName:
                                            _searchController.text.toString(),
                                        author: '',
                                        sort_selection: '',
                                        subject: '',
                                        fac_id: '0',
                                      )));
                        },
                      )),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10, right: 50),
            child: Row(
              children: [
                Text(
                  "Search for: " + searchName,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                IconButton(
                    onPressed: (() {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return FilterDialog(
                            searchName: searchName,
                            authors: authors,
                            subjects: subjects,
                          );
                        },
                      );
                    }),
                    icon: SvgPicture.asset("assets/icons/filter.svg"))
              ],
            ),
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
                    price: products[index].price!.toInt(),
                    press: () {
                      // print("gia tri product" + products.length.toString());
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Detail(
                            product: products[index],
                            url: urlImages[index],
                          ),
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
