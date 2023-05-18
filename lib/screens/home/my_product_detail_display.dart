import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:project_ctu/products.dart';
import 'package:project_ctu/screens/home/chinh_sua_gia.dart';
import 'package:project_ctu/screens/home/chinh_sua_mo_ta.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../components/my_bottom_nav_bar.dart';
import '../details/components/myproducts.dart';
import 'chinh_sua_ten_Sp.dart';

class ProductManagementPage extends StatefulWidget {
  final Product product;

  const ProductManagementPage({required this.product});

  @override
  State<ProductManagementPage> createState() => _ProductManagementPageState();
}

class _ProductManagementPageState extends State<ProductManagementPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quản lý sản phẩm'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Tên sản phẩm:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.edit),
              title: Text(widget.product.name.toString()),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditProductNamePage(
                              currentName: widget.product.name.toString(),
                              product_id: widget.product.product_id,
                            )));
              },
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Mô tả:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.edit),
              title: Text(widget.product.detail.toString()),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditProductDescriptionPage(
                              product_id: widget.product.product_id,
                              currentDescription: widget.product.detail,
                            )));
              },
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Giá:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.edit),
              title: Text(widget.product.price.toString()),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditProductPricePage(
                              product_id: widget.product.product_id,
                              currentPrice: widget.product.price,
                            )));
              },
            ),
            // Thêm các thông tin khác và xử lý sự kiện chỉnh sửa tương tự
          ],
        ),
      ),
    );
  }
}
