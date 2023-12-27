class FaqsStoreFeaturesModel {
  String? title;
  String? answer;

  FaqsStoreFeaturesModel({this.title, this.answer});

  FaqsStoreFeaturesModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    answer = json['answer'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['answer'] = this.answer;
    return data;
  }
}

