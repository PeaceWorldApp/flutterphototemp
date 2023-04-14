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
  int feid;

  Attendence(
      {this.id,
      required this.stdid,
      required this.date,
      required this.note,
      required this.status,
      required this.feid});

  factory Attendence.fromMap(Map<String, dynamic> json) => new Attendence(
      id: json["id"],
      stdid: json["stdid"],
      date: json["date"],
      note: json["note"],
      status: json["status"],
      feid: json["feid"]);

  Map<String, dynamic> toMap() => {
        "id": id,
        "stdid": stdid,
        "date": date,
        "note": note,
        "status": status,
        "feid": feid,
      };
  int get _status => this.status;

  set myValue(int value) {
    this.status = value;
  }

  int get _feid => this.feid;

  set myFeid(int value) {
    this.feid = value;
  }
}
