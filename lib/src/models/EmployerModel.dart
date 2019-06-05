import 'dart:convert';

Employer employerFromJson(String str) {
  final jsonData = json.decode(str);
  return Employer.fromMap(jsonData);
}

String employerToJson(Employer data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class Employer {
  int id;
  String name;
  String email;

  Employer({id, name, email}) :
        id = id,
        name = name,
        email = email
  ;


  Map<String, dynamic> toMap() {
    return {
      'id_employer' : id,
      'emp_name' : name,
      'emp_email' : email
    };
  }

  factory Employer.fromMap(Map<dynamic, dynamic> V) => new Employer(
      id: V['id_employer'],
      name: V['emp_name'],
      email: V['emp_email']
  );

  @override
  String toString() {
    return 'Employer{id: $id, name: $name, email: $email}';
  }
}