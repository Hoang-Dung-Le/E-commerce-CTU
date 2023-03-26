import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:project_ctu/constants.dart';
import 'package:project_ctu/screens/home/components/result_search_document.dart';

import 'featurred_plants.dart';
import 'header_with_seachbox.dart';
import 'recommend.dart';
import 'title_with_more_bbtn.dart';

class Body extends StatelessWidget {
  TextEditingController _searchController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    // It will provie us total height  and width of our screen
    Size size = MediaQuery.of(context).size;
    // it enable scrolling on small device
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: kDefaultPadding * 2.5),
            // It will cover 20% of our total height
            height: size.height * 0.2,
            child: Stack(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(
                    left: kDefaultPadding,
                    right: kDefaultPadding,
                    bottom: 36 + kDefaultPadding,
                  ),
                  height: size.height * 0.2 - 27,
                  decoration: BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(36),
                      bottomRight: Radius.circular(36),
                    ),
                  ),
                  child: Row(
                    children: <Widget>[
                      Text(
                        'Hi Uishopy!',
                        style: Theme.of(context).textTheme.headline5?.copyWith(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      Spacer(),
                      Image.asset("assets/images/logo.png")
                    ],
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.symmetric(horizontal: kDefaultPadding),
                    padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
                    height: 54,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0, 10),
                          blurRadius: 50,
                          color: kPrimaryColor.withOpacity(0.23),
                        ),
                      ],
                    ),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            onChanged: (value) {},
                            decoration: InputDecoration(
                              hintText: "Search",

                              hintStyle: TextStyle(
                                color: kPrimaryColor.withOpacity(0.5),
                              ),
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              // surffix isn't working properly  with SVG
                              // thats why we use row
                              // suffixIcon: SvgPicture.asset("assets/icons/search.svg"),
                            ),
                          ),
                        ),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SearchDocument(
                                            searchName: _searchController.text
                                                .toString(),
                                          )));
                            },
                            child: SvgPicture.asset("assets/icons/search.svg")),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          TitleWithMoreBtn(title: "Tài liệu Trường CNTT&TT", press: () {}),
          // RecomendsPlants(),
          FeaturedPlants(),
          TitleWithMoreBtn(title: "Tài liệu trường Bách Khoa", press: () {}),
          FeaturedPlants(),
          TitleWithMoreBtn(title: "Tài liệu trường Thuỷ sản", press: () {}),
          FeaturedPlants(),
          TitleWithMoreBtn(title: "Tài liệu trường Kinh Tế", press: () {}),
          FeaturedPlants(),
          SizedBox(height: kDefaultPadding),
        ],
      ),
    );
  }
}
