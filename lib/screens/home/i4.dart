class InFoUser {
  final String email;
  final int fac_id;
  final String tendang_nhap;

  const InFoUser(
      {required this.email, required this.fac_id, required this.tendang_nhap});

  factory InFoUser.fromJson(Map<String, dynamic> json) {
    return InFoUser(
        email: json['email'],
        fac_id: json['fac_id'],
        tendang_nhap: json['tendang_nhap']);
  }
}
