import 'package:digibp_appenzell/src/models/ApplicationModel.dart';
import 'package:rxdart/rxdart.dart';
import 'package:digibp_appenzell/src/resources/ApplicationRepository.dart';
import 'package:flutter/material.dart';

class GetApplicationBloc {
  final _repository = ApplicationRepository();
  final _applicationFetcher = PublishSubject<Application>();

  Observable<Application> get application => _applicationFetcher.stream;

  getApplicationByAhv(String ahv) async {
    Application application = await _repository.getByAHV(ahv);
    _applicationFetcher.sink.add(application);
  }

  dispose() async {
    debugPrint('Await drain');
    await _applicationFetcher.drain();
    debugPrint('Drained');
    _applicationFetcher.close();
  }
}

final bloc = GetApplicationBloc();