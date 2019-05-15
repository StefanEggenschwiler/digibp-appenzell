import 'package:digibp_appenzell/src/models/AppStatusModel.dart';
import 'package:digibp_appenzell/src/models/ApplicationModel.dart';
import 'package:digibp_appenzell/src/models/EmployerModel.dart';
import 'package:digibp_appenzell/src/resources/ApplicationProvider.dart';

class ApplicationRepository {

  Future<int> insertUpdateUser(Application application) => ApplicationProvider.api.insertUpdateUser(application);

  Future<void> insertCase(Application application) => ApplicationProvider.api.insertCase(application);

  Future<AppStatus> getStatus(int applicationId) => ApplicationProvider.api.getStatus(applicationId);

  Future<Application> getByAHV(String ahv) => ApplicationProvider.api.getByAHV(ahv);

  Future<List<Employer>> getAllEmployers() => ApplicationProvider.api.getAllEmployers();
}