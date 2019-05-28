import 'package:digibp_appenzell/src/localisation/app_translation.dart';
import 'package:digibp_appenzell/src/models/ApplicationModel.dart';
import 'package:digibp_appenzell/src/ui/registration_three.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:core';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:digibp_appenzell/src/blocs/SubmitApplicationBloc.dart';
import 'package:country_code_picker/country_code_picker.dart';

import 'package:intl/intl.dart';

class RegistrationTwo extends StatefulWidget {

  Application _application;

  RegistrationTwo(Application application) {
    _application = application;
  }

  @override
  State<StatefulWidget> createState() {
    return RegistrationState(_application);
  }
}

class RegistrationState extends State<RegistrationTwo> {
  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  Application _application;

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
  String _gender;
  DateTime _birthDate;
  String _address;
  int _zipCode;
  String _city;
  String _citizenship;
  String _email;
  String _phone;

  RegistrationState(Application application) {
    _application = application;
  }

  @override
  void initState() {
    super.initState();
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
                    RaisedButton.icon(
                      icon: Icon(Icons.navigate_next),
                      onPressed: _validateInputs,
                      label: Text(AppTranslations.of(context).text('txt_next')),
                    )
                  ],
                ),
              );
            },
            steps: [
              new Step(
                title: Text(AppTranslations.of(context).text('txt_step1')),
                content: ListTile(),
                isActive: false,
                state: StepState.complete,
                subtitle: Text(AppTranslations.of(context).text('txt_ssn_enter')),
              ),
              new Step(
                title: Text('Step 2'),
                content: new Column(
                  children: generateForm(),
                ),
                state: StepState.editing,
                isActive: true,
                subtitle: Text(AppTranslations.of(context).text('txt_personal_information')),
              ),
              new Step(
                title: Text(AppTranslations.of(context).text('txt_step3')),
                content: ListTile(),
                isActive: false,
                state: StepState.disabled,
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

    forms.add(new ListTile(
        leading: const Icon(Icons.person),
        title: new TextFormField(
          initialValue: _application.firstName != null ? _application.firstName : '',
          decoration: InputDecoration(labelText: AppTranslations.of(context).text('lbl_fname')),
          keyboardType: TextInputType.text,
          focusNode: _firstNameFocus,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (term) {
            _fieldFocusChange(context, _firstNameFocus, _lastNameFocus);
          },
          validator: validateEmpty,
          onSaved: (String val) {
            _firstName = val;
          },
        )));
    forms.add(new ListTile(
        leading: new Text(''),
        title: new TextFormField(
          initialValue: _application.lastName != null ? _application.lastName : '',
          decoration: InputDecoration(labelText: AppTranslations.of(context).text('lbl_lname')),
          keyboardType: TextInputType.text,
          focusNode: _lastNameFocus,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (term) {
            _fieldFocusChange(context, _lastNameFocus, _birthDateFocus);
          },
          validator: validateEmpty,
          onSaved: (String val) {
            _lastName = val;
          },
        )));
    forms.add(new ListTile(
      leading: new Text(''),
      title: new Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          new Radio(
            value: 'male',
            groupValue: _gender,
            onChanged: _radioButtonChanges,
          ),
          new Text(
            AppTranslations.of(context).text('lbl_male'),
            style: new TextStyle(fontSize: 16.0),
          ),
          new Radio(
            value: 'female',
            groupValue: _gender,
            onChanged: _radioButtonChanges,
          ),
          new Text(
            AppTranslations.of(context).text('lbl_female'),
            style: new TextStyle(
              fontSize: 16.0,
            ),
          )
        ],
      ),
    ));
    forms.add(new ListTile(
        leading: const Icon(Icons.date_range),
        title: DateTimePickerFormField(
          initialValue: _application.birthDate != null ? _application.birthDate : null,
          inputType: InputType.date,
          format: DateFormat('yyyy-MM-dd'),
          editable: true,
          focusNode: _birthDateFocus,
          onFieldSubmitted: (term) {
            _fieldFocusChange(context, _birthDateFocus, _addressFocus);
          },
          initialDate: new DateTime(2000),
          decoration: InputDecoration(
              labelText: AppTranslations.of(context).text('lbl_bdate'), hasFloatingPlaceholder: false),
          validator: validateBirthDate,
          onSaved: (DateTime val) {
            _birthDate = val;
          },
        )));
    forms.add(new ListTile(
        leading: const Icon(Icons.home),
        title: new TextFormField(
          initialValue: _application.address != null ? _application.address : '',
          decoration: InputDecoration(labelText: AppTranslations.of(context).text('lbl_address')),
          keyboardType: TextInputType.text,
          focusNode: _addressFocus,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (term) {
            _fieldFocusChange(context, _addressFocus, _zipCodeFocus);
          },
          validator: validateEmpty,
          onSaved: (String val) {
            _address = val;
          },
        )));
    forms.add(new ListTile(
        leading: new Text(''),
        title: new TextFormField(
          initialValue: _application.zipCode != null ? _application.zipCode.toString() : '',
          decoration: InputDecoration(labelText: AppTranslations.of(context).text('lbl_zip_code')),
          keyboardType: TextInputType.numberWithOptions(signed: false, decimal: false),
          focusNode: _zipCodeFocus,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (term) {
            _fieldFocusChange(context, _zipCodeFocus, _cityFocus);
          },
          validator: validateZipCode,
          onSaved: (String val) {
            _zipCode = num.parse(val);
          },
        )));
    forms.add(new ListTile(
        leading: const Icon(Icons.location_city),
        title: new TextFormField(
          initialValue: _application.city != null ? _application.city : '',
          decoration: InputDecoration(labelText: AppTranslations.of(context).text('lbl_city')),
          keyboardType: TextInputType.text,
          focusNode: _cityFocus,
          textInputAction: TextInputAction.next,
          validator: validateCity,
          onSaved: (String val) {
            _city = val;
          },
        )));
    forms.add(new ListTile(
        leading: const Icon(Icons.flag),
        title: new CountryCodePicker(
          onChanged: (countryCode) {
            _citizenship = countryCode.toString();
          },
          initialSelection: 'CH',
          showCountryOnly: true,
        ),

      /*new TextFormField(
          initialValue: _application.citizenship != null ? _application.citizenship : '',
          decoration: InputDecoration(labelText: AppTranslations.of(context).text('lbl_country')),
          keyboardType: TextInputType.text,
          focusNode: _countryFocus,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (term) {
            _fieldFocusChange(context, _countryFocus, _emailFocus);
          },
          validator: validateCountry,
          onSaved: (String val) {
            _citizenship = val;
          },
        )*/));
    forms.add(new ListTile(
        leading: const Icon(Icons.email),
        title: new TextFormField(
          initialValue: _application.email != null ? _application.email : '',
          decoration: InputDecoration(labelText: AppTranslations.of(context).text('lbl_email')),
          keyboardType: TextInputType.emailAddress,
          focusNode: _emailFocus,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (term) {
            _fieldFocusChange(context, _emailFocus, _phoneFocus);
          },
          validator: validateEmail,
          onSaved: (String val) {
            _email = val;
          },
        )));
    forms.add(new ListTile(
        leading: const Icon(Icons.phone),
        title: new TextFormField(
          initialValue: _application.phone != null ? _application.phone : '',
          decoration: InputDecoration(labelText: AppTranslations.of(context).text('lbl_phone')),
          keyboardType: TextInputType.phone,
          focusNode: _phoneFocus,
          textInputAction: TextInputAction.done,
          validator: validatePhone,
          onSaved: (String val) {
            _phone = val;
          },
        )));

    return forms;
  }

  void _radioButtonChanges(String value) {
    setState(() {
      _gender = value;
      debugPrint(_gender); //Debug the choice in console
    });
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

  String validatePhone(String value) {
    return null;
  }

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
      _application.firstName = _firstName;
      _application.lastName = _lastName;
      _application.birthDate = _birthDate;
      _application.address = _address;
      _application.zipCode = _zipCode;
      _application.city = _city;
      _application.citizenship = _citizenship;
      _application.email = _email;
      _application.phone = _phone;
      _application.gender = _gender;

      debugPrint('Validation : $_application');

      bloc.insertUpdateUser(_application).then((id) {
        debugPrint('Move To Reg 3 : ${id.toString()}');
        if(id > 0) _application.id = id;
        Fluttertoast.showToast(
            msg: id > 0 ? AppTranslations.of(context).text('txt_user_created') : AppTranslations.of(context).text('txt_user_updated'),
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 2,
            backgroundColor: Colors.grey,
            textColor: Colors.white);
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return RegistrationThree(_application);
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
