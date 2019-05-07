import 'package:digibp_appenzell/src/models/AppStatusModel.dart';
import 'package:rxdart/rxdart.dart';
import 'package:digibp_appenzell/src/resources/ApplicationRepository.dart';
import 'package:flutter/material.dart';

class CaseStatusBloc {
  final _repository = ApplicationRepository();
  final _statusFetcher = PublishSubject<AppStatus>();

  Observable<AppStatus> get appStatus => _statusFetcher.stream;

  getCaseStatus(int caseId) async {
    AppStatus employers = await _repository.getStatus(caseId);
    _statusFetcher.sink.add(employers);
  }

  dispose() async {
    debugPrint('Await drain');
    await _statusFetcher.drain();
    debugPrint('Drained');
    _statusFetcher.close();
  }
}

final bloc = CaseStatusBloc();