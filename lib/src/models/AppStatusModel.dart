import 'dart:convert';

AppStatus appStatusFromJson(String str) {
  final jsonData = json.decode(str);
  return AppStatus.fromMap(jsonData);
}

String appStatusToJson(AppStatus data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class AppStatus {
  int id;
  String status;

  AppStatus({id, status}) :
        id = id,
        status = status
  ;


  Map<String, dynamic> toMap() {
    return {
      'status' : status
    };
  }

  factory AppStatus.fromMap(Map<dynamic, dynamic> V) => new AppStatus(
      id: V['id'],
      status: V['status']
  );
}