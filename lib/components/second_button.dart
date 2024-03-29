import 'package:flutter/material.dart';

import '../constants.dart';
import '../size_config.dart';

class SecondButton extends StatelessWidget {
  const SecondButton({
    Key key,
    this.text,
    this.press,
  }) : super(key: key);
  final String text;
  final Function press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: style1ButtonColor,
        ),
        onPressed: press,
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(
            text,
            style: TextStyle(
              fontSize: getProportionateScreenWidth(context, buttonFontSize),
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
