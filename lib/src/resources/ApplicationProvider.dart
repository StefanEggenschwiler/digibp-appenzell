import 'package:digibp_appenzell/src/models/AppStatusModel.dart';
import 'package:digibp_appenzell/src/models/ApplicationModel.dart';
import 'package:digibp_appenzell/src/models/EmployerModel.dart';
import 'package:http/http.dart' as http;
import 'dart:core';
import 'package:flutter/material.dart';
import 'dart:convert';

class ApplicationProvider {

  final String employersWebHook = 'https://hook.integromat.com/i9d781qy7edvanqliibdsw6fmo28gu1y';
  final String usersWebHook = 'https://hook.integromat.com/0qe68l3pwn3fx8avu7hiwpijlxesn7un';
  final String caseWebHook = 'https://hook.integromat.com/5ikusfdktgtr8laljodbg3jx5l1ug36m';
  final String statusWebHook = 'https://hook.integromat.com/5ikusfdktgtr8laljodbg3jx5l1ug36m';

  ApplicationProvider._();

  static final ApplicationProvider api = ApplicationProvider._();

  Future<int> insertUpdateUser(Application application) async {
    var response = await http.post(
        'https://hook.integromat.com/zjfesnrdov34htafsfecg6xy14d7ch7c',
        body: applicationToJson(application),
        headers: {'Content-type': 'application/json'}
        );
    debugPrint('INSERT UPDATE RESPONSE: ${response.statusCode} - ${response.body}');
    if(response.statusCode == 201) {
      return int.parse(response.body);
    } else {
      return 0;
    }
  }

  Future<bool> insertCase(Application application) async {
    var response = await http.post(caseWebHook, body: applicationToJson(application), headers: {'Content-type': 'application/json'});
    debugPrint('${response.statusCode} - ${response.body}');
    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  Future<AppStatus> getStatus(int applicationId) async {
    debugPrint(appStatusToJson(new AppStatus(id: applicationId)));
    var response = await http.post('https://hook.integromat.com/mim5396ufu7uttsdvib2dj1b44io1uun',
        body: appStatusToJson(new AppStatus(id: applicationId)),
        headers: {'Content-type': 'application/json'}
        );
    debugPrint('${response.body}');
    if (response.statusCode == 404) {
      return new AppStatus(id: applicationId, status: "NOT FOUND");
    }
    return appStatusFromJson(response.body);
  }

  Future<List<Employer>> getAllEmployers() async {
    var response = await http.get(employersWebHook);
    debugPrint('${response.body}');
    final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
    return parsed.map<Employer>((json) => Employer.fromMap(json)).toList();
  }

  Future<Application> getByAHV(String ahv) async {
    Application application = new Application(ahv: ahv);
    debugPrint(applicationToJson(application));

    var response = await http.post(
        'https://hook.integromat.com/k3fr1hnu6l4jylaoe8hbj5af1luyudng',
        body: applicationToJson(application),
        headers: {'Content-type': 'application/json'}
    );
    debugPrint('${response.body}');
    if (response.statusCode == 404) {
      return application;
    }
    return applicationFromJson(response.body);
  }
}