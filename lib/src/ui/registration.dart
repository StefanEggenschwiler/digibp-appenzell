import 'package:digibp_appenzell/src/localisation/app_translation.dart';
import 'package:flutter/material.dart';

import 'nav_drawer.dart';

class Registration extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return RegistrationState();
  }
}

class RegistrationState extends State<Registration> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppTranslations.of(context).text('tab_registration')),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 10),
                child: Stepper(
                  steps: [
                    Step(
                      title: Text("First"),
                      subtitle: Text("This is our first article"),
                      content: Text(
                          "In this article, I will tell you how to create a page."),
                    ),
                    Step(
                        title: Text("Second"),
                        subtitle: Text("Constructor"),
                        content: Text("Let's look at its construtor."),
                        state: StepState.editing,
                        isActive: true),
                    Step(
                        title: Text("Third"),
                        subtitle: Text("Constructor"),
                        content: Text("Let's look at its construtor."),
                        state: StepState.error),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
