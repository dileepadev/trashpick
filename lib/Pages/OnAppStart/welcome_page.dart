import 'package:flutter/material.dart';
import 'package:trashpick/Pages/OnAppStart/sign_in_page.dart';
import 'package:trashpick/Pages/OnAppStart/sign_up_page.dart';
import '../../Theme/theme_provider.dart';
import '../../Widgets/button_widgets.dart';
import 'user_guide.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppThemeData().whiteColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 40),
                  Image.asset(
                    'assets/logos/trashpick_logo_banner_2.png',
                    height: 250,
                    width: 250,
                  ),
                  SizedBox(height: 30),
                  new ButtonWithImageWidget(
                    onClicked: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => SignInPage()),
                        (Route<dynamic> route) => false,
                      );
                      print("Switch to Continue with Email");
                    },
                    text: "Continue with Email",
                    textColor: Colors.white,
                    image: 'assets/icons/icon_email.png',
                    color: AppThemeData().secondaryColor,
                  ),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("New to TrashPick ?",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          )),
                      SizedBox(width: 10),
                      new RadiusFlatButtonWidget(
                        text: "Sign Up",
                        onClicked: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UserGuidePage()),
                            (Route<dynamic> route) => false,
                          );
                          print("Switch to Sign Up");
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
