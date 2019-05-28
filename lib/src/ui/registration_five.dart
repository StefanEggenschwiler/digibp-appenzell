import 'package:digibp_appenzell/src/localisation/app_translation.dart';
import 'package:digibp_appenzell/src/models/ApplicationModel.dart';
import 'package:digibp_appenzell/src/blocs/SubmitApplicationBloc.dart';
import 'package:digibp_appenzell/src/ui/home.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegistrationFive extends StatefulWidget {

  Application _application;

  RegistrationFive(Application application) {
    _application = application;
  }

  @override
  State<StatefulWidget> createState() {
    return RegistrationState(_application);
  }
}

class RegistrationState extends State<RegistrationFive> {
  final _formKey = GlobalKey<FormState>();
  Application _application;

  RegistrationState(Application application) {
    _application = application;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: Text(AppTranslations.of(context).text('tab_status')),
      ),
      body: new Form(
        key: _formKey,
        child: formUI(),
      ),
    );
  }

  Widget formUI() {
    return new Column(
        children: <Widget>[
          new Container(
            margin: const EdgeInsets.only(top: 20),
            child: Text(
              AppTranslations.of(context).text('txt_application_submission'),
              textAlign: TextAlign.center,
              overflow: TextOverflow.clip,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          RaisedButton.icon(
            icon: Icon(Icons.search),
            label: Text(AppTranslations.of(context).text('lbl_submit_case')),
            onPressed: () {
              bloc.insertCase(_application).then((success) {
                debugPrint('Application Submitted: $success');
                if(success) {
                  Fluttertoast.showToast(
                      msg: AppTranslations.of(context).text('txt_application_created'),
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIos: 5,
                      backgroundColor: Colors.grey,
                      textColor: Colors.white);
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                    return Home();
                  }));
                } else {
                  Fluttertoast.showToast(
                      msg: AppTranslations.of(context).text('txt_application_error'),
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIos: 5,
                      backgroundColor: Colors.grey,
                      textColor: Colors.white);
                }
              });
            },
          ),
        ]);
  }
}
