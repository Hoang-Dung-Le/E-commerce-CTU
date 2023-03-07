import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:project_ctu/common/theme_helper.dart';

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

  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Form(
        child: Column(
          children: [
            TextField(
              decoration: ThemeHelper().textInputDecoration('Tên tài liệu'),
            ),
            TextField(
              decoration: ThemeHelper().textInputDecoration('Môn học'),
            ),
            TextField(
              decoration: ThemeHelper().textInputDecoration('Tác giả'),
            ),
            TextField(
              decoration: ThemeHelper().textInputDecoration('Chi tiet'),
            ),
            TextField(
              decoration:
                  ThemeHelper().textInputDecoration('gia thanh(don vi nghin)'),
            ),
            TextField(
              decoration: ThemeHelper().textInputDecoration(),
            ),
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
          ],
        ),
      )),
    );
  }
}
