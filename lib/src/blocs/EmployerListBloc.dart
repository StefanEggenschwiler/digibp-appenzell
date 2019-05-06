import 'package:digibp_appenzell/src/model/EmployerModel.dart';
import 'package:rxdart/rxdart.dart';
import 'package:digibp_appenzell/src/resources/ApplicationRepository.dart';
import 'package:flutter/material.dart';

class EmployersBloc {
  final _repository = ApplicationRepository();
  final _employersFetcher = PublishSubject<List<Employer>>();

  Observable<List<Employer>> get allEmployers => _employersFetcher.stream;

  getAllEmployers() async {
    List<Employer> employers = await _repository.getAllEmployers();
    _employersFetcher.sink.add(employers);
  }

  dispose() async {
    debugPrint('Await drain');
    await _employersFetcher.drain();
    debugPrint('Drained');
    _employersFetcher.close();
  }
}

final bloc = EmployersBloc();