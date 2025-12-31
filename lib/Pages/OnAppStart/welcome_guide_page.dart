import 'package:flutter/material.dart';
import '../../Pages/BottomNavBar/bottom_nav_bar.dart';
import '../../Theme/theme_provider.dart';
import '../../Widgets/button_widgets.dart';

class WelcomeGuidePage extends StatefulWidget {
  final String userName, accountTypeName;

  WelcomeGuidePage(this.userName, this.accountTypeName);

  @override
  _WelcomeGuidePageState createState() => _WelcomeGuidePageState();
}

class _WelcomeGuidePageState extends State<WelcomeGuidePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppThemeData().whiteColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Hi " + widget.userName,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize:
                                Theme.of(context).textTheme.headline5.fontSize,
                            fontWeight: FontWeight.bold)
                        .copyWith(color: Colors.grey.shade900)),
                SizedBox(
                  height: 50.0,
                ),
                Image.asset(
                  'assets/logos/trashpick_logo_banner.png',
                  height: 200.0,
                  width: 200.0,
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text("Welcome to TrashPick",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontFamily: 'Montserrat', fontSize: 18.0)
                        .copyWith(color: Colors.grey.shade900)),
                SizedBox(
                  height: 100.0,
                ),
                new ButtonWidget(
                  color: AppThemeData().secondaryColor,
                  textColor: AppThemeData().whiteColor,
                  text: "Continue to Home",
                  onClicked: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) =>
                            BottomNavBar(widget.accountTypeName),
                      ),
                      (route) => false,
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
