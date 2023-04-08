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
  String note;
  int status;

  Attendence(
      {this.id,
      required this.stdid,
      required this.date,
      required this.note,
      required this.status});

  factory Attendence.fromMap(Map<String, dynamic> json) => new Attendence(
      id: json["id"],
      stdid: json["stdid"],
      date: json["date"],
      note: json["note"],
      status: json["status"]);

  Map<String, dynamic> toMap() => {
        "id": id,
        "stdid": stdid,
        "date": date,
        "note": note,
        "status": status,
      };
  int get _status => this.status;

  set myValue(int value) {
    this.status = value;
  }
}
