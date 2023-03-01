class User {
  int? user_id;
  String? email;
  String? tendang_nhap;
  String? password;
  int? fac_id;
  int? img_id;

  User(
      {required this.user_id,
      required this.email,
      required this.tendang_nhap,
      required this.password,
      required this.fac_id,
      required this.img_id});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        user_id: json['user_id'],
        email: json['email'],
        tendang_nhap: json['tendang_nhap'],
        password: json['password'],
        fac_id: json['fac_id'],
        img_id: json['img_id']);
  }
}
