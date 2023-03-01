import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ImageFromApi {
  final int img_id;
  final int type;
  final String url;

  const ImageFromApi(
      {required this.img_id, required this.type, required this.url});

  factory ImageFromApi.fromJson(Map<String, dynamic> json) {
    return ImageFromApi(
        img_id: json['img_id'], type: json['type'], url: json['url']);
  }
}
