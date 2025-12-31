import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trashpick/Models/user_model.dart';
import 'package:trashpick/Theme/theme_provider.dart';
import 'package:trashpick/Widgets/button_widgets.dart';
import 'package:trashpick/Widgets/image_frames_widgets.dart';
import 'package:trashpick/Widgets/secondary_app_bar_widget.dart';
import 'package:trashpick/Widgets/toast_messages.dart';

class ProfileInfoPage extends StatefulWidget {
  @override
  _ProfileInfoPageState createState() => _ProfileInfoPageState();
}

class _ProfileInfoPageState extends State<ProfileInfoPage> {
  var currentUserID = FirebaseAuth.instance.currentUser.uid;
  CollectionReference imgRef;
  firebase_storage.Reference ref;
  File _userSelectedFileImage;
  String firebaseStorageUploadedImageURL;
  String _userLatestProfileImage;

  // Uploading Process
  bool isStartToUpload = false;
  bool isUploadComplete = false;
  bool isAnError = false;
  double circularProgressVal;

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
    print("Profile Update Success!");
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
                  ? Center(child: Text("Updating Profile"))
                  : Center(child: Text("Profile Updated")),
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
                              Text("Please wait until your profile is update.",
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
                              'assets/icons/icon_profile_upload.png',
                              height: 50,
                              width: 50,
                            ),
                            SizedBox(height: 30),
                            Text("Profile has uploaded!",
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

  void validateEdits() {
    if (_userSelectedFileImage == null) {
      ToastMessages().toastError("Please select an image", context);
    } else {
      showAlertDialog(context);
      uploadImagesToStorage();
    }
  }

  // -------------------------------- CHANGE IMAGE -------------------------------- \\

  _imgFromCamera() async {
    File fileImage = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50);

    setState(() {
      _userSelectedFileImage = fileImage;
    });
  }

  _imgFromGallery() async {
    File fileImage = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      _userSelectedFileImage = fileImage;
    });
  }

  changeProfilePicture(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future<void> uploadImagesToStorage() async {
    if (_userSelectedFileImage != null) {
      FirebaseStorage.instance.refFromURL(_userLatestProfileImage).delete();

      try {
        ref = firebase_storage.FirebaseStorage.instance.ref().child(
            'User Profile Images/${FirebaseAuth.instance.currentUser.uid}/${FirebaseAuth.instance.currentUser.uid}');
        await ref.putFile(_userSelectedFileImage);

        String downloadURL = await firebase_storage.FirebaseStorage.instance
            .ref()
            .child(
                'User Profile Images/${FirebaseAuth.instance.currentUser.uid}/${FirebaseAuth.instance.currentUser.uid}')
            .getDownloadURL();
        firebaseStorageUploadedImageURL = downloadURL.toString();
        print("Image Uploaded to Firebase Storage!");
        print("Image URL: " + firebaseStorageUploadedImageURL);
        saveEditProfileToFireStore(firebaseStorageUploadedImageURL);
      } catch (e) {
        print(e.toString());
        ifAnError();
      }
    } else {
      saveEditProfileToFireStore(_userLatestProfileImage);
    }
  }

  saveEditProfileToFireStore(String firebaseStorageUploadedImageURL) {
    print("IMAGE: " + firebaseStorageUploadedImageURL);

    FirebaseFirestore.instance
        .collection('Users')
        .doc(currentUserID.toString())
        .update({
          'profileImage': firebaseStorageUploadedImageURL,
        })
        .then(
          (value) => sendSuccessCode(),
        )
        .catchError((error) => sendErrorCode(error.toString()));
  }

  // -------------------------------- PROFILE DETAILS -------------------------------- \\

  _columnTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: Theme.of(context).textTheme.subtitle1.fontSize,
            fontWeight: FontWeight.bold),
      ),
    );
  }

  _columnDetail(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: Theme.of(context).textTheme.subtitle1.fontSize,
            fontWeight: FontWeight.normal),
      ),
    );
  }

  Widget _profileDetails() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Users")
            .where('uuid', isEqualTo: "${currentUserID.toString()}")
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

            _userLatestProfileImage = userModelClass.profileImage;

            return ListView(
              physics: BouncingScrollPhysics(),
              children: [
                SizedBox(
                  height: 5.0,
                ),
                Center(
                  child: _userSelectedFileImage != null
                      ? new ImageFramesWidgets().userProfileFrame(
                          _userSelectedFileImage, 150.0, 65.0, false)
                      : new ImageFramesWidgets().userProfileFrame(
                          _userLatestProfileImage, 150.0, 65.0, true),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Center(
                  child: TextWithIconButtonWidget(
                    text: "Click to Change Image",
                    icon: Icons.camera_alt_rounded,
                    iconToLeft: true,
                    onClicked: () {
                      print('Change Profile Image');
                      changeProfilePicture(context);
                    },
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _columnTitle("Name"),
                    _columnDetail(userModelClass.name),
                    _columnTitle("Account Type"),
                    _columnDetail(userModelClass.accountType),
                    _columnTitle("Contact Number"),
                    _columnDetail(userModelClass.contactNumber),
                    _columnTitle("Email"),
                    _columnDetail(userModelClass.email),
                    _columnTitle("Home Address"),
                    _columnDetail(userModelClass.homeAddress),
                  ],
                ),
                SizedBox(
                  height: 20.0,
                ),
                MinButtonWidget(
                  text: "Update Profile",
                  color: AppThemeData().secondaryColor,
                  onClicked: () {
                    validateEdits();
                  },
                ),
                SizedBox(
                  height: 20.0,
                ),
              ],
            );
          }
        },
      ),
    );
  }

  // -------------------------------- BUILD -------------------------------- \\

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SecondaryAppBar(
        title: "Profile Info",
        appBar: AppBar(),
        widgets: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
            child: Icon(
              Icons.person_rounded,
              color: Theme.of(context).iconTheme.color,
              size: 35.0,
            ),
          )
        ],
      ),
      body: _profileDetails(),
    );
  }
}
