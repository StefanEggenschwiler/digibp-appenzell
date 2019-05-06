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
  final String caseWebHook = '';

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
    var response = await http.get(caseWebHook);
    debugPrint('${response.body}');
    return appStatusFromJson(response.body);
  }

  Future<List<Employer>> getAllEmployers() async {
    var response = await http.get(employersWebHook);
    debugPrint('${response.body}');
    final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
    return parsed.map<Employer>((json) => Employer.fromMap(json)).toList();
  }

  Future<Application> getByAHV(String ahv) async {
    var response = await http.get(usersWebHook);
    debugPrint('${response.body}');
    return applicationFromJson(response.body);
  }
}