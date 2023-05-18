import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:email_validator/email_validator.dart';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:project_ctu/pages/login_page.dart';
import 'package:project_ctu/screens/home/components/printing_shop_screen.dart';

// class RegistrationScreen extends StatefulWidget {
//   @override
//   _RegistrationScreenState createState() => _RegistrationScreenState();
// }

// class _RegistrationScreenState extends State<RegistrationScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _emailController = TextEditingController();
//   final _usernameController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _confirmPasswordController = TextEditingController();
//   final _storeNameController = TextEditingController();
//   final _phoneNumberController = TextEditingController();
//   final _addressController = TextEditingController();
//   final _openingTimeController = TextEditingController();
//   final _closingTimeController = TextEditingController();
//   final _descriptionController = TextEditingController();

//   DateTime _selectedOpeningTime = DateTime.now();
//   DateTime _selectedClosingTime = DateTime.now();

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _usernameController.dispose();
//     _passwordController.dispose();
//     _confirmPasswordController.dispose();
//     _storeNameController.dispose();
//     _phoneNumberController.dispose();
//     _addressController.dispose();
//     _openingTimeController.dispose();
//     _closingTimeController.dispose();
//     _descriptionController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Đăng kí'),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: EdgeInsets.all(16.0),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 TextFormField(
//                   controller: _emailController,
//                   decoration: InputDecoration(
//                     labelText: 'Email',
//                   ),
//                   validator: (value) {
//                     if (value!.isEmpty || !value!.contains('@')) {
//                       return 'Vui lòng nhập email hợp lệ.';
//                     }
//                     return null;
//                   },
//                 ),
//                 TextFormField(
//                   controller: _usernameController,
//                   decoration: InputDecoration(
//                     labelText: 'Tên đăng nhập',
//                   ),
//                   validator: (value) {
//                     if (value!.isEmpty) {
//                       return 'Vui lòng nhập tên đăng nhập.';
//                     }
//                     return null;
//                   },
//                 ),
//                 TextFormField(
//                   controller: _passwordController,
//                   obscureText: true,
//                   decoration: InputDecoration(
//                     labelText: 'Mật khẩu',
//                   ),
//                   validator: (value) {
//                     if (value!.isEmpty || value.length < 6) {
//                       return 'Vui lòng nhập mật khẩu có ít nhất 6 ký tự.';
//                     }
//                     return null;
//                   },
//                 ),
//                 TextFormField(
//                   controller: _confirmPasswordController,
//                   obscureText: true,
//                   decoration: InputDecoration(
//                     labelText: 'Xác nhận mật khẩu',
//                   ),
//                   validator: (value) {
//                     if (value != _passwordController.text) {
//                       return 'Mật khẩu xác nhận không khớp.';
//                     }
//                     return null;
//                   },
//                 ),
//                 TextFormField(
//                   controller: _storeNameController,
//                   decoration: InputDecoration(
//                     labelText: 'Tên cửa hàng',
//                   ),
//                   validator: (value) {
//                     if (value!.isEmpty) {
//                       return 'Vui lòng nhập tên cửa hàng.';
//                     }
//                     return null;
//                   },
//                 ),
//                 TextFormField(
//                   controller: _phoneNumberController,
//                   keyboardType: TextInputType.phone,
//                   decoration: InputDecoration(
//                     labelText: 'Số điện thoại',
//                   ),
//                   validator: (value) {
//                     if (value!.isEmpty ||
//                         !RegExp(r'(^(?:[+0]9)?[0-9]{10}$)').hasMatch(value)) {
//                       return 'Vui lòng nhập số điện thoại hợp lệ.';
//                     }
//                     return null;
//                   },
//                 ),
//                 TextFormField(
//                   controller: _addressController,
//                   decoration: InputDecoration(
//                     labelText: 'Địa chỉ',
//                   ),
//                   validator: (value) {
//                     if (value!.isEmpty) {
//                       return 'Vui lòng nhập địa chỉ.';
//                     }
//                     return null;
//                   },
//                 ),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: InkWell(
//                         onTap: () async {
//                           final TimeOfDay? timeOfDay = await showTimePicker(
//                             context: context,
//                             initialTime: TimeOfDay.now(),
//                           );
//                           if (timeOfDay != null) {
//                             setState(() {
//                               _selectedOpeningTime = DateTime(
//                                 _selectedOpeningTime.year,
//                                 _selectedOpeningTime.month,
//                                 _selectedOpeningTime.day,
//                                 timeOfDay.hour,
//                                 timeOfDay.minute,
//                               );
//                             });
//                             _openingTimeController.text = DateFormat('HH:mm')
//                                 .format(_selectedOpeningTime);
//                           }
//                         },
//                         child: IgnorePointer(
//                           child: TextFormField(
//                             controller: _openingTimeController,
//                             decoration: InputDecoration(
//                               labelText: 'Giờ mở cửa',
//                             ),
//                             validator: (value) {
//                               if (value!.isEmpty) {
//                                 return 'Vui lòng chọn giờ mở cửa.';
//                               }
//                               return null;
//                             },
//                           ),
//                         ),
//                       ),
//                     ),
//                     SizedBox(width: 8.0),
//                     Expanded(
//                       child: InkWell(
//                         onTap: () async {
//                           final TimeOfDay? timeOfDay = await showTimePicker(
//                             context: context,
//                             initialTime: TimeOfDay.now(),
//                           );
//                           if (timeOfDay != null) {
//                             setState(() {
//                               _selectedClosingTime = DateTime(
//                                 _selectedClosingTime.year,
//                                 _selectedClosingTime.month,
//                                 _selectedClosingTime.day,
//                                 timeOfDay.hour,
//                                 timeOfDay.minute,
//                               );
//                             });
//                             _closingTimeController.text = DateFormat('HH:mm')
//                                 .format(_selectedClosingTime);
//                           }
//                         },
//                         child: IgnorePointer(
//                           child: TextFormField(
//                             controller: _closingTimeController,
//                             decoration: InputDecoration(
//                               labelText: 'Giờ đóng cửa',
//                             ),
//                             validator: (value) {
//                               if (value!.isEmpty) {
//                                 return 'Vui lòng chọn giờ đóng cửa.';
//                               }
//                               return null;
//                             },
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 TextFormField(
//                   controller: _descriptionController,
//                   maxLines: 3,
//                   decoration: InputDecoration(
//                     labelText: 'Mô tả',
//                   ),
//                   validator: (value) {
//                     if (value!.isEmpty) {
//                       return 'Vui lòng nhập mô tả.';
//                     }
//                     return null;
//                   },
//                 ),
//                 SizedBox(height: 16.0),
//                 ElevatedButton(
//                   onPressed: () {
//                     if (_formKey.currentState!.validate()) {
//                       // handle registration
//                     }
//                   },
//                   child: Text('Đăng kí'),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _storeNameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _addressController = TextEditingController();
  DateTime? _openingTime;
  DateTime? _closingTime;
  final _descriptionController = TextEditingController();
  String img_id_uploaded = 'null';

  XFile? image;

  final ImagePicker picker = ImagePicker();

  int parse(string_test) {
    int result = 0;
    for (int i = 0; i < string_test.length; i++) {
      if (int.tryParse(string_test[i]) != null) {
        result = result * 10 + int.parse(string_test[i]);
      }
    }
    return result;
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
    img_id_uploaded = parse(res_1).toString();
    print("day la res 1 " + res_1.toString());
    setState(() {
      image = img;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Đăng ký'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
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
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập email.';
                  }
                  if (!EmailValidator.validate(value)) {
                    return 'Email không hợp lệ.';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: 'Tên đăng nhập'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập tên đăng nhập.';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Mật khẩu'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập mật khẩu.';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(labelText: 'Xác nhận mật khẩu'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng xác nhận mật khẩu.';
                  }
                  if (value != _passwordController.text) {
                    return 'Mật khẩu không khớp.';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _storeNameController,
                decoration: InputDecoration(labelText: 'Tên cửa hàng'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập tên cửa hàng.';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _phoneNumberController,
                decoration: InputDecoration(labelText: 'Số điện thoại'),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  final phoneRegex = RegExp(r'(84|0[3|5|7|8|9])+([0-9]{8})\b');
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập số điện thoại.';
                  }
                  if (!phoneRegex.hasMatch(value)) {
                    return 'Số điện thoại không hợp lệ.';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(labelText: 'Địa chỉ'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập địa chỉ.';
                  }
                  return null;
                },
              ),
              ListTile(
                leading: Icon(Icons.schedule),
                title: Text('Thời gian mở cửa'),
                subtitle: Text(_openingTime != null
                    ? DateFormat.Hm().format(_openingTime!)
                    : 'Chọn giờ'),
                onTap: () async {
                  final timeOfDay = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (timeOfDay != null) {
                    setState(() {
                      _openingTime = DateTime(
                        DateTime.now().year,
                        DateTime.now().month,
                        DateTime.now().day,
                        timeOfDay.hour,
                        timeOfDay.minute,
                      );
                    });
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.schedule),
                title: Text('Thời gian đóng cửa'),
                subtitle: Text(_closingTime != null
                    ? DateFormat.Hm().format(_closingTime!)
                    : 'Chọn giờ'),
                onTap: () async {
                  final timeOfDay = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (timeOfDay != null) {
                    setState(() {
                      _closingTime = DateTime(
                        DateTime.now().year,
                        DateTime.now().month,
                        DateTime.now().day,
                        timeOfDay.hour,
                        timeOfDay.minute,
                      );
                    });
                  }
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Mô tả'),
                maxLines: null,
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  if (img_id_uploaded == 'null') {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Thông báo'),
                          content: Text('Bạn phải tải ảnh lên'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  } else if (_formKey.currentState!.validate()) {
                    var result = checkUserName(_usernameController.text);
                    var result2 = null;
                    result.then((value) => {
                          if (value == false)
                            {
                              setState(() {
                                _usernameController.text = "";
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Thông báo'),
                                      content: Text('Tên đăng nhập đã tồn tại'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('OK'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              })
                            }
                          else
                            {
                              result2 = dangKy(
                                  _emailController.text,
                                  _usernameController.text,
                                  _passwordController.text,
                                  img_id_uploaded,
                                  _storeNameController.text,
                                  _phoneNumberController.text,
                                  _addressController.text,
                                  _openingTime.toString(),
                                  _closingTime.toString(),
                                  _descriptionController.text),
                              result.then((value) => {
                                    if (value == true)
                                      {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text('Thông báo'),
                                              content:
                                                  Text('Đăng ký thành công'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pushReplacement(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                LoginPage()));
                                                  },
                                                  child: Text('OK'),
                                                ),
                                              ],
                                            );
                                          },
                                        )
                                      }
                                  })
                            }
                        });
                  }
                  ;
                },
                child: Text('Đăng ký'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> checkUserName(String userName) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:3000/api/v1/checkUserName'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'tendang_nhap': userName,
      }),
    );

    if (response.statusCode == 200) {
      var result = jsonDecode(response.body)['check'];
      print("ket qua ne: " + result + " type " + result.runtimeType.toString());
      if (result == '0') {
        return false;
      } else {
        return true;
      }
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to create album.');
    }
  }

  Future<bool> dangKy(
      String email,
      String tendang_nhap,
      String password,
      String img_id,
      String ten_cua_hang,
      String sdt,
      String dia_chi,
      String thoi_gian_mo,
      String thoi_gian_dong,
      String mo_ta) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:3000/api/v1/insertPrinttingShop'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'tendang_nhap': tendang_nhap,
        'password': password,
        'img_id': img_id,
        'ten_cua_hang': ten_cua_hang,
        'sdt': sdt,
        'dia_chi': dia_chi,
        'thoi_gian_mo': thoi_gian_mo,
        'thoi_gian_dong': thoi_gian_dong,
        'mo_ta': mo_ta
      }),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to create album.');
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
}
// class _RegisterPageState extends State<RegisterPage> {
// final _formKey = GlobalKey<FormState>();
// final _emailController = TextEditingController();
// final _usernameController = TextEditingController();
// final _passwordController = TextEditingController();
// final _confirmPasswordController = TextEditingController();
// final _storeNameController = TextEditingController();
// final _phoneNumberController = TextEditingController();
// final _addressController = TextEditingController();
// final _openingTimeController = TextEditingController();
// final _closingTimeController = TextEditingController();
// final _descriptionController = TextEditingController();
// DateTime _selectedOpeningTime = DateTime.now();
// DateTime _selectedClosingTime = DateTime.now();

// @override
// Widget build(BuildContext context) {
// return Scaffold(
// appBar: AppBar(
// title: Text('Đăng kí'),
// ),
// body: SingleChildScrollView(
// child: Padding(
// padding: EdgeInsets.all(16.0),
// child: Form(
// key: _formKey,
// child: Column(
// crossAxisAlignment: CrossAxisAlignment.stretch,
// children: [
// TextFormField(
// controller: _emailController,
// keyboardType: TextInputType.emailAddress,
// decoration: InputDecoration(
// labelText: 'Email',
// ),
// validator: (value) {
// if (value.isEmpty || !RegExp(r'^[\w-.]+@([\w-]+.)+[\w-]{2,4}$').hasMatch(value)) {
// return 'Vui lòng nhập email hợp lệ.';
// }
// return null;
// },
// ),
// TextFormField(
// controller: _usernameController,
// decoration: InputDecoration(
// labelText: 'Tên đăng nhập',
// ),
// validator: (value) {
// if (value.isEmpty) {
// return 'Vui lòng nhập tên đăng nhập.';
// }
// return null;
// },
// ),
// TextFormField(
// controller: _passwordController,
// obscureText: true,
// decoration: InputDecoration(
// labelText: 'Mật khẩu',
// ),
// validator: (value) {
// if (value.isEmpty) {
// return 'Vui lòng nhập mật khẩu.';
// }
// return null;
// },
// ),
// TextFormField(
// controller: _confirmPasswordController,
// obscureText: true,
// decoration: InputDecoration(
// labelText: 'Xác nhận mật khẩu',
// ),
// validator: (value) {
// if (value.isEmpty || value != _passwordController.text) {
// return 'Mật khẩu không khớp.';
// }
// return null;
// },
// ),
// SizedBox(height: 16.0),
// Text(
// 'Thông tin cửa hàng',
// style: TextStyle(
// fontSize: 18.0,
// fontWeight: FontWeight.bold,
// ),
// ),
// SizedBox(height: 16.0),
// TextFormField(
// controller: _storeNameController,
// decoration: InputDecoration(
// labelText: 'Tên cửa hàng',
// ),
// validator: (value) {
// if (value.isEmpty) {
// return 'Vui lòng nhập tên cửa hàng.';
// }
// return null;
// },
// ),
// TextFormField(
// controller: _phoneNumberController,
// keyboardType: TextInputType.phone,
// decoration: InputDecoration(
// labelText: 'Số điện thoại',
// ),
// validator: (value) {
// if (value.isEmpty || !RegExp(r'(^(?:[+0]9)?[0-9]{10}$)').hasMatch(value)) {
// return 'Vui lòng nhập số điện thoại hợp lệ.';
// }
// return null;
// },
// ),
// TextFormField(
// controller: _addressController,
// decoration: InputDecoration(
// labelText: 'Địa chỉ',   ),
//               validator: (value) {
//                 if (value.isEmpty) {
//                   return 'Vui lòng nhập địa chỉ.';
//                 }
//                 return null;
//               },
//             ),
//             SizedBox(height: 16.0),
//             Text(
//               'Thời gian mở cửa',
//               style: TextStyle(
//                 fontSize: 18.0,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             SizedBox(height: 16.0),
//             Row(
//               children: [
//                 Expanded(
//                   child: InkWell(
//                     onTap: () async {
//                       final selectedTime = await showTimePicker(
//                         context: context,
//                         initialTime: TimeOfDay.fromDateTime(_selectedOpeningTime),
//                       );
//                       if (selectedTime != null) {
//                         setState(() {
//                           _selectedOpeningTime = DateTime(
//                             _selectedOpeningTime.year,
//                             _selectedOpeningTime.month,
//                             _selectedOpeningTime.day,
//                             selectedTime.hour,
//                             selectedTime.minute,
//                           );
//                           _openingTimeController.text =
//                               DateFormat('HH:mm').format(_selectedOpeningTime);
//                         });
//                       }
//                     },
//                     child: AbsorbPointer(
//                       child: TextFormField(
//                         controller: _openingTimeController,
//                         decoration: InputDecoration(
//                           labelText: 'Giờ mở cửa',
//                         ),
//                         validator: (value) {
//                           if (value.isEmpty) {
//                             return 'Vui lòng chọn giờ mở cửa.';
//                           }
//                           return null;
//                         },
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: 16.0),
//                 Expanded(
//                   child: InkWell(
//                     onTap: () async {
//                       final selectedTime = await showTimePicker(
//                         context: context,
//                         initialTime: TimeOfDay.fromDateTime(_selectedClosingTime),
//                       );
//                       if (selectedTime != null) {
//                         setState(() {
//                           _selectedClosingTime = DateTime(
//                             _selectedClosingTime.year,
//                             _selectedClosingTime.month,
//                             _selectedClosingTime.day,
//                             selectedTime.hour,
//                             selectedTime.minute,
//                           );
//                           _closingTimeController.text =
//                               DateFormat('HH:mm').format(_selectedClosingTime);
//                         });
//                       }
//                     },
//                     child: AbsorbPointer(
//                       child: TextFormField(
//                         controller: _closingTimeController,
//                         decoration: InputDecoration(
//                           labelText: 'Giờ đóng cửa',
//                         ),
//                         validator: (value) {
//                           if (value.isEmpty) {
//                             return 'Vui lòng chọn giờ đóng cửa.';
//                           }
//                           return null;
//                         },
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 16.0),
//             TextFormField(
//               controller: _descriptionController,
//               maxLines: null,
//               decoration: InputDecoration(
//                 labelText: 'Mô tả',
//               ),
//             ),
//             SizedBox(height: 16.0),
//             ElevatedButton(
//               onPressed: () {
//                 if (_formKey.currentState.validate()) {
//                   // TODO: Handle registration logic.
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                       content: Text('Đăng kí thành công.'),
//                       backgroundColor: Colors.green,
//                     ),
//                   );
//                 }
//               },
//               child: Text('Đăng kí'),
//             ),
//           ],
//         ),
//       ),
//     ),
//   ),
// );
// }
// }

// class RegisterPage {
// } 