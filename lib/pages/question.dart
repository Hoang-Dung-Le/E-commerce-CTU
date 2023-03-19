class Question {
  int? qes_id;
  int? user_id;
  String? title;
  String? detail;
  int? img_id;

  Question(
      {required this.qes_id,
      required this.user_id,
      required this.title,
      required this.detail,
      required this.img_id});

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
        qes_id: json['qes_id'],
        user_id: json['user_id'],
        title: json['title'],
        detail: json['detail'],
        img_id: json['img_id']);
  }

  int get getQesId => this.getQesId;
  String? get getTitle => this.title;
}
