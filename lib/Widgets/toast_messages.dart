import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../Theme/theme_provider.dart';

class ToastMessages {
  void toastSuccess(String success, BuildContext context) {
    Fluttertoast.showToast(
      msg: success,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black87,
      textColor: AppThemeData().whiteColor,
      fontSize: Theme.of(context).textTheme.caption.fontSize,
    );
  }

  void toastWarning(String warning, BuildContext context) {
    Fluttertoast.showToast(
      msg: warning,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black87,
      textColor: AppThemeData().whiteColor,
      fontSize: Theme.of(context).textTheme.caption.fontSize,
    );
  }

  void toastInfo(String info, BuildContext context) {
    Fluttertoast.showToast(
      msg: info,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black87,
      textColor: AppThemeData().whiteColor,
      fontSize: Theme.of(context).textTheme.caption.fontSize,
    );
  }

  void toastError(String error, BuildContext context) {
    Fluttertoast.showToast(
      msg: error,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black87,
      textColor: AppThemeData().whiteColor,
      fontSize: Theme.of(context).textTheme.caption.fontSize,
    );
  }
}
