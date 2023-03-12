import 'dart:convert';

Attendence clientFromJson(String str) {
  final jsonData = json.decode(str);
  return Attendence.fromMap(jsonData);
}

String clientToJson(Attendence data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class Attendence {
  int? id;
  int stdid;
  String date;
  int status;

  Attendence({
    this.id,
    required this.stdid,
    required this.date,
    required this.status,
  });

  factory Attendence.fromMap(Map<String, dynamic> json) => new Attendence(
      id: json["id"],
      stdid: json["stdid"],
      date: json["date"],
      status: json["status"]);

  Map<String, dynamic> toMap() => {
        "id": id,
        "stdid": stdid,
        "date": date,
        "status": status,
      };
  int get _status => this.status;

  set myValue(int value) {
    this.status = value;
  }
}
