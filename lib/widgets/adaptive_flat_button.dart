import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class AdaptiveFlatButton extends StatelessWidget {
  final String text;
  final double width;
  final Function handler;
  final Color textColor;
  final Color buttonColor;
  final Color iconColor;
  final IconData icon;
  final EdgeInsets buttonPadding;
  final ShapeBorder shape;

  const AdaptiveFlatButton(
      {Key key,
      this.text,
      this.width,
      this.handler,
      this.textColor,
      this.buttonColor,
      this.icon,
      this.iconColor,
      this.buttonPadding,
      this.shape})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? Container(
            width: width,
            child: CupertinoButton(
              padding: buttonPadding,
              color: buttonColor,
              child: Text(
                '$text',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              onPressed: handler,
            ),
          )
        : Container(
            width: width,
            child: icon == null
                ? FlatButton(
                    shape: shape,
                    padding: buttonPadding,
                    color: buttonColor,
                    onPressed: handler,
                    child: Text(
                      '$text',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: textColor),
                    ),
                  )
                : FlatButton.icon(
                    shape: shape,
                    padding: buttonPadding,
                    icon: Icon(icon, color: iconColor),
                    color: buttonColor,
                    onPressed: handler,
                    label: Expanded(
                      child: Text(
                        '$text',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: textColor),
                      ),
                    ),
                  ),
          );
  }
}
