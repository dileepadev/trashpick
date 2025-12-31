import 'dart:ui';
import 'package:flutter/material.dart';
import '../Theme/theme_provider.dart';

class TextButtonWidget extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback onClicked;

  const TextButtonWidget({
    Key key,
    this.text,
    this.onClicked,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => TextButton(
        onPressed: onClicked,
        child: Text(text,
            style: TextStyle(
              fontSize: Theme.of(context).textTheme.button.fontSize,
              color: Colors.grey.shade900,
              fontWeight: FontWeight.bold,
            )),
      );
}

class RadiusFlatButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onClicked;

  const RadiusFlatButtonWidget({
    Key key,
    this.text,
    this.onClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => FlatButton(
        color: AppThemeData().redColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        ),
        child: Text(text,
            style: TextStyle(
                fontSize: Theme.of(context).textTheme.button.fontSize,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        onPressed: onClicked,
      );
}

class ButtonWidget extends StatelessWidget {
  final String text;
  final Color textColor;
  final Color color;
  final VoidCallback onClicked;

  const ButtonWidget({
    Key key,
    this.text,
    this.onClicked,
    this.textColor,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: Material(
          borderRadius: BorderRadius.circular(10.0),
          color: color,
          child: MaterialButton(
            minWidth: 250,
            onPressed: onClicked,
            child: Container(
              alignment: Alignment.center,
              child: Text(text,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontFamily: 'Montserrat', fontSize: 18.0)
                      .copyWith(color: textColor, fontWeight: FontWeight.bold)),
            ),
          ),
        ),
      );
}

class MinButtonWidget extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback onClicked;

  const MinButtonWidget({
    Key key,
    this.text,
    this.onClicked,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => FlatButton(
        color: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        minWidth: 200.0,
        child: Text(text,
            style: TextStyle(
                fontSize: Theme.of(context).textTheme.button.fontSize,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        onPressed: onClicked,
      );
}

class TextWithIconButtonWidget extends StatelessWidget {
  final String text;
  final IconData icon;
  final bool iconToLeft;
  final VoidCallback onClicked;

  const TextWithIconButtonWidget({
    Key key,
    this.text,
    this.icon,
    this.iconToLeft,
    this.onClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onClicked,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          textDirection: iconToLeft ? TextDirection.ltr : TextDirection.rtl,
          children: [
            Icon(
              icon,
              color: Theme.of(context).iconTheme.color,
            ),
            SizedBox(
              width: 10.0,
            ),
            Text(text,
                style: TextStyle(
                  fontSize: Theme.of(context).textTheme.button.fontSize,
                  color: Theme.of(context).textTheme.button.color,
                  fontWeight: FontWeight.bold,
                )),
          ],
        ),
      );
}

class ButtonWithIconWidget extends StatelessWidget {
  final Color buttonColor;
  final IconData icon;
  final Color iconColor;
  final String text;
  final Color textColor;
  final VoidCallback onClicked;

  const ButtonWithIconWidget({
    Key key,
    this.buttonColor,
    this.icon,
    this.iconColor,
    this.text,
    this.textColor,
    this.onClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Material(
        borderRadius: BorderRadius.circular(12.0),
        color: buttonColor,
        child: MaterialButton(
          minWidth: 180.0,
          padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          onPressed: onClicked,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 20.0,
                color: iconColor,
              ),
              SizedBox(width: 8),
              Text(text,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16.0)
                      .copyWith(color: textColor, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      );
}

class ButtonWithImageWidget extends StatelessWidget {
  final String image;
  final Color color;
  final String text;
  final Color textColor;
  final VoidCallback onClicked;

  const ButtonWithImageWidget({
    Key key,
    this.image,
    this.color,
    this.text,
    this.textColor,
    this.onClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Material(
          borderRadius: BorderRadius.circular(10.0),
          color: color,
          elevation: 2,
          child: MaterialButton(
            minWidth: 250,
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
            onPressed: onClicked,
            child: Container(
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    image,
                    height: 25,
                    width: 25,
                  ),
                  SizedBox(width: 10),
                  Text(text,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontFamily: 'Montserrat', fontSize: 16.0)
                          .copyWith(
                              color: textColor, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
        ),
      );
}
