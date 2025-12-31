import 'package:flutter/material.dart';

class ImageFramesWidgets {
  userProfileFrame(
      profileImage, double width, double radius, bool isNetworkImage) {
    return isNetworkImage == true
        ? Container(
            width: width,
            alignment: Alignment.topLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                profileImage != null
                    ? CircleAvatar(
                        backgroundImage: NetworkImage(profileImage),
                        radius: radius,
                      )
                    : CircleAvatar(
                        backgroundImage: AssetImage(
                            'assets/images/trashpick_user_avatar.png'),
                        radius: radius,
                      ),
              ],
            ),
          )
        : Container(
            height: 150.0,
            width: 150.0,
            child: CircleAvatar(
              backgroundImage: FileImage(profileImage),
              radius: 40,
            ),
          );
  }
}
