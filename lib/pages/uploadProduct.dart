import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:project_ctu/common/theme_helper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:project_ctu/products.dart';
import 'package:project_ctu/screens/home/components/login_check.dart';
import 'package:project_ctu/user_provider.dart';
import 'dart:io';
import 'package:provider/provider.dart';

import '../components/my_bottom_nav_bar.dart';
import '../constants.dart';
import '../screens/home/home_screen.dart';

class UpLoadImage extends StatefulWidget {
  const UpLoadImage({super.key});

  @override
  State<UpLoadImage> createState() => _UpLoadImageState();
}

class _UpLoadImageState extends State<UpLoadImage> {
  final List<String> genderItems = [
    'Trường CNTT&TT',
    'Trường Bách Khoa',
    'Trường Kinh Tế',
    'Trường Nông Nghiệp'
  ];

  late String img_id_uploaded;

  XFile? image;

  final ImagePicker picker = ImagePicker();

  String? selectedValue;
  TextEditingController _controllerTenTaiLieu = new TextEditingController();
  TextEditingController _controllerMonHoc = new TextEditingController();
  TextEditingController _controllerTacGia = new TextEditingController();
  TextEditingController _controllerChiTiet = new TextEditingController();
  TextEditingController _controllerGiaThanh = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ChangeNotifierProvider(
      create: (context) => LoginCheck(),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(bottom: kDefaultPadding),
                // It will cover 20% of our total height
                height: size.height * 0.15,
                child: Stack(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(
                        left: kDefaultPadding,
                        right: kDefaultPadding,
                        bottom: 36 + kDefaultPadding,
                      ),
                      height: size.height * 0.2 - 30,
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
                            style: Theme.of(context)
                                .textTheme
                                .headline5
                                ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                          ),
                          Spacer(),
                          Image.asset("assets/images/logo.png")
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SingleChildScrollView(
                  child: Form(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: _controllerTenTaiLieu,
                        decoration:
                            ThemeHelper().textInputDecoration('Tên tài liệu'),
                        validator: (val) {
                          if (!(val!.isEmpty)) {
                            return "Không được bỏ trống";
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: _controllerMonHoc,
                        decoration:
                            ThemeHelper().textInputDecoration('Môn học'),
                        validator: (val) {
                          if ((val!.isEmpty)) {
                            return "Không được bỏ trống";
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: _controllerTacGia,
                        decoration:
                            ThemeHelper().textInputDecoration('Tác giả'),
                        validator: (val) {
                          if ((val!.isEmpty)) {
                            return "Không được bỏ trống";
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: _controllerChiTiet,
                        decoration:
                            ThemeHelper().textInputDecoration('Chi tiet'),
                        validator: (val) {
                          if ((val!.isEmpty)) {
                            return "Không được bỏ trống";
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: _controllerGiaThanh,
                        decoration: ThemeHelper()
                            .textInputDecoration('gia thanh(don vi nghin)'),
                        validator: (val) {
                          if ((val!.isEmpty) ||
                              RegExp(r"^[0-9]*$").hasMatch(val)) {
                            return "Giá thành phải là số";
                          }
                          return null;
                        },
                      ),
                    ),
                    // TextField(
                    //   decoration: ThemeHelper().textInputDecoration(),
                    // ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton2(
                          hint: Text(
                            'Select Item',
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).hintColor,
                            ),
                          ),
                          items: genderItems
                              .map((item) => DropdownMenuItem<String>(
                                    value: item,
                                    child: Text(
                                      item,
                                      style: const TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ))
                              .toList(),
                          value: selectedValue,
                          onChanged: (value) {
                            setState(() {
                              selectedValue = value as String;
                            });
                          },
                          // buttonStyleData: const ButtonStyleData(
                          //   height: 40,
                          //   width: 140,
                          // ),
                          // menuItemStyleData: const MenuItemStyleData(
                          //   height: 40,
                          // ),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        myAlert();
                      },
                      child: Text('Upload Photo'),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    //if image not null show the image
                    //if image null show text
                    image != null
                        ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(
                                //to show image, you type like this.
                                File(image!.path),
                                fit: BoxFit.cover,
                                width: MediaQuery.of(context).size.width,
                                height: 300,
                              ),
                            ),
                          )
                        : Text(
                            "No Image",
                            style: TextStyle(fontSize: 20),
                          ),
                    ElevatedButton(
                        onPressed: SubmitButton, child: Text('Submit'))
                  ],
                ),
              )),
            ],
          ),
        ),
        bottomNavigationBar: MyBottomNavBar(),
      ),
    );
  }

  void SubmitButton() {
    print("img vua upload " + parse(img_id_uploaded).toString());
    int idx = genderItems.indexWhere((element) => element == selectedValue) + 1;
    print("user id : " + context.read<LoginCheck>().getUserId.toString());
    print(_controllerGiaThanh.text.toString());
    print(_controllerChiTiet.text.toString());
    print(_controllerMonHoc.text.toString());
    print(_controllerTacGia.text.toString());
    print(_controllerTenTaiLieu.text.toString());
    print('Day la khoa : ' + idx.toString());
    Future<Products> _futureProduct = uploadProduct(
        context.read<LoginCheck>().getUserId.toString(),
        _controllerGiaThanh.text.toString(),
        parse(img_id_uploaded).toString(),
        idx.toString(),
        _controllerTenTaiLieu.text.toString(),
        _controllerMonHoc.text.toString(),
        _controllerTacGia.text.toString(),
        _controllerTacGia.text.toString());
    _futureProduct.then((value) => {
          if (value.fac_id != 12)
            {Navigator.push(context, MaterialPageRoute(builder: goToHome))}
        });
  }

  Widget goToHome(BuildContext context) {
    return HomeScreen();
  }

  int parse(string_test) {
    int result = 0;
    for (int i = 0; i < string_test.length; i++) {
      if (int.tryParse(string_test[i]) != null) {
        result = result * 10 + int.parse(string_test[i]);
      }
    }
    return result;
  }

  Future<Products> uploadProduct(
      String user_id,
      String price,
      String img_id,
      String fac_id,
      String name,
      String subject,
      String author,
      String detail) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:3000/api/v1/uploadProducts'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "user_id": user_id,
        "price": price,
        "img_id": img_id,
        "fac_id": fac_id,
        "name": name,
        "subject": subject,
        "author": author,
        "detail": detail
      }),
    );

    if (response.statusCode == 200) {
      return Products.fromJson(jsonDecode(response.body));
    } else {
      return Products(
          user_id: 0,
          price: 0,
          type: 0,
          img_id: 0,
          fac_id: 12,
          name: "",
          subject: "",
          author: '',
          detail: "",
          hidden: 0,
          product_date: "");
    }
  }

  void myAlert() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: Text('Please choose media to select'),
            content: Container(
              height: MediaQuery.of(context).size.height / 6,
              child: Column(
                children: [
                  ElevatedButton(
                    //if user click this button, user can upload image from gallery
                    onPressed: () {
                      Navigator.pop(context);
                      getImage(ImageSource.gallery);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.image),
                        Text('From Gallery'),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    //if user click this button. user can upload image from camera
                    onPressed: () {
                      Navigator.pop(context);
                      getImage(ImageSource.camera);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.camera),
                        Text('From Camera'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future getImage(ImageSource media) async {
    var img = await picker.pickImage(source: media);
    var request = http.MultipartRequest(
        'POST', Uri.parse('http://10.0.2.2:3000/api/v1/upload'));
    request.files.add(http.MultipartFile.fromBytes(
        'picture', File(img!.path).readAsBytesSync(),
        filename: img!.path));
    var res = await request.send();
    // print(res.headers.keys.toString() + " day la header");
    var res_1 = await res.stream.bytesToString();
    img_id_uploaded = res_1;
    print("day la res 1 " + res_1.toString());
    setState(() {
      image = img;
    });
  }
}
