import 'dart:convert';

Application applicationFromJson(String str) {
  final jsonData = json.decode(str);
  return Application.fromMap(jsonData);
}

String applicationToJson(Application data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class Application {
  int id;
  int employerId;
  String email;
  String firstName;
  String lastName;
  DateTime birthDate;
  String ahv;
  String address;
  int zipCode;
  String city;
  String country;
  String phone;

  Application({id, employerId, email, phone, firstName, lastName, birthDate, ahv, address, zipCode, city, country}) :
        id = id,
        employerId = employerId,
        email = email,
        phone = phone,
        firstName = firstName,
        lastName = lastName,
        birthDate = birthDate,
        ahv = ahv,
        address = address,
        zipCode = zipCode,
        city = city,
        country = country
  ;


  Map<String, dynamic> toMap() {
    return {
      'id' : id,
      'employerId' : employerId,
      'email' : email,
      'phone' : phone,
      'firstName' : firstName,
      'lastName' : lastName,
      'birthDate' : birthDate.toIso8601String(),
      'ahv' : ahv,
      'address' : address,
      'zipCode' : zipCode,
      'city' : city,
      'country' : country
    };
  }

  factory Application.fromMap(Map<dynamic, dynamic> V) => new Application(
      id: V['id'],
      email: V['email'],
      phone: V['phone'],
      firstName: V['firstName'],
      lastName: V['lastName'],
      birthDate: DateTime.parse(V['birthdate']),
      ahv: V['ahv'],
      address: V['address'],
      zipCode: V['zipCode'],
      city: V['city'],
      country: V['country']
  );

  @override
  String toString() {
    return 'Application{id: $id, employerId: $employerId, email: $email, phone: $phone, firstName: $firstName, lastName: $lastName, birthDate: $birthDate, ahv: $ahv, address: $address, zipCode: $zipCode, city: $city, country: $country}';
  }
}