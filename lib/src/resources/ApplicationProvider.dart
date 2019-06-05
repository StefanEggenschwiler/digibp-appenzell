import 'package:digibp_appenzell/src/models/AppStatusModel.dart';
import 'package:digibp_appenzell/src/models/ApplicationModel.dart';
import 'package:digibp_appenzell/src/models/EmployerModel.dart';
import 'package:http/http.dart' as http;
import 'dart:core';
import 'package:flutter/material.dart';
import 'dart:convert';

class ApplicationProvider {

  final String employersWebHook = 'https://hook.integromat.com/p6io8rlt74f985ua8lt5noz13m3vme9c';
  final String getUserWebHook = 'https://hook.integromat.com/svjkbe2bprdrvyv2nufq8h09tbcy52wx';
  final String usersWebHook = 'https://hook.integromat.com/fge8fo81uqqvkynrfyn17kt89nzlrtg6';
  final String caseWebHook = 'https://hook.integromat.com/h1cq9xlo7acde00o5ki7h1ft6bb94y7l';
  final String statusWebHook = 'https://hook.integromat.com/mim5396ufu7uttsdvib2dj1b44io1uun';

  ApplicationProvider._();

  static final ApplicationProvider api = ApplicationProvider._();

  Future<int> insertUpdateUser(Application application) async {
    var response = await http.post(usersWebHook,
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
    var response = await http.post(statusWebHook,
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

    var response = await http.post(getUserWebHook,
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