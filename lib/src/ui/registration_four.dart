import 'package:digibp_appenzell/src/localisation/app_translation.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:core';


class RegistrationFour extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RegistrationState();
  }
}

class RegistrationState extends State<RegistrationFour> {
  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;

  final FocusNode _firstNameFocus = FocusNode();
  final FocusNode _lastNameFocus = FocusNode();
  final FocusNode _birthDateFocus = FocusNode();
  final FocusNode _addressFocus = FocusNode();
  final FocusNode _zipCodeFocus = FocusNode();
  final FocusNode _cityFocus = FocusNode();
  final FocusNode _countryFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();


  String _firstName;
  String _lastName;
  DateTime _birthDate;
  String _address;
  int _zipCode;
  String _city;
  String _country;
  String _email;
  String _phone;

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

  var _currentStep = 1;

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
                    _currentStep == 1
                        ?
                    RaisedButton.icon(
                      icon: Icon(Icons.navigate_next),
                      onPressed: onStepContinue,
                      label: Text(AppTranslations.of(context).text('txt_next')),
                    )
                        :
                    RaisedButton.icon(
                      icon: Icon(Icons.save_alt),
                      onPressed: _validateInputs,
                      label: Text(AppTranslations.of(context).text('txt_submit')),
                    ),
                    _currentStep > 1 // this is the last step
                        ?
                    FlatButton.icon(
                      icon: Icon(Icons.arrow_back),
                      label: Text(AppTranslations.of(context).text('txt_cancel')),
                      onPressed: onStepCancel,
                    )
                        :
                    Container(width: 0, height: 0,),
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
                content: ListTile(),
                isActive: false,
                state: StepState.complete,
                subtitle: Text(AppTranslations.of(context).text('txt_case_information')),
              ),
              new Step(
                title: Text(AppTranslations.of(context).text('txt_step4')),
                content: ListTile(),
                isActive: false,
                state: StepState.editing,
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

  void _fieldFocusChange(context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  String validateEmpty(String value) {
    if (value.isEmpty)
      return AppTranslations.of(context).text('txt_text_error');
    else
      return null;
  }

  String validateZipCode(String value) {
    if (num.tryParse(value) == null)
      return AppTranslations.of(context).text('txt_zip_code_error');
    else
      return null;
  }

  String validateCity(String value) {
    return null;
  }

  String validateBirthDate(DateTime value) {
    return null;
  }

  String validateCountry(String value) {
    return null;
  }

  String validatePhone(String value) {}

  String validateEmail(String value) {
    if (!EmailValidator.validate(value))
      return AppTranslations.of(context).text('txt_email_error');
    else
      return null;
  }

  void _validateInputs() {
    if (_formKey.currentState.validate()) {
      // If all data are correct then save data to out variables
      _formKey.currentState.save();
      debugPrint('Validation OK');
      debugPrint('$_firstName - $_lastName - $_birthDate - $_address - $_zipCode - $_city - $_country - $_email - $_phone');
      Fluttertoast.showToast(
          msg: AppTranslations.of(context).text('txt_case_submitted'),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white);
      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        return null;
      }));
    } else {
      // If all data are not valid then start auto validation.
      setState(() {
        _autoValidate = true;
      });
    }
  }
}
