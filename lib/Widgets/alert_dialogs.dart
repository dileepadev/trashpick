import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:trashpick/Pages/OnAppStart/welcome_page.dart';
import 'package:trashpick/Widgets/toast_messages.dart';

class SignOutAlertDialog {
  void showAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm for Sign Out'),
          content: Text("Are You Sure Want To Sign Out ?"),
          actions: <Widget>[
            TextButton(
              child: Text(
                "NO",
                style: Theme.of(context).textTheme.button,
              ),
              onPressed: () {
                Navigator.of(context).pop();
                print("Cancel Sign Out");
              },
            ),
            TextButton(
              child: Text(
                "YES",
                style: Theme.of(context).textTheme.button,
              ),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                ToastMessages().toastSuccess("Sign Out Success", context);
                print("Sign Out Success");
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => WelcomePage(),
                  ),
                  (route) => false,
                );
              },
            ),
          ],
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
        );
      },
    );
  }
}
