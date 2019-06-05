import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:digibp_appenzell/src/blocs/EmployerListBloc.dart';
import 'package:digibp_appenzell/src/localisation/app_translation.dart';
import 'package:digibp_appenzell/src/models/ApplicationModel.dart';
import 'package:digibp_appenzell/src/models/EmployerModel.dart';
import 'package:digibp_appenzell/src/ui/registration_four.dart';
import 'package:flutter/material.dart';
import 'dart:core';

import 'package:intl/intl.dart';

class RegistrationThree extends StatefulWidget {
  Application _application;

  RegistrationThree(Application application) {
    _application = application;
  }

  @override
  State<StatefulWidget> createState() {
    return RegistrationState(_application);
  }
}

class RegistrationState extends State<RegistrationThree> {
  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  Application _application;

  Employer _selected;
  DateTime _workpermitDate;
  DateTime _unemploymentDate;

  final FocusNode _workpermitDateFocus = FocusNode();
  final FocusNode _unemploymentDateFocus = FocusNode();
  final FocusNode _employerSelectionFocus = FocusNode();

  RegistrationState(Application application) {
    _application = application;
  }

  @override
  void initState() {
    bloc.getAllEmployers();
    super.initState();
  }

  @override
  void dispose() {
    //bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppTranslations.of(context).text('tab_registration')),
        ),
        body: SingleChildScrollView(
            child: new Form(
              key: _formKey,
              autovalidate: _autoValidate,
              child: formUI(),
            )));
  }

  var _currentStep = 2;

  Widget formUI() {
    return new Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 10),
          child: Stepper(
            physics: ClampingScrollPhysics(),
            type: StepperType.vertical,
            currentStep: _currentStep,
            controlsBuilder:
                (BuildContext context, {VoidCallback onStepContinue, VoidCallback onStepCancel}) {
              return Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    RaisedButton.icon(
                      icon: Icon(Icons.navigate_next),
                      label: Text(AppTranslations.of(context).text('txt_next')),
                      onPressed: _validateInputs,
                    ),
                    FlatButton.icon(
                      icon: Icon(Icons.navigate_before),
                      label: Text(AppTranslations.of(context).text('txt_cancel')),
                      onPressed: onStepCancel,
                    ),
                  ],
                ),
              );
            },
            steps: [
              new Step(
                // Title of the Step
                title: Text(AppTranslations.of(context).text('txt_step1')),
                // Content, it can be any widget here. Using basic Text for this example
                content: ListTile(),
                isActive: false,
                state: StepState.complete,
                subtitle: Text(AppTranslations.of(context).text('txt_ssn_enter')),
              ),
              new Step(
                // Title of the Step
                title: Text(AppTranslations.of(context).text('txt_step2')),
                // Content, it can be any widget here. Using basic Text for this example
                content: ListTile(),
                isActive: false,
                state: StepState.complete,
                subtitle: Text(AppTranslations.of(context).text('txt_personal_information')),
              ),
              new Step(
                title: Text(AppTranslations.of(context).text('txt_step3')),
                content: new Column(
                  children: generateForm(),
                ),
                isActive: true,
                state: StepState.editing,
                subtitle: Text(AppTranslations.of(context).text('txt_case_information')),
              ),
              new Step(
                title: Text(AppTranslations.of(context).text('txt_step4')),
                content: ListTile(),
                isActive: false,
                state: StepState.disabled,
                subtitle: Text(AppTranslations.of(context).text('txt_face_captcha')),
              ),
              new Step(
                title: Text(AppTranslations.of(context).text('txt_step5')),
                content: ListTile(),
                isActive: false,
                state: StepState.disabled,
                subtitle: Text(AppTranslations.of(context).text('txt_finalise_submission')),
              ),
            ],
            onStepCancel: () {
              // On hitting cancel button, change the state
              setState(() {
                // update the variable handling the current step value
                // going back one step i.e subtracting 1, until its 0
                if (_currentStep > 0) {
                  _currentStep = _currentStep - 1;
                } else {
                  _currentStep = 0;
                }
              });
              // Log function call
              debugPrint('onStepCancel : $_currentStep');
            },
            onStepContinue: () {
              setState(() {
                // update the variable handling the current step value
                // going back one step i.e adding 1, until its the length of the step
                if (_currentStep < 2) {
                  _currentStep = _currentStep + 1;
                }
              });
              // Log function call
              debugPrint('onStepContinue : $_currentStep');
            },
          ),
        ),
      ],
    );
  }

  generateForm() {
    List<Widget> forms = new List();

    forms.add(buildAutoTextView());

    forms.add(new ListTile(
        leading: const Icon(Icons.date_range),
        title: DateTimePickerFormField(
          inputType: InputType.date,
          format: DateFormat('yyyy-MM-dd'),
          editable: true,
          focusNode: _unemploymentDateFocus,
          onFieldSubmitted: (term) {
            _application.citizenship != 'CH' ?
            _fieldFocusChange(context, _unemploymentDateFocus, _workpermitDateFocus) : true;
          },
          initialDate: new DateTime(2019),
          decoration: InputDecoration(
              labelText: AppTranslations.of(context).text('lbl_unemployment'), hasFloatingPlaceholder: false),
          validator: validateBirthDate,
          onSaved: (DateTime val) {
            _unemploymentDate = val;
          },
        )));

    if (_application.citizenship != 'CH') {
      debugPrint('CITIZENSHIP NOT CH! ' + _application.citizenship);
      debugPrint(_application.toString());
      forms.add(new ListTile(
          leading: const Icon(Icons.date_range),
          title: DateTimePickerFormField(
            inputType: InputType.date,
            format: DateFormat('yyyy-MM-dd'),
            editable: true,
            focusNode: _workpermitDateFocus,
            initialDate: new DateTime(2019),
            decoration: InputDecoration(
                labelText: AppTranslations.of(context).text('lbl_workpermit'), hasFloatingPlaceholder: false),
            validator: validateBirthDate,
            onSaved: (DateTime val) {
              _workpermitDate = val;
            },
          )));
    }
    return forms;
  }

  buildAutoTextView() {
    return StreamBuilder(
        stream: bloc.allEmployers,
        builder: (BuildContext context, AsyncSnapshot<List<Employer>> snapshot) {
          if (snapshot.hasData) {
            debugPrint(snapshot.data.toString());
            return new DropdownButton<Employer>(
              value: _selected,
              items: snapshot.data.map<DropdownMenuItem<Employer>>((Employer value) {
                return DropdownMenuItem<Employer>(
                  value: value,
                  child: Text(value.name),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  debugPrint('$value');
                  _selected = value;
                });
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        }
    );
  }

  void _fieldFocusChange(context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  String validateBirthDate(DateTime value) {
    return null;
  }

  void _validateInputs() {
    if (_selected != null) {
      // If all data are correct then save data to out variables
      _formKey.currentState.save();
      _application.employerId = _selected.id;
      _application.dateOfUnemployment = _unemploymentDate;
      _application.dateOfWorkpermit = _workpermitDate;
      debugPrint('Move To Reg 4 : ${_selected.id}');
      debugPrint('Validation OK: $_application');
      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        return RegistrationFour(_application);
      }));
    } else {
      // If all data are not valid then start auto validation.
      setState(() {
        _autoValidate = true;
      });
    }
  }
}
