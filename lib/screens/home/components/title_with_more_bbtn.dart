import 'package:flutter/material.dart';

import '../../../constants.dart';

class TitleWithMoreBtn extends StatefulWidget {
  const TitleWithMoreBtn({
    required this.title,
    required this.press,
  }) : super();
  final String title;
  final VoidCallback press;

  @override
  State<TitleWithMoreBtn> createState() => _TitleWithMoreBtnState();
}

class _TitleWithMoreBtnState extends State<TitleWithMoreBtn> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
      child: Row(
        children: <Widget>[
          TitleWithCustomUnderline(text: widget.title),
          Spacer(),
          TextButton(
            onPressed: widget.press,
            child: Text(
              'More',
              style: TextStyle(color: Colors.white),
            ),
            style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                backgroundColor: kPrimaryColor),
          ),
        ],
      ),
    );
  }
}

class TitleWithCustomUnderline extends StatelessWidget {
  const TitleWithCustomUnderline({
    required this.text,
  }) : super();

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24,
      child: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: kDefaultPadding / 4),
            child: Text(
              text,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              margin: EdgeInsets.only(right: kDefaultPadding / 4),
              height: 7,
              color: kPrimaryColor.withOpacity(0.2),
            ),
          )
        ],
      ),
    );
  }
}
