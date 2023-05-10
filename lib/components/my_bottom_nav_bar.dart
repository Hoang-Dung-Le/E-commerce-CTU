import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:project_ctu/pages/comment_page.dart';
import 'package:project_ctu/pages/profile_page.dart';
import 'package:project_ctu/pages/question_display.dart';
import 'package:project_ctu/pages/uploadProduct.dart';

import '../constants.dart';
import '../screens/home/user_profile.dart';

class MyBottomNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: kDefaultPadding * 2,
        right: kDefaultPadding * 2,
        bottom: kDefaultPadding,
      ),
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: Offset(0, -10),
            blurRadius: 35,
            color: kPrimaryColor.withOpacity(0.38),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
            icon: SvgPicture.asset("assets/icons/flower.svg"),
            onPressed: () {},
          ),
          IconButton(
            icon: SvgPicture.asset("assets/icons/heart-icon.svg"),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => gotoUploadImage(context)));
            },
          ),
          IconButton(
            icon: SvgPicture.asset("assets/icons/ques.svg"),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => goToQuestionPage(context)));
            },
          ),
          IconButton(
            icon: SvgPicture.asset("assets/icons/user-icon.svg"),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => goToCommentPage(context)));
            },
          ),
        ],
      ),
    );
  }

  Widget goToQuestionPage(BuildContext context) {
    return Question_Display();
  }

  Widget goToCommentPage(BuildContext context) {
    return ProfileUserPage();
  }

  Widget gotoUploadImage(BuildContext context) {
    return UpLoadImage();
  }
}
