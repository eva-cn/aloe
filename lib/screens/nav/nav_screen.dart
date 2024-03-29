import 'package:aloe/screens/home/home_screen.dart';
import 'package:aloe/screens/news/news_screen.dart';
import 'package:aloe/screens/profile/profile_screen.dart';
import 'package:aloe/screens/sign_in/sign_in_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import '../../constants.dart';

class NavScreen extends StatefulWidget {
  final int startingIndex;
  final Widget selectedWidget;
  const NavScreen({Key key, this.startingIndex, this.selectedWidget})
      : super(key: key);
  @override
  _NavScreenState createState() => _NavScreenState();
}

class _NavScreenState extends State<NavScreen> {
  int selectedIndex = 0;
  Widget selectedWidget = HomeScreen();

  void initState() {
    selectedIndex = widget.startingIndex;
    selectedWidget =
        widget.selectedWidget != null ? widget.selectedWidget : HomeScreen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    User _auth = FirebaseAuth.instance.currentUser;

    List<Widget> widgetOptions = <Widget>[
      selectedWidget,
      NewsScreen(),
      _auth != null ? ProfileScreen() : SignInScreen()
    ];

    return Scaffold(
      body: SingleChildScrollView(
          child: SafeArea(
        child: Center(
          child: Column(
            children: [
              Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    boxShadow: [
                      BoxShadow(
                        spreadRadius: -10,
                        blurRadius: 60,
                        color: Colors.green.withOpacity(.20),
                        offset: Offset(0, 15),
                      )
                    ],
                  ),
                  child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 22),
                      child: GNav(
                        gap: 10,
                        color: Colors.grey[600],
                        activeColor: Colors.white,
                        rippleColor: Colors.grey[800],
                        hoverColor: Colors.grey[700],
                        iconSize: 20,
                        haptic: true,
                        textStyle: TextStyle(fontSize: 16, color: Colors.white),
                        tabBackgroundColor: Colors.grey[900],
                        padding: EdgeInsets.symmetric(
                            horizontal: 20, vertical: 16.5),
                        duration: Duration(milliseconds: 800),
                        tabs: [
                          GButton(
                              icon: Icons.home,
                              text: 'Accueil',
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (_, __, ___) => NavScreen(
                                      startingIndex: homeScreenIndex,
                                    ),
                                    transitionDuration: Duration(seconds: 0),
                                  ),
                                );
                              }),
                          GButton(
                            icon: Icons.article_sharp,
                            text: 'Actualités',
                          ),
                          GButton(
                            icon: Icons.account_circle,
                            text: 'Profil',
                          ),
                        ],
                        selectedIndex: selectedIndex,
                        onTabChange: (index) {
                          setState(() {
                            selectedIndex = index;
                          });
                        },
                      ))),
              widgetOptions.elementAt(selectedIndex),
            ],
          ),
        ),
      )),
    );
  }
}
