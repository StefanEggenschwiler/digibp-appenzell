import 'package:digibp_appenzell/src/blocs/CaseStatusBloc.dart';
import 'package:digibp_appenzell/src/localisation/app_translation.dart';
import 'package:flutter/material.dart';
import '../models/AppStatusModel.dart';

class RetrieveStatus extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return RetrieveStatusState();
  }
}

class RetrieveStatusState extends State<RetrieveStatus> {
  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;

  final FocusNode _caseIdFocus = FocusNode();

  int _caseId;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    bloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: Text(AppTranslations.of(context).text('tab_status')),
      ),
      body: new Form(
        key: _formKey,
        autovalidate: _autoValidate,
        child: formUI(),
      ),
    );
  }

  Widget formUI() {
    return new Column(
        children: <Widget>[
          new ListTile(
              leading: const Icon(Icons.folder_shared),
              title: new TextFormField(
                decoration: InputDecoration(labelText: AppTranslations.of(context).text('lbl_case_id')),
                keyboardType: TextInputType.numberWithOptions(decimal: false, signed: false),
                focusNode: _caseIdFocus,
                textInputAction: TextInputAction.done,
                validator: validateCaseId,
                onSaved: (String val) {
                  _caseId = int.parse(val);
                },
              )),
          RaisedButton.icon(
            icon: Icon(Icons.search),
            label: Text(AppTranslations.of(context).text('lbl_search_case')),
            onPressed: _validateInputs,
          ),
          generateStatus()
        ]);
  }

  Widget generateStatus() {
    return StreamBuilder(
      stream: bloc.appStatus,
      builder: (BuildContext context, AsyncSnapshot<AppStatus> snapshot) {
        if(snapshot.hasData) {
          if (snapshot.data.status == "NOT FOUND") {
            return new Text('Unable to find an application with this id!', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),);
          } else {
            return new Text('Your application\'s status is: ${snapshot.data.status}!', style: TextStyle(fontWeight: FontWeight.bold));
          }
        } else {
          return new Container(width: 0.0, height: 0.0);
        }
      }
    );
  }

  String validateCaseId(String value) {
    if (value.isEmpty || int.tryParse(value) == null)
      return AppTranslations.of(context).text('txt_error_case_id');
    else
      return null;
  }

  void _validateInputs() {
    if (_formKey.currentState.validate()) {
      // If all data are correct then save data to out variables
      _formKey.currentState.save();
      debugPrint('Retrieve Status Validation : $_caseId');
      bloc.getCaseStatus(_caseId);
    } else {
      // If all data are not valid then start auto validation.
      setState(() {
        _autoValidate = true;
      });
    }
  }
}
