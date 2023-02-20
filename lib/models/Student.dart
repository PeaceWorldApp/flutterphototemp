import 'dart:convert';

Student clientFromJson(String str) {
  final jsonData = json.decode(str);
  return Student.fromMap(jsonData);
}

String clientToJson(Student data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class Student {
  int? id;
  String firstName;
  String lastName;
  String note;

  Student({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.note,
  });

  factory Student.fromMap(Map<String, dynamic> json) => new Student(
        id: json["id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        note: json["note"]
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "first_name": firstName,
        "last_name": lastName,
        "note": note,
      };
}
