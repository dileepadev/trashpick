import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:trashpick/Generators/uui_generator.dart';
import 'package:trashpick/Models/user_model.dart';
import 'package:trashpick/Pages/BottomNavBar/PickMyTrash/pick_trash_location.dart';
import 'package:trashpick/Theme/theme_provider.dart';
import 'package:trashpick/Widgets/button_widgets.dart';
import 'dart:io';
import 'package:trashpick/Widgets/primary_app_bar_widget.dart';
import 'package:trashpick/Widgets/secondary_app_bar_widget.dart';
import 'package:trashpick/Widgets/toast_messages.dart';

import '../bottom_nav_bar.dart';

class NewTrashPickUp extends StatefulWidget {
  final String accountType;

  NewTrashPickUp(this.accountType);

  @override
  _NewTrashPickUpState createState() => _NewTrashPickUpState();
}

class _NewTrashPickUpState extends State<NewTrashPickUp> {
  TextEditingController _trashNameController = new TextEditingController();
  TextEditingController _trashDescriptionController =
      new TextEditingController();
  TextEditingController _trashLocationController = new TextEditingController();
  int charLength = 0;
  File _image;
  final String userProfileID = FirebaseAuth.instance.currentUser.uid.toString();

  // Uploading Process
  bool isStartToUpload = false;
  bool isUploadComplete = false;
  bool isAnError = false;
  double circularProgressVal;

  // Temp until delete
  CollectionReference imgRef;
  firebase_storage.Reference ref;
  String imageURL;
  final firestoreInstance = FirebaseFirestore.instance;
  String formattedDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
  String formattedTime = DateFormat('kk:mm:a').format(DateTime.now());

  String trashID = new UUIDGenerator().uuidV4();

  // ------------------------------ Trash Type Selector ------------------------------ \\

  Map<String, bool> trashTypeValues = {
    'Plastic & Polythene': false,
    'Glass': false,
    'Paper': false,
    'Metal & Coconut Shell': false,
    'Clinical Waste': false,
    'E-Waste': false,
  };

  List trashTypeArray = [];
  List trashTypes;

  getCheckboxItems() {
    trashTypeArray.clear();
    trashTypeValues.forEach((key, value) {
      if (value == true) {
        trashTypeArray.add(key);
      }
    });
    trashTypes = trashTypeArray;
    //print(trashTypeArray);
    //print(trashTypes);
  }

  // ------------------------------ Location Picker ------------------------------ \\

  String locationName = "My Location";
  String userHomeLocation = "My Home";
  int locationTypeID;

  final userReference = FirebaseFirestore.instance.collection('Users');
  final FirebaseAuth auth = FirebaseAuth.instance;
  Position _currentPosition;

  List _trashLocationDetails;
  String userCurrentAddress = "No Location Selected!";
  String selectedFromMapAddress = "No Location Selected!";
  String trashLocationAddress = "No Location Selected!";
  double trashLocationLatitude, trashLocationLongitude;

  // ------------------------------ Date Picker ------------------------------ \\

  String startDate = DateTime.now().day.toString() +
      "/" +
      DateTime.now().month.toString() +
      "/" +
      DateTime.now().year.toString();
  String returnDate = DateTime.now().day.toString() +
      "/" +
      DateTime.now().month.toString() +
      "/" +
      DateTime.now().year.toString();
  DateTime _dateS = DateTime(2021, 07, 17);
  DateTime _dateR = DateTime(2021, 07, 18);

  // ------------------------------ Time Picker ------------------------------ \\

  String startTime = "7:15 AM";
  String returnTime = "8:15 AM";
  TimeOfDay _timeS = TimeOfDay(hour: 7, minute: 15);
  TimeOfDay _timeR = TimeOfDay(hour: 8, minute: 15);
  var now = DateTime.now().hour;
  var nowt = DateTime.now().minute;
  TimeOfDay releaseTime = TimeOfDay(hour: 15, minute: 0);
  String nowTime = TimeOfDay(hour: 15, minute: 0).toString();

  void _startTime() async {
    final TimeOfDay newTime = await showTimePicker(
      context: context,
      initialTime: _timeS,
    );
    if (newTime != null) {
      setState(() {
        _timeS = newTime;
        startTime = _timeS.format(context);
      });
    }
  }

  void _returnTime() async {
    final TimeOfDay newTime = await showTimePicker(
      context: context,
      initialTime: _timeR,
    );
    if (newTime != null) {
      setState(() {
        _timeR = newTime;
        returnTime = _timeR.format(context);
      });
    }
  }

  _onChanged(String value) {
    setState(() {
      charLength = value.length;
    });
  }

  _imgFromCamera() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50);

    setState(() {
      _image = image;
    });
  }

  _imgFromGallery() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      _image = image;
    });
  }

  void _showPicker(context) {
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
    print("Post Add Success!");
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
                  ? Center(child: Text("Uploading Post"))
                  : Center(child: Text("Upload Success")),
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
                              Text("Please wait until your post is upload.",
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
                                  color: AppThemeData().redColor,
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
                              'assets/icons/icon_recycle.png',
                              height: 50,
                              width: 50,
                            ),
                            SizedBox(height: 30),
                            Text("Post has uploaded!",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 22.0)
                                    .copyWith(
                                        color: Colors.grey.shade900,
                                        fontWeight: FontWeight.bold)),
                            SizedBox(height: 50),
                            new ButtonWidget(
                                text: "Continue",
                                textColor: AppThemeData().whiteColor,
                                color: AppThemeData().primaryColor,
                                onClicked: () {
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          BottomNavBar(widget.accountType),
                                    ),
                                    (route) => false,
                                  );
                                }),
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

  Future<void> uploadImagesToStorage() async {
    try {
      ref = firebase_storage.FirebaseStorage.instance
          .ref()
          //.child('Posts/$userProfileID/$postID/${Path.basename(_image.path)}');
          .child('Trash Pick Ups/$userProfileID/$trashID/$trashID');
      await ref.putFile(_image);

      String downloadURL = await firebase_storage.FirebaseStorage.instance
          .ref()
          //.child('Posts/$userProfileID/$postID/${Path.basename(_image.path)}')
          .child('Trash Pick Ups/$userProfileID/$trashID/$trashID')
          .getDownloadURL();
      imageURL = downloadURL.toString();
      print("Image Uploaded to Firebase Storage!");
      print("Image URL: " + imageURL);
      addPostToFireStore(imageURL);
    } catch (e) {
      print(e.toString());
      ifAnError();
    }
  }

  Future<void> addPostToFireStore(String trashImage) async {
    firestoreInstance
        .collection('Users')
        .doc(userProfileID)
        .collection('Trash Pick Ups')
        .doc(trashID)
        .set({
          'trashID': trashID,
          'postedDate': formattedDate + ", " + formattedTime,
          'trashName': _trashNameController.text,
          'trashDescription': _trashDescriptionController.text,
          'trashImage': trashImage,
          'trashTypes': trashTypes,
          'trashLocationAddress': trashLocationAddress,
          'trashLocationLocation':
              new GeoPoint(trashLocationLatitude, trashLocationLongitude),
          'startDate': startDate,
          'returnDate': returnDate,
          'startTime': startTime,
          'returnTime': returnTime,
        })
        .then(
          (value) => sendSuccessCode(),
        )
        .catchError((error) => sendErrorCode(error.toString()));
  }

  /*void validatePost() {
    if (_newPostCaptionController.text.isEmpty ||
        _newPostCaptionController.text == null) {
      ToastMessages().toastError("Please enter trash caption", context);
    } else if (_image == null) {
      ToastMessages().toastError("Please select image", context);
    } else {
      showAlertDialog(context);
      uploadImagesToStorage();
    }
  }*/

  _getCurrentUserLocation() async {
    try {
      Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high,
              forceAndroidLocationManager: true)
          .then((Position position) {
        setState(() {
          _currentPosition = position;
        });
        _getCurrentUserAddressFromLatLng(
            _currentPosition.latitude, _currentPosition.longitude);
      }).catchError((e) {
        print(e);
      });
    } catch (error) {
      ToastMessages().toastError(error, context);
    }
  }

  _getCurrentUserAddressFromLatLng(latitude, longitude) async {
    try {
      List<Placemark> p = await placemarkFromCoordinates(latitude, longitude);
      Placemark place = p[0];
      setState(() {
        if (place != null) {
          trashLocationLatitude = latitude;
          trashLocationLongitude = longitude;

          _trashLocationDetails = [
            latitude, // 00
            longitude, // 01
            "${place.name}", // 02
            "${place.street}", // 03
            "${place.postalCode}", // 04
            "${place.administrativeArea}", // 05
            "${place.subAdministrativeArea}", // 06
            "${place.thoroughfare}", // 07
            "${place.subThoroughfare}", // 08
            "${place.locality}", // 09
            "${place.subLocality}", // 10
            "${place.country}", // 11
            "${place.isoCountryCode}", // 12
          ];

          userCurrentAddress = ""
              "${_trashLocationDetails[0].toString()}, "
              "${_trashLocationDetails[1].toString()}, "
              "${_trashLocationDetails[2].toString()}, "
              "${_trashLocationDetails[3].toString()}, "
              "${_trashLocationDetails[4].toString()}, "
              "${_trashLocationDetails[5].toString()}, "
              "${_trashLocationDetails[6].toString()}, "
              "${_trashLocationDetails[7].toString()}, "
              "${_trashLocationDetails[8].toString()}, "
              "${_trashLocationDetails[9].toString()}, "
              "${_trashLocationDetails[10].toString()}, "
              "${_trashLocationDetails[11].toString()}, "
              "${_trashLocationDetails[12].toString()}";

          /*ToastMessages().toastSuccess("Location Selected: \n"
              "$_trashLocationAddress", context);*/
        } else {
          ToastMessages().toastSuccess("No Address", context);
        }
      });
    } catch (error) {
      ToastMessages().toastError(error.toString(), context);
      print("ERROR=> _getTrashLocationAddressFromLatLng: $error");
    }
  }

  void _startDate() async {
    final DateTime newDate = await showDatePicker(
      context: context,
      initialDate: _dateS,
      firstDate: DateTime(2021, 1),
      lastDate: DateTime(2031, 1),
      helpText: 'Select a date',
    );
    if (newDate != null) {
      setState(() {
        _dateS = newDate;
        startDate = _dateS.day.toString() +
            "/" +
            _dateS.month.toString() +
            "/" +
            _dateS.year.toString();
      });
    }
  }

  void _returnDate() async {
    final DateTime newDate = await showDatePicker(
      context: context,
      initialDate: _dateR,
      firstDate: DateTime(2017, 1),
      lastDate: DateTime(2022, 7),
      helpText: 'Select a date',
    );
    if (newDate != null) {
      setState(() {
        _dateR = newDate;
        returnDate = _dateR.day.toString() +
            "/" +
            _dateR.month.toString() +
            "/" +
            _dateR.year.toString();
      });
    }
  }

  printTrashPickUpDetails() {
    String info =
        "------------------------- Trash Pick Up Details -------------------------\n"
                "Trash Name: " +
            _trashNameController.text +
            "\n" +
            "Trash Description: " +
            _trashDescriptionController.text +
            "\n" +
            "Trash Image: " +
            _image.toString() +
            "\n" +
            "Trash Types: " +
            trashTypes.toString() +
            "\n" +
            "Trash Location Address: " +
            trashLocationAddress.toString() +
            "\n" +
            "Trash Location Latitude: " +
            trashLocationLatitude.toString() +
            "\n" +
            "Trash Location Longitude: " +
            trashLocationLongitude.toString() +
            "\n" +
            "Start Date: $startDate\n" +
            "Return Date: $returnDate\n" +
            "Start Time: $startTime\n" +
            "Return Time: $returnTime\n";
    print(info);
  }

  void validatePickUp() {
    if (_trashNameController.text.isEmpty) {
      new ToastMessages().toastError("Cannot leave trash name", context);
    } else if (_trashDescriptionController.text.isEmpty) {
      new ToastMessages().toastError("Cannot leave trash description", context);
    } else if (_image == null) {
      new ToastMessages().toastError("Please select an image", context);
    } else if (trashTypes.isEmpty) {
      new ToastMessages()
          .toastError("Please select at least one type", context);
    } else if (trashLocationAddress == "No Location Selected!") {
      new ToastMessages().toastError("Please select a location", context);
    } else if (startDate.isEmpty) {
      new ToastMessages().toastError("Please select Start Date", context);
    } else if (returnDate.isEmpty) {
      new ToastMessages().toastError("Please select Return Date", context);
    } else if (_dateS.day + _dateS.month + _dateS.year >
        _dateR.day + _dateR.month + _dateR.year) {
      new ToastMessages()
          .toastError("Return date cannot be early than Start Date", context);
    } else if (startTime.isEmpty) {
      new ToastMessages().toastError("Please Select Start Time", context);
    } else if (returnTime.isEmpty) {
      new ToastMessages().toastError("Please select Return Time", context);
    } else if (startDate == returnDate && _timeS.hour > _timeR.hour) {
      new ToastMessages().toastError(
          "Return Time cannot be early than Start Time on same day", context);
    } else {
      printTrashPickUpDetails();
      showAlertDialog(context);
      uploadImagesToStorage();
    }
    //printTrashPickUpDetails();
  }

  @override
  void initState() {
    _getCurrentUserLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void navigateAndDisplaySelection(BuildContext context) async {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PickTrashLocation(_currentPosition)),
      );
      setState(() {
        if (result == null) {
          selectedFromMapAddress = "No Location Selected!";
        } else {
          _trashLocationDetails = result;
          selectedFromMapAddress = ""
              "${_trashLocationDetails[0].toString()}, "
              "${_trashLocationDetails[1].toString()}, "
              "${_trashLocationDetails[2].toString()}, "
              "${_trashLocationDetails[3].toString()}, "
              "${_trashLocationDetails[4].toString()}, "
              "${_trashLocationDetails[5].toString()}, "
              "${_trashLocationDetails[6].toString()}, "
              "${_trashLocationDetails[7].toString()}, "
              "${_trashLocationDetails[8].toString()}, "
              "${_trashLocationDetails[9].toString()}, "
              "${_trashLocationDetails[10].toString()}, "
              "${_trashLocationDetails[11].toString()}, "
              "${_trashLocationDetails[12].toString()}";
          trashLocationAddress = selectedFromMapAddress;
        }
      });
    }

    showInfoAlert(BuildContext context) {
      String infoTitle = "Guide to select location";
      String infoMessage =
          "To select a location, just press on the map and selected place will marked with this marker.";
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(infoTitle),
            content: Container(
              height: 160.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    infoMessage,
                    style: TextStyle(fontWeight: FontWeight.normal),
                  ),
                  Image.asset(
                    'assets/icons/icon_bin.png',
                    scale: 1.0,
                  )
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  "Ok and Select Location",
                  style: TextStyle(color: AppThemeData().primaryColor),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  navigateAndDisplaySelection(context);
/*                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            PickTrashLocation(_currentPosition)),
                  );*/
                },
              ),
            ],
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
          );
        },
      );
    }

    garbageTypes() {
      return Container(
        height: 430.0,
        child: ListView(
          physics: NeverScrollableScrollPhysics(),
          children: trashTypeValues.keys.map((String key) {
            Color color;
            String description;

            switch (key) {
              case "Plastic & Polythene":
                color = Colors.orange.shade700;
                description = "Plastic & Polythene";
                break;
              case "Glass":
                color = Colors.red;
                description = "Glass";
                break;
              case "Paper":
                color = Colors.blue;
                description = "Paper";
                break;
              case "Metal & Coconut Shell":
                color = Colors.black;
                description = "Metal & Coconut Shell";
                break;
              case "Clinical Waste":
                color = Colors.yellow;
                description = "Clinical Waste";
                break;
              case "E-Waste":
                color = Colors.grey.shade200;
                description = "E-Waste";
                break;
              default:
                color = Colors.grey.shade100;
                description = "Other";
            }

            return new CheckboxListTile(
              secondary: Container(
                color: color,
                height: 30.0,
                width: 30.0,
              ),
              title: new Text(key),
              subtitle: Text(description),
              value: trashTypeValues[key],
              onChanged: (bool value) {
                setState(() {
                  trashTypeValues[key] = value;
                });
              },
            );
          }).toList(),
        ),
      );
    }

    /*Widget getMyHomeAddress(){
      return FutureBuilder(
        future: userReference.doc(auth.currentUser.uid).get(),
        builder: (context, dataSnapshot) {
          if (!dataSnapshot.hasData) {
            _trashLocationController =
            new TextEditingController(text: "No Location Selected!");
            return TextFormField(
              controller: _trashLocationController,
              style: TextStyle(fontWeight: FontWeight.normal),
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.home_rounded,
                  color: Theme.of(context).iconTheme.color,
                  size: 35.0,
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: const BorderSide(color: Colors.black),
                ),
              ),
              keyboardType: TextInputType.text,
            );
          } else {
            UserModelClass userModelClass =
            UserModelClass.fromDocument(dataSnapshot.data);
            _trashLocationController =
            new TextEditingController(text: userModelClass.homeAddress);
            return TextFormField(
              controller: _trashLocationController,
              style: TextStyle(fontWeight: FontWeight.normal),
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.home_rounded,
                  color: Theme.of(context).iconTheme.color,
                  size: 35.0,
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: const BorderSide(color: Colors.black),
                ),
              ),
              keyboardType: TextInputType.text,
            );
          }
        },
      );
    }*/

    Widget trashLocation() {
      Widget widget;

      switch (locationName) {
        case "Current Location":
          widget = Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.location_on_rounded,
                color: Theme.of(context).iconTheme.color,
                size: 35.0,
              ),
              Text(
                "Current Location",
                style: TextStyle(
                    fontSize: Theme.of(context).textTheme.headline6.fontSize,
                    fontWeight: FontWeight.bold),
              ),
            ],
          );
          break;
        case "Select from Map":
          widget = Center(
            child: MinButtonWidget(
              text: "Select from Map",
              color: Theme.of(context).backgroundColor,
              onClicked: () {
                print("Pressed: Select from Map");
                showInfoAlert(context);
              },
            ),
          );
          break;
        default:
          widget = Container();
      }
      return widget;
    }

    radioButtonList() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Radio(
                value: 1,
                groupValue: locationTypeID,
                onChanged: (val) {
                  setState(() {
                    locationName = 'Current Location';
                    locationTypeID = 1;
                    trashLocationAddress = userCurrentAddress;
                  });
                },
              ),
              Text(
                'Current Location',
                style: new TextStyle(
                    fontSize: Theme.of(context).textTheme.subtitle1.fontSize),
              ),
              Radio(
                value: 2,
                groupValue: locationTypeID,
                onChanged: (val) {
                  setState(() {
                    locationName = 'Select from Map';
                    locationTypeID = 2;
                    trashLocationAddress = selectedFromMapAddress;
                  });
                },
              ),
              Text(
                'Select from Map',
                style: new TextStyle(
                  fontSize: Theme.of(context).textTheme.subtitle1.fontSize,
                ),
              ),
            ],
          ),
        ],
      );
    }

    dateSelectCard(String title, VoidCallback onCardTap, String dateType) {
      return Container(
        alignment: Alignment.topLeft,
        width: 150,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade600),
            ),
            SizedBox(
              height: 10.0,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Container(
                  color: Colors.grey.shade200,
                  child: new GestureDetector(
                      onTap: onCardTap,
                      child: new Container(
                        height: 50.0,
                        width: 150.0,
                        color: Colors.white,
                        child: Center(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.calendar_today_rounded,
                              size: 20.0,
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Text(
                              dateType,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        )),
                      ))),
            ),
          ],
        ),
      );
    }

    timeSelectCard(String title, VoidCallback onCardTap, String timeType) {
      return Container(
        alignment: Alignment.topLeft,
        width: 150,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade600),
            ),
            SizedBox(
              height: 10.0,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Container(
                  color: Colors.grey.shade200,
                  child: new GestureDetector(
                      onTap: onCardTap,
                      child: new Container(
                        height: 50.0,
                        width: 150.0,
                        color: Colors.white,
                        child: Center(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.access_time_rounded,
                              size: 20.0,
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Text(
                              timeType,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        )),
                      ))),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: SecondaryAppBar(
        title: "Schedule a Trash Pick Up",
        appBar: AppBar(),
        widgets: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
            child: Icon(
              Icons.cancel_rounded,
              size: 30.0,
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _trashNameController,
                  style: TextStyle(fontWeight: FontWeight.normal),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                    hintText: "Give a name to the trash",
                    labelText: 'Trash Name',
                    focusedBorder: UnderlineInputBorder(
                      borderSide: const BorderSide(color: Colors.black),
                    ),
                    labelStyle: TextStyle(
                        color: Colors.grey.shade900,
                        fontWeight: FontWeight.bold),
                  ),
                  keyboardType: TextInputType.text,
                ),
                SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  controller: _trashDescriptionController,
                  style: TextStyle(fontWeight: FontWeight.normal),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                    helperText: "$charLength",
                    hintText: "Say something about trash",
                    labelText: 'Trash Description',
                    focusedBorder: UnderlineInputBorder(
                      borderSide: const BorderSide(color: Colors.black),
                    ),
                    labelStyle: TextStyle(
                        color: Colors.grey.shade900,
                        fontWeight: FontWeight.bold),
                  ),
                  onChanged: _onChanged,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  "Pick Trash Image",
                  style: TextStyle(
                      fontSize: Theme.of(context).textTheme.subtitle1.fontSize,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      _showPicker(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      child: _image != null
                          ? Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                              ),
                              child: Image.file(
                                _image,
                                width: MediaQuery.of(context).size.width,
                                height: 300,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(10)),
                              width: MediaQuery.of(context).size.width,
                              height: 300,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    "Press to select image",
                                    style: TextStyle(
                                      fontSize: Theme.of(context)
                                          .textTheme
                                          .headline6
                                          .fontSize,
                                      fontWeight: FontWeight.normal,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  Icon(
                                    Icons.camera_alt_rounded,
                                    size: 80.0,
                                    color: Colors.grey.shade700,
                                  ),
                                ],
                              ),
                            ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  "Select Trash Types",
                  style: TextStyle(
                      fontSize: Theme.of(context).textTheme.subtitle1.fontSize,
                      fontWeight: FontWeight.bold),
                ),
                garbageTypes(),
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  "Select Location",
                  style: TextStyle(
                      fontSize: Theme.of(context).textTheme.subtitle1.fontSize,
                      fontWeight: FontWeight.bold),
                ),
                radioButtonList(),
                trashLocation(),
                SizedBox(
                  height: 20.0,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Trash Location",
                      style: TextStyle(
                          fontSize:
                              Theme.of(context).textTheme.subtitle1.fontSize,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      "$trashLocationAddress",
                      style: TextStyle(
                          fontSize:
                              Theme.of(context).textTheme.subtitle1.fontSize,
                          fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  "Select Available Date Period",
                  style: TextStyle(
                      fontSize: Theme.of(context).textTheme.subtitle1.fontSize,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        dateSelectCard("Start Date", _startDate, startDate),
                        dateSelectCard("Return Date", _returnDate, returnDate),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  "Select Available Time Period",
                  style: TextStyle(
                      fontSize: Theme.of(context).textTheme.subtitle1.fontSize,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        timeSelectCard(
                            "Start Time", _startTime, _timeS.format(context)),
                        timeSelectCard(
                            "Return Time", _returnTime, _timeR.format(context)),
                      ],
                    ),
                  ),
                ),
                MinButtonWidget(
                  onClicked: () {
                    getCheckboxItems();
                    //printTrashPickUpDetails();
                    validatePickUp();
                  },
                  color: AppThemeData().secondaryColor,
                  text: "OK",
                ),
                SizedBox(
                  height: 40.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
