import 'dart:convert';

Application applicationFromJson(String str) {
  final jsonData = json.decode(str);
  return Application.fromMap(jsonData, null);
}

String applicationToJson(Application data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class Application {
  String id;
  String email;
  String firstName;
  String lastName;
  DateTime birthDate;
  String ssn;
  String address;
  int zipCode;
  String city;
  String country;

  Application({id, email, firstName, lastName, birthDate, ssn, address, zipCode, city, country}) :
        id = id,
        email = email,
        firstName = firstName,
        lastName = lastName,
        birthDate = birthDate,
        ssn = ssn,
        address = address,
        zipCode = zipCode,
        city = city,
        country = country
  ;


  Map<String, dynamic> toMap() {
    return {
      'email' : email,
      'firstName' : firstName,
      'lastName' : lastName,
      'birthDate' : birthDate,
      'ssn' : ssn,
      'address' : address,
      'zipCode' : zipCode,
      'city' : city,
      'country' : country
    };
  }

  factory Application.fromMap(K, Map<dynamic, dynamic> V) => new Application(
      id: K.toString(),
      email: V['email'],
      firstName: V['firstName'],
      lastName: V['lastName'],
      birthDate: V['birtchDate'],
      ssn: V['ssn'],
      address: V['address'],
      zipCode: V['zipCode'],
      city: V['city'],
      country: V['country']
  );
}