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
      'firstname' : firstName,
      'lastname' : lastName,
      'birthDate' : birthDate != null ? birthDate.toIso8601String() : '',
      'ahv_nr' : ahv,
      'address' : address,
      'zip_code' : zipCode,
      'city' : city,
      'country' : country
    };
  }

  factory Application.fromMap(Map<dynamic, dynamic> V) => new Application(
      id: V['id'],
      email: V['email'],
      phone: V['phone'],
      firstName: V['firstname'],
      lastName: V['lastname'],
      birthDate: V['birthdate'] != null ? DateTime.parse(V['birthdate']) : null,
      ahv: V['ahv_nr'],
      address: V['address'],
      zipCode: V['zip_code'],
      city: V['city'],
      country: V['country']
  );

  @override
  String toString() {
    return 'Application{id: $id, employerId: $employerId, email: $email, phone: $phone, firstName: $firstName, lastName: $lastName, birthDate: $birthDate, ahv: $ahv, address: $address, zipCode: $zipCode, city: $city, country: $country}';
  }
}