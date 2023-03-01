class Products {
  final int product_id;
  final int user_id;
  final int price;
  final int type;
  final int img_id;
  final int fac_id;
  final String name;
  final String subject;
  final String author;
  final String detail;
  final int hidden;
  final String product_date;

  const Products({
    required this.product_id,
    required this.user_id,
    required this.price,
    required this.type,
    required this.img_id,
    required this.fac_id,
    required this.name,
    required this.subject,
    required this.author,
    required this.detail,
    required this.hidden,
    required this.product_date,
  });

  void print_value() {
    print(product_id.toString() + name.toString());
  }

  factory Products.fromJson(Map<String, dynamic> json) {
    return Products(
        product_id: json['product_id'],
        user_id: json['user_id'],
        price: json['price'],
        type: json['type'],
        img_id: json['img_id'],
        fac_id: json['fac_id'],
        name: json['name'],
        subject: json['subject'],
        author: json['author'],
        detail: json['detail'],
        hidden: json['hidden'],
        product_date: json['product_date']);
  }
}
