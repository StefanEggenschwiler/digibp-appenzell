import 'package:digibp_appenzell/src/localisation/app_translation.dart';
import 'package:digibp_appenzell/src/ui/home.dart';
import 'package:digibp_appenzell/src/ui/registration_four.dart';
import 'package:digibp_appenzell/src/ui/registration_one.dart';
import 'package:digibp_appenzell/src/ui/status.dart';
import 'package:flutter/material.dart';
import '../app.dart';

import 'about.dart';

class NavDrawer extends StatelessWidget {
  String _widgetName;

  NavDrawer(String widgetName) {
    _widgetName = widgetName;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Image.asset('assets/images/rav.png'),
            decoration: BoxDecoration(color: Color(0xFFFF0000)),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text(AppTranslations.of(context).text('tab_main')),
            enabled: _widgetName == AppTranslations.of(context).text('tab_main') ? false : true,
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return Home();
              }));            },
          ),
          ExpansionTile(
            leading: Icon(Icons.account_balance),
            title: Text(AppTranslations.of(context).text('tab_application')),
            children: <Widget>[
              ListTile(
                leading: Text(''),
                title: Text(AppTranslations.of(context).text('tab_registration')),
                enabled: _widgetName == AppTranslations.of(context).text('tab_registration') ? false : true,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                    return RegistrationOne();
                  }));
                },
              ),
              ListTile(
                leading: Text(''),
                title: Text(AppTranslations.of(context).text('tab_status')),
                enabled: _widgetName == AppTranslations.of(context).text('tab_status') ? false : true,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                    return RegistrationFour(null);
                  }));
                },
              )
            ]
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text(AppTranslations.of(context).text('tab_about')),
            enabled: _widgetName == AppTranslations.of(context).text('tab_about') ? false : true,
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return About();
              }));
            },
          ),
          ExpansionTile(
            leading: Icon(Icons.language),
            title: Text(AppTranslations.of(context).text('tab_lang')),
            children: application.languagesMap.keys
                .map((data) => ListTile(
              title: Text(data),
              onTap: () {
                changeLanguage(data);
                },
            )).toList(),
          ),
        ],
      ),
    );
  }

  changeLanguage(String lang) {
    debugPrint('$lang - ' + application.languagesMap[lang]);
    application.onLocaleChanged(Locale(application.languagesMap[lang]));
  }
}
