import 'dart:convert';

Fee clientFromJson(String str) {
  final jsonData = json.decode(str);
  return Fee.fromMap(jsonData);
}

String clientToJson(Fee data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class Fee {
  int? id;
  int money;
  String note;
  static final columns = ["id", "money", "note"];
  Fee({this.id, required this.money, required this.note});

  factory Fee.fromMap(Map<String, dynamic> json) =>
      new Fee(id: json["id"], money: json["money"], note: json["note"]);

  Map<String, dynamic> toMap() => {"id": id, "money": money, "note": note};
  // int get _money => this.money;

  // set myValue(int value) {
  //   this.status = value;
  // }
}
