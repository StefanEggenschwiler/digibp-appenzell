import 'package:digibp_appenzell/src/localisation/app_translation.dart';
import 'package:flutter/material.dart';
import '../application.dart';

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
            child: Text(
              AppTranslations.of(context).text('app_name'),
              style: TextStyle(color: Colors.white),
            ),
            decoration: BoxDecoration(color: Colors.blueAccent),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text(AppTranslations.of(context).text('tab_main')),
            enabled: _widgetName == AppTranslations.of(context).text('tab_main') ? false : true,
            onTap: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.monetization_on),
            title: Text(AppTranslations.of(context).text('tab_registration')),
            enabled: _widgetName == AppTranslations.of(context).text('tab_registration') ? false : true,
            onTap: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.announcement),
            title: Text(AppTranslations.of(context).text('tab_status')),
            enabled: _widgetName == AppTranslations.of(context).text('tab_status') ? false : true,
            onTap: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
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
          )
        ],
      ),
    );
  }

  changeLanguage(String lang) {
    debugPrint('$lang - ' + application.languagesMap[lang]);
    application.onLocaleChanged(Locale(application.languagesMap[lang]));
  }
}
