


class CrosswordModel{
  int id;
  String index;
  bool isEmpty;
  String symbol;
  String description;
  CrosswordModel({
    required this.id,
    required this.index,
    required this.isEmpty,
    required this.symbol,
    required this.description
  });

  factory CrosswordModel.fromJson(Map<String, dynamic> json) => CrosswordModel(
      id: json['id'],
      index: json['index'],
      isEmpty: json['isEmpty'],
      symbol: json['symbol'],
      description: json['description']
  );


  Map<String, dynamic> toJson() => {
    'id': id,
    'index': index,
    'isEmpty': isEmpty,
    'symbol': symbol,
    'description': description,
  };

}