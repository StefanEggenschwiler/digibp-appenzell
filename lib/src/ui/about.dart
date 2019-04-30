import 'package:digibp_appenzell/src/localisation/app_translation.dart';
import 'package:flutter/material.dart';

import 'nav_drawer.dart';

class About extends StatelessWidget {
  String _title = 'About';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(_title),
      appBar: new AppBar(
        title: new Text(_title),
      ),
      body: Text(AppTranslations.of(context).text('txt_about')),
    );
  }
}
