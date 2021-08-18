import 'dart:io';

import "package:flutter/material.dart";
import 'package:flutter/cupertino.dart';

class Adaptive_flat_button extends StatelessWidget {
  final String text;
  final Function handler;

  Adaptive_flat_button(this.text, this.handler);

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoButton(
            onPressed: handler,
            child: Text(text,
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold)),
          )
        : FlatButton(
            onPressed: handler,
            child: Text(text,
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold)),
          );
  }
}
