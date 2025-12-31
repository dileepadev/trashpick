import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trashpick/Generators/uui_generator.dart';
import 'package:trashpick/Theme/theme_provider.dart';
import 'package:trashpick/Widgets/button_widgets.dart';
import 'package:trashpick/Widgets/secondary_app_bar_widget.dart';
import 'package:trashpick/Widgets/toast_messages.dart';

class GiveFeedbackPage extends StatefulWidget {
  @override
  _GiveFeedbackPageState createState() => _GiveFeedbackPageState();
}

class _GiveFeedbackPageState extends State<GiveFeedbackPage> {
  TextEditingController _giveFeedbackController = new TextEditingController();
  int charLength = 0;
  String formattedDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
  String formattedTime = DateFormat('kk:mm:a').format(DateTime.now());

  // Uploading Process
  bool isStartToUpload = false;
  bool isUploadComplete = false;
  bool isAnError = false;
  double circularProgressVal;

  _onChanged(String value) {
    setState(() {
      charLength = value.length;
    });
  }

  // -------------------------------- UPLOADING PROCESS -------------------------------- \\

  void ifAnError() {
    Navigator.pop(context);
    setState(() {
      isStartToUpload = false;
      isUploadComplete = false;
      isAnError = true;
      //Navigator.pop(context);
      showAlertDialog(context);
    });
  }

  void sendErrorCode(String error) {
    ToastMessages().toastError(error, context);
    ifAnError();
  }

  void sendSuccessCode() {
    print("Feedback Send Success!");
    Navigator.pop(context);
    setState(() {
      isStartToUpload = false;
      isUploadComplete = true;
    });
    showAlertDialog(context);
  }

  showAlertDialog(BuildContext context) {
    // show the dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: !isUploadComplete
                  ? Center(child: Text("Sending Feedback"))
                  : Center(child: Text("Feedback Send Success")),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!isUploadComplete)
                    !isAnError
                        ? Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 30.0,
                              ),
                              CircularProgressIndicator(
                                value: circularProgressVal,
                                strokeWidth: 6,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.teal.shade700),
                              ),
                              SizedBox(
                                height: 30.0,
                              ),
                              Text("Please wait until your feedback send.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontSize: 16.0)
                                      .copyWith(color: Colors.grey.shade900)),
                            ],
                          )
                        : Container(
                            child: Column(
                            children: [
                              Text("Error!",
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  )),
                              SizedBox(
                                height: 50.0,
                              ),
                              new ButtonWidget(
                                  text: "Try Again",
                                  textColor: AppThemeData().whiteColor,
                                  color: AppThemeData().primaryColor,
                                  onClicked: () {
                                    Navigator.pop(context);
                                  }),
                            ],
                          ))
                  else
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/icons/icon_feedback.png',
                              height: 50,
                              width: 50,
                            ),
                            SizedBox(height: 30),
                            Text("Feedback Successfully Send!",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 22.0)
                                    .copyWith(
                                        color: Colors.grey.shade900,
                                        fontWeight: FontWeight.bold)),
                            SizedBox(height: 50),
                            new ButtonWidget(
                              textColor: AppThemeData().whiteColor,
                              color: AppThemeData().secondaryColor,
                              text: "OK",
                              onClicked: () {
                                Navigator.pop(context);
                              },
                            )
                          ],
                        ),
                      ),
                    )
                ],
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
            );
          },
        );
      },
    );
  }

  sendFeedback() {
    FirebaseFirestore.instance
        .collection('Feedbacks')
        .doc("User Feedbacks")
        .collection(FirebaseAuth.instance.currentUser.uid)
        .doc(UUIDGenerator().uuidV1())
        .set({
          'feedback': _giveFeedbackController.text,
          'postedDate': formattedDate + ", " + formattedTime,
        })
        .then(
          (value) => sendSuccessCode(),
        )
        .catchError((error) => sendErrorCode(error.toString()));
  }

  void validateEdits() {
    if (_giveFeedbackController.text.isEmpty) {
      ToastMessages().toastError("Please enter feedback to send", context);
    } else {
      print(_giveFeedbackController.text);
      sendFeedback();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SecondaryAppBar(
        title: "Give Feedback",
        appBar: AppBar(),
        widgets: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
            child: Icon(
              Icons.feedback_rounded,
              color: Theme.of(context).iconTheme.color,
              size: 35.0,
            ),
          )
        ],
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 20.0,
          ),
          Image.asset(
            'assets/logos/trashpick_logo_curved.png',
            height: 150.0,
            width: 150.0,
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextFormField(
              controller: _giveFeedbackController,
              style: TextStyle(fontWeight: FontWeight.normal),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(20.0, 40.0, 20.0, 10.0),
                helperText: "No of letters: $charLength",
                hintText: "Say something about your idea",
                labelText: 'Type Your Feedback',
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Colors.black,
                    width: 1.0,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black,
                    width: 1.0,
                  ),
                ),
                labelStyle: TextStyle(
                    color: Colors.grey.shade900, fontWeight: FontWeight.bold),
              ),
              onChanged: _onChanged,
              maxLines: null,
              keyboardType: TextInputType.multiline,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: MinButtonWidget(
              text: "Send Feedback",
              color: AppThemeData().secondaryColor,
              onClicked: () {
                validateEdits();
              },
            ),
          ),
        ],
      ),
    );
  }
}
