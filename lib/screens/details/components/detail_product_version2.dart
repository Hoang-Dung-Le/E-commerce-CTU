import 'package:flutter/material.dart';
import 'package:project_ctu/products.dart';
import 'package:project_ctu/screens/details/components/myproducts.dart';

class ProductPage extends StatelessWidget {
  final Products product;
  final String url;

  ProductPage({required this.product, required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thông tin sản phẩm'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          Card(
            elevation: 2.0,
            child: Image.network(
              url,
              fit: BoxFit.cover,
              height: 200.0,
            ),
          ),
          SizedBox(height: 16.0),
          ListTile(
            title: Text(
              product.name.toString(),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            title: Text('Người đăng bán'),
            subtitle: Text('Hoang Dung'),
          ),
          ListTile(
            title: Text('Giá'),
            subtitle: Text('${product.price}'),
          ),
          SizedBox(height: 16.0),
          Card(
            elevation: 2.0,
            child: Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    'Khung chat với người bán',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'Gửi tin nhắn đến người bán',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
