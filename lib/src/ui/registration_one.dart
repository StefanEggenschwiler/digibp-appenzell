import 'package:digibp_appenzell/src/localisation/app_translation.dart';
import 'package:digibp_appenzell/src/models/ApplicationModel.dart';
import 'package:digibp_appenzell/src/blocs/GetApplicationBloc.dart';
import 'package:digibp_appenzell/src/ui/registration_two.dart';
import 'package:flutter/material.dart';
import 'dart:core';

class RegistrationOne extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RegistrationState();
  }
}

class RegistrationState extends State<RegistrationOne> {
  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  Application _application;

  @override
  Widget build(BuildContext context) {
    _application = new Application();
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

  var _currentStep = 0;
  String _ssn;

  Widget formUI() {
    return new Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 10),
          child: Stepper(
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
                      icon: Icon(Icons.cloud_done),
                      label: Text(AppTranslations.of(context).text('txt_ssn_validation')),
                      onPressed: _validateInputs,
                    )
                  ],
                ),
              );
            },
            steps: [
              new Step(
                // Title of the Step
                title: Text(AppTranslations.of(context).text('txt_step1')),
                // Content, it can be any widget here. Using basic Text for this example
                content: ListTile(
                  leading: const Icon(Icons.confirmation_number),
                  title: TextFormField(
                    decoration: InputDecoration(labelText: AppTranslations.of(context).text('lbl_ssn')),
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    validator: validateSSN,
                    onSaved: (String val) {
                      _ssn = val;
                    },
                  ),
                ),
                isActive: true,
                state: StepState.editing,
                subtitle: Text(AppTranslations.of(context).text('txt_ssn_enter')),
              ),
              new Step(
                title: Text(AppTranslations.of(context).text('txt_step2')),
                content: Text(''),
                isActive: false,
                state: StepState.disabled,
                subtitle: Text(AppTranslations.of(context).text('txt_personal_information')),
              ),
              new Step(
                title: Text(AppTranslations.of(context).text('txt_step3')),
                content: Text(''),
                isActive: false,
                state: StepState.disabled,
                subtitle: Text(AppTranslations.of(context).text('txt_case_information')),
              ),
              new Step(
                // Title of the Step
                title: Text(AppTranslations.of(context).text('txt_step4')),
                // Content, it can be any widget here. Using basic Text for this example
                content: ListTile(),
                isActive: false,
                state: StepState.disabled,
                subtitle: Text(AppTranslations.of(context).text('txt_face_captcha')),
              ),
              new Step(
                // Title of the Step
                title: Text(AppTranslations.of(context).text('txt_step5')),
                // Content, it can be any widget here. Using basic Text for this example
                content: ListTile(),
                isActive: false,
                state: StepState.disabled,
                subtitle: Text(AppTranslations.of(context).text('txt_finalise_submission')),
              ),],
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

  String validateSSN(String value) {
    var parsedSSN = value.replaceAll('.', '');
    if (parsedSSN.length < 13) {
      return AppTranslations.of(context).text('txt_ssn_error');
    } else {
      var checkDigit = _calculateCheckDigit(parsedSSN);
      if (num.tryParse(parsedSSN[12]) == checkDigit) {
        return null;
      } else {
        return AppTranslations.of(context).text('txt_ssn_error');
      }
    }
  }

  _calculateCheckDigit(String value) {
    num total = 0;

    for (var i = 0; i < 12; i += 1) {
      i.isEven
          ? total += num.parse(value[i])
          : total += num.parse(value[i]) * 3;
    }

    var expectedCheckDigit = 0;
    if (total % 10 != 0) {
      var roundTen = (total / 10).floor() * 10 + 10;
      expectedCheckDigit = roundTen - total;
    }
    return expectedCheckDigit;
  }

  void _validateInputs() {
    if (_formKey.currentState.validate()) {
      // If all data are correct then save data to out variables
      _formKey.currentState.save();
      _application.ahv = _ssn;
      debugPrint('Validation : $_application');

      bloc.getApplicationByAhv(_application.ahv);
      bloc.application.listen((data) {
        debugPrint('Move To Reg 2 : ${data.toString()}');
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return RegistrationTwo(data);
        }));
      });
    } else {
      // If all data are not valid then start auto validation.
      setState(() {
        _autoValidate = true;
      });
    }
  }
}
