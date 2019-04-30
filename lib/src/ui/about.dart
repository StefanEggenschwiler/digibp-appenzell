import 'package:digibp_appenzell/src/localisation/app_translation.dart';
import 'package:flutter/material.dart';

import 'nav_drawer.dart';

class About extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(AppTranslations.of(context).text('tab_about')),
      appBar: new AppBar(
        title: new Text(AppTranslations.of(context).text('tab_about')),
      ),
      body: Text(AppTranslations.of(context).text('txt_about')),
    );
  }
}
