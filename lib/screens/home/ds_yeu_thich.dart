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
import 'package:shared_preferences/shared_preferences.dart';

import '../../../components/my_bottom_nav_bar.dart';
import '../../../constants.dart';
import '../details/details_screen.dart';

// class FilterDialog extends StatefulWidget {
//   final List<String> authors;
//   final List<String> subjects;
//   final String searchName;
//   FilterDialog(
//       {required this.authors,
//       required this.subjects,
//       required this.searchName});
//   // @override
//   @override
//   _FilterDialogState createState() => _FilterDialogState(
//       authors: authors, subjects: subjects, searchName: searchName);
// }

// class _FilterDialogState extends State<FilterDialog> {
//   bool _isChecked = false;
//   final List<String> authors;
//   String author_value = '';
//   String selection_value = '';

//   String sort_lection = '';
//   List<String> subjects;
//   List<String> sort_selections = [
//     '',
//     'A-Z',
//     'Z-A',
//     'Giá tăng dần',
//     'Giá giảm dần'
//   ];
//   List<String> fac_list = ["", "CNTT", "Bách Khoa", "Kinh tế", "Nông nghiệp"];
//   final String searchName;
//   String subject_value = '';
//   String fac_value = '';
//   String fac_id = '0';

//   _FilterDialogState(
//       {required this.authors,
//       required this.subjects,
//       required this.searchName});

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: Text('Filter'),
//       content: Column(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text('Tác giả'),
//           DropdownButton(
//               value: author_value,
//               items: authors.map((item) {
//                 return DropdownMenuItem<String>(
//                   value: item,
//                   child: Text(item),
//                 );
//               }).toList(),
//               onChanged: (value) {
//                 setState(() {
//                   author_value = value!;
//                 });
//               }),
//           Text('Môn học'),
//           DropdownButton(
//               value: subject_value,
//               items: subjects.map((item) {
//                 return DropdownMenuItem<String>(
//                   value: item,
//                   child: Text(item),
//                 );
//               }).toList(),
//               onChanged: (value) {
//                 setState(() {
//                   subject_value = value!;
//                 });
//               }),
//           Text('Sắp xếp'),
//           DropdownButton(
//               value: selection_value,
//               items: sort_selections.map((item) {
//                 return DropdownMenuItem<String>(
//                   value: item,
//                   child: Text(item),
//                 );
//               }).toList(),
//               onChanged: ((value) {
//                 if (value == sort_selections[0]) {
//                   setState(() {
//                     selection_value = value!;
//                     sort_lection = '';
//                   });
//                 } else if (value == sort_selections[1]) {
//                   setState(() {
//                     selection_value = value!;
//                     sort_lection = '1';
//                   });
//                 } else if (value == sort_selections[2]) {
//                   setState(() {
//                     selection_value = value!;
//                     sort_lection = '2';
//                   });
//                 } else if (value == sort_selections[3]) {
//                   setState(() {
//                     selection_value = value!;
//                     sort_lection = '3';
//                   });
//                 } else if (value == sort_selections[4]) {
//                   setState(() {
//                     selection_value = value!;
//                     sort_lection = '4';
//                   });
//                 }
//               })),
//           Text('Trường'),
//           DropdownButton(
//               value: fac_value,
//               items: fac_list.map((item) {
//                 return DropdownMenuItem<String>(
//                   value: item,
//                   child: Text(item),
//                 );
//               }).toList(),
//               onChanged: (value) {
//                 if (value == fac_list[0]) {
//                   setState(() {
//                     fac_value = value!;
//                     fac_id = '0';
//                   });
//                 } else if (value == fac_list[1]) {
//                   setState(() {
//                     fac_value = value!;
//                     fac_id = '1';
//                   });
//                 } else if (value == fac_list[2]) {
//                   setState(() {
//                     fac_value = value!;
//                     fac_id = '2';
//                   });
//                 } else if (value == fac_list[3]) {
//                   setState(() {
//                     fac_value = value!;
//                     fac_id = '3';
//                   });
//                 } else if (value == fac_list[4]) {
//                   setState(() {
//                     fac_value = value!;
//                     fac_id = '4';
//                   });
//                 }
//               }),
//         ],
//       ),
//       actions: [
//         ElevatedButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           child: Text('Cancel'),
//         ),
//         ElevatedButton(
//           onPressed: () {
//             print('auhor:' + author_value);
//             print('subject: ' + subject_value);
//             // Perform filtering
//             Navigator.pop(context);
//             Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                     builder: (context) => DSYeuThich(
//                           searchName: searchName.toString(),
//                           sort_selection: sort_lection.toString(),
//                           author: author_value.toString(),
//                           subject: subject_value.toString(),
//                           fac_id: fac_id,
//                         )));
//           },
//           child: Text('Apply'),
//         ),
//       ],
//     );
//   }
// }

class DSYeuThich extends StatefulWidget {
  @override
  State<DSYeuThich> createState() => _DSYeuThich();
}

class _DSYeuThich extends State<DSYeuThich> {
  _DSYeuThich();

  List<Products> products = [];
  List<String> urlImages = [];
  TextEditingController _searchController = new TextEditingController();
  List<String> authors = [''];
  List<String> subjects = [''];

  var isLoading = false;

  Future<int> getData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var user_id = pref.getString("user_id");
    final response = await http.post(
      Uri.parse('http://10.0.2.2:3000/api/v1/layDSYT'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{"user_id": user_id.toString()}),
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
    await getData();
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
      appBar: AppBar(
        title: Text("Danh sách yêu thích"),
      ),
      body: Column(
        children: [
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
