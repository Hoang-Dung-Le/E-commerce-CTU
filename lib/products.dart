class Products {
  int? user_id;
  int? price;
  int? type;
  int? img_id;
  int? fac_id;
  String? name;
  String? subject;
  String? author;
  String? detail;
  int? hidden;
  String? product_date;

  Products({
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

  factory Products.fromJson(Map<String, dynamic> json) {
    return Products(
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
