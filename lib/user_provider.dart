import 'package:flutter/cupertino.dart';
import 'package:project_ctu/User.dart';

class UserProvider with ChangeNotifier {
  User? user;
  int? get user_id => user?.user_id;
  set setUser(User user_1) {
    user?.user_id = user_1.user_id;
    user?.email = user_1.email;
    user?.img_id = user_1.img_id;
    user?.password = user_1.password;
    user?.tendang_nhap = user_1.tendang_nhap;
    user?.fac_id = user_1.fac_id;
  }
}
