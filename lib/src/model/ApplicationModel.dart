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
  int id;
  int employerId;
  String email;
  String firstName;
  String lastName;
  DateTime birthDate;
  String ssn;
  String address;
  int zipCode;
  String city;
  String country;
  String phone;

  Application({id, employerId, email, phone, firstName, lastName, birthDate, ssn, address, zipCode, city, country}) :
        id = id,
        employerId = employerId,
        email = email,
        phone = phone,
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
      'employerId' : employerId,
      'email' : email,
      'phone' : phone,
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
      employerId: V['employerId'],
      email: V['email'],
      phone: V['phone'],
      firstName: V['firstName'],
      lastName: V['lastName'],
      birthDate: V['birtchDate'],
      ssn: V['ssn'],
      address: V['address'],
      zipCode: V['zipCode'],
      city: V['city'],
      country: V['country']
  );

  @override
  String toString() {
    return 'Application{id: $id, employerId: $employerId, email: $email, phone: $phone, firstName: $firstName, lastName: $lastName, birthDate: $birthDate, ssn: $ssn, address: $address, zipCode: $zipCode, city: $city, country: $country}';
  }
}