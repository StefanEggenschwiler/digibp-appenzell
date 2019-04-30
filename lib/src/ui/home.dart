import 'package:digibp_appenzell/src/localisation/app_translation.dart';
import 'package:digibp_appenzell/src/ui/nav_drawer.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
}

class HomeState extends State<Home> {
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
    return Scaffold(
      drawer: NavDrawer(AppTranslations.of(context).text('tab_main')),
      appBar: AppBar(title: Text(AppTranslations.of(context).text('tab_main'))),
      body: new Container(height: 0, width: 0),
    );
  }
}
