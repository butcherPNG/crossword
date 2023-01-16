class CrosswordDocModel{
  String uid;
  String title;


  CrosswordDocModel({
    required this.uid,
    required this.title,

  });

  factory CrosswordDocModel.fromJson(Map<String, dynamic> json) => CrosswordDocModel(
      uid: json['uid'],
      title: json['title'],
  );


  Map<String, dynamic> toJson() => {
    'uid': uid,
    'title': title,
  };

}