import 'package:aloe/screens/nav/nav_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';

import '../../constants.dart';
import '../../size_config.dart';

class IntroScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User result = FirebaseAuth.instance.currentUser;
    SizeConfig().init(context);
    return new SplashScreen(
        seconds: 2,
        navigateAfterSeconds: result != null
            ? result.uid == "DNrxNkfOjeZmJcFLIBpnDjMdbYa2"
                ? NavScreen()
                : NavScreen()
            : NavScreen(),
        title: Text(
          'Aloe',
          style: new TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: getProportionateScreenWidth(40),
              color: Colors.black),
        ),
        backgroundColor: Colors.white,
        loaderColor: kPrimaryColor);
  }
}