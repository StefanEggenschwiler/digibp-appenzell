import 'package:digibp_appenzell/src/models/AppStatusModel.dart';
import 'package:digibp_appenzell/src/models/ApplicationModel.dart';
import 'package:digibp_appenzell/src/models/EmployerModel.dart';
import 'package:http/http.dart' as http;
import 'dart:core';
import 'package:flutter/material.dart';
import 'dart:convert';

class ApplicationProvider {

  final String employersWebHook = 'https://hook.integromat.com/i9d781qy7edvanqliibdsw6fmo28gu1y';
  final String usersWebHook = '';
  final String caseWebHook = 'https://hook.integromat.com/5ikusfdktgtr8laljodbg3jx5l1ug36m';

  ApplicationProvider._();

  static final ApplicationProvider api = ApplicationProvider._();

  insert(Application application) {
    http.post(caseWebHook, body: applicationToJson(application))
        .then((onResponse) {
          debugPrint('Insert: $onResponse');
    });
  }

  update(Application application) {
    http.post(caseWebHook, body: applicationToJson(application))
        .then((onResponse) {
      debugPrint('Update: $onResponse');
    });
  }

  Future<AppStatus> getStatus(int applicationId) async {
    debugPrint(appStatusToJson(new AppStatus(id: applicationId)));
    var response = await http.post('https://hook.integromat.com/5ikusfdktgtr8laljodbg3jx5l1ug36m', body: appStatusToJson(new AppStatus(id: applicationId)));
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
    var response = await http.post(usersWebHook);
    debugPrint('${response.body}');
    return applicationFromJson(response.body);
  }
}