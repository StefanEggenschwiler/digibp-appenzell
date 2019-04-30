import 'package:digibp_appenzell/src/localisation/app_translation.dart';
import 'package:digibp_appenzell/src/ui/nav_drawer.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
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
