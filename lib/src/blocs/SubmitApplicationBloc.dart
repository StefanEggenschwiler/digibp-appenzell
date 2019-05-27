import 'package:digibp_appenzell/src/models/ApplicationModel.dart';
import 'package:digibp_appenzell/src/resources/ApplicationRepository.dart';

class SubmitApplicationBloc {
  final _repository = ApplicationRepository();

  Future<int> insertUpdateUser(Application application) async {
    return _repository.insertUpdateUser(application);
  }

  Future<bool> insertCase(Application application) async {
    return _repository.insertCase(application);
  }
}

final bloc = SubmitApplicationBloc();