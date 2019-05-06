import 'package:digibp_appenzell/src/blocs/EmployerListBloc.dart';
import 'package:digibp_appenzell/src/localisation/app_translation.dart';
import 'package:digibp_appenzell/src/model/ApplicationModel.dart';
import 'package:digibp_appenzell/src/model/EmployerModel.dart';
import 'package:digibp_appenzell/src/ui/registration_four.dart';
import 'package:flutter/material.dart';
import 'dart:core';

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
                content: buildAutoTextView(),
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

  buildAutoTextView() {
    return StreamBuilder(
        stream: bloc.allEmployers,
        builder: (BuildContext context, AsyncSnapshot<List<Employer>> snapshot) {
          if (snapshot.hasData) {
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

  void _validateInputs() {
    if (_selected != null) {
      // If all data are correct then save data to out variables
      _formKey.currentState.save();
      _application.employerId = _selected.id;
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
