import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trashpick/Models/user_model.dart';
import 'package:trashpick/Pages/BottomNavBar/Settings/give_feedback_page.dart';
import 'package:trashpick/Widgets/button_widgets.dart';
import 'package:trashpick/Widgets/image_frames_widgets.dart';
import '../../../Widgets/primary_app_bar_widget.dart';
import '../../../Widgets/alert_dialogs.dart';
import '../../../Widgets/change_theme_button_widget.dart';
import '../../../Theme/theme_provider.dart';
import 'profile_info_page.dart';
import 'settings_user_guide.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final userReference = FirebaseFirestore.instance.collection('Users');
  final FirebaseAuth auth = FirebaseAuth.instance;
  String hashTags = "#TideTunersPlasticChallage #BetterWorldFramework #Scouts";

  profileHeader() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("Users")
          .where('uuid', isEqualTo: "${auth.currentUser.uid}")
          .snapshots(),
      builder: (context, dataSnapshot) {
        if (!dataSnapshot.hasData) {
          return Text(
            "Hi! ",
            style: TextStyle(
                fontSize: Theme.of(context).textTheme.headline6.fontSize,
                fontWeight: FontWeight.bold),
          );
        } else {
          UserModelClass userModelClass =
              UserModelClass.fromDocument(dataSnapshot.data.docs[0]);
          return Row(
            children: [
              ImageFramesWidgets().userProfileFrame(
                  userModelClass.profileImage, 90.0, 36.0, true),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${userModelClass.name}",
                    style: TextStyle(
                        fontSize:
                            Theme.of(context).textTheme.headline6.fontSize,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "${userModelClass.accountType}",
                    style: TextStyle(
                        fontSize:
                            Theme.of(context).textTheme.subtitle1.fontSize,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          );
        }
      },
    );
  }

  aboutUsTitle() {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(
        Icons.info_outline_rounded,
        color: Theme.of(context).iconTheme.color,
      ),
      SizedBox(
        width: 10.0,
      ),
      Text("About Us",
          style: TextStyle(
            fontSize: Theme.of(context).textTheme.button.fontSize,
            color: Theme.of(context).textTheme.button.color,
            fontWeight: FontWeight.bold,
          ))
    ]);
  }

  aboutUsContainer() {
    return Column(
      children: [
        Text(
          hashTags,
          style: TextStyle(
              fontSize: Theme.of(context).textTheme.caption.fontSize,
              fontWeight: FontWeight.bold,
              color: AppThemeData().deepBlueColor),
        ),
        SizedBox(
          height: 10.0,
        ),
        Image.asset(
          'assets/images/about_banner_1.png',
          width: MediaQuery.of(context).size.width,
        ),
        SizedBox(
          height: 5.0,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeText =
        Provider.of<ThemeProvider>(context).themeMode == ThemeMode.light
            ? 'Light Theme'
            : 'Dark Theme';
    final IconData themeIcon =
        Provider.of<ThemeProvider>(context).themeMode == ThemeMode.light
            ? Icons.wb_sunny_rounded
            : Icons.nightlight_round;

    return Scaffold(
      appBar: PrimaryAppBar(
        title: "Settings",
        appBar: AppBar(),
        widgets: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
            child: Icon(
              Icons.settings_rounded,
              color: Theme.of(context).iconTheme.color,
              size: 35.0,
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                profileHeader(),
                SizedBox(
                  height: 20.0,
                ),
                TextWithIconButtonWidget(
                  text: "Sign Out",
                  icon: Icons.logout,
                  iconToLeft: true,
                  onClicked: () => SignOutAlertDialog().showAlert(context),
                ),
                SizedBox(
                  height: 5.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(themeIcon),
                        SizedBox(
                          width: 10.0,
                        ),
                        Text(
                          "$themeText",
                          style: TextStyle(
                              fontSize:
                                  Theme.of(context).textTheme.button.fontSize,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    ChangeThemeButtonWidget(),
                  ],
                ),
                SizedBox(
                  height: 5.0,
                ),
                TextWithIconButtonWidget(
                  text: "Profile Info",
                  icon: Icons.account_circle_rounded,
                  iconToLeft: true,
                  onClicked: () {
                    print('Switch to Profile Info');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProfileInfoPage()),
                    );
                  },
                ),
                SizedBox(
                  height: 15.0,
                ),
                TextWithIconButtonWidget(
                  text: "User Guide",
                  icon: Icons.assistant_rounded,
                  iconToLeft: true,
                  onClicked: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SettingsUserGuide()),
                    );
                  },
                ),
                SizedBox(
                  height: 15.0,
                ),
                TextWithIconButtonWidget(
                  text: "Give Feedback",
                  icon: Icons.feedback_rounded,
                  iconToLeft: true,
                  onClicked: () {
                    print('Switch to Give Feedback');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => GiveFeedbackPage()),
                    );
                  },
                ),
                SizedBox(
                  height: 15.0,
                ),
                aboutUsTitle(),
                SizedBox(
                  height: 15.0,
                ),
                aboutUsContainer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
