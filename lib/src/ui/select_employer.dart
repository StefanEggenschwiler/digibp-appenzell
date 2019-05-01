import 'package:digibp_appenzell/src/localisation/app_translation.dart';
import 'package:flutter/material.dart';

class EmployerSelection extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text(AppTranslations.of(context).text('tab_employer_selection')),
      ),
      body: Text(AppTranslations.of(context).text('txt_employer_selection')),
    );
  }
}
