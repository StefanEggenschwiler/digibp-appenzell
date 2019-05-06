import 'dart:convert';

Employer appStatusFromJson(String str) {
  final jsonData = json.decode(str);
  return Employer.fromMap(jsonData, null);
}

String appStatusToJson(Employer data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class Employer {
  int id;
  String name;

  Employer({id, status}) :
        id = id,
        name = status
  ;


  Map<String, dynamic> toMap() {
    return {
      'id' : id,
      'name' : name
    };
  }

  factory Employer.fromMap(K, Map<dynamic, dynamic> V) => new Employer(
      id: K.toString(),
      status: V['name']
  );
}