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
    return ChangeNotifierProvider(
      create: (context) => LoginCheck(),
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
              child: Form(
            child: Column(
              children: [
                TextField(
                  controller: _controllerTenTaiLieu,
                  decoration: ThemeHelper().textInputDecoration('Tên tài liệu'),
                ),
                TextField(
                  controller: _controllerMonHoc,
                  decoration: ThemeHelper().textInputDecoration('Môn học'),
                ),
                TextField(
                  controller: _controllerTacGia,
                  decoration: ThemeHelper().textInputDecoration('Tác giả'),
                ),
                TextField(
                  controller: _controllerChiTiet,
                  decoration: ThemeHelper().textInputDecoration('Chi tiet'),
                ),
                TextField(
                  controller: _controllerGiaThanh,
                  decoration: ThemeHelper()
                      .textInputDecoration('gia thanh(don vi nghin)'),
                ),
                // TextField(
                //   decoration: ThemeHelper().textInputDecoration(),
                // ),
                DropdownButtonHideUnderline(
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
                ElevatedButton(onPressed: SubmitButton, child: Text('Submit'))
              ],
            ),
          )),
        ),
      ),
    );
  }

  void SubmitButton() {
    // print(_controllerChiTiet.text);
    // print(_controllerGiaThanh.text);
    // print(_controllerMonHoc.text);
    // print(_controllerTacGia.text);
    // print(selectedValue);
    // // print(Provider.of<LoginCheck>(context).getUserId.toString());
    // print(context.read<LoginCheck>().getUserId.toString() + "day la userid");
    // print();
    // _futureUser;
    print("img vua upload " + img_id_uploaded);
  }

  Future<Products> uploadProduct(
      String user_id,
      String price,
      String type,
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
        "type": type,
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
          product_id: 0,
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
    print(res.headers.keys.toString() + " day la header");
    // print(res.toString());
    // res.stream.;
    var res_1 = await res.stream.bytesToString();
    // res_1 = Set.from(res_1);

    img_id_uploaded = res_1;
    setState(() {
      image = img;
    });
  }
}
