import 'package:aloe/components/default_button.dart';
import 'package:aloe/components/form_error.dart';
import 'package:aloe/screens/forgot_password/forgot_password_screen.dart';
import 'package:aloe/screens/nav/nav_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class SignForm extends StatefulWidget {
  @override
  _SignFormState createState() => _SignFormState();
}

class _SignFormState extends State<SignForm> {
  final _formKey = GlobalKey<FormState>();
  String email;
  String password;
  final List<String> errors = [];
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void addError({String error}) {
    if (!errors.contains(error)) {
      setState(() {
        errors.add(error);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildEmailFormField(),
          SizedBox(
            height: getProportionateScreenHeight(context, generalPaddingSize),
          ),
          buildPasswordFormField(),
          SizedBox(
              height:
                  getProportionateScreenHeight(context, generalPaddingSize)),
          Row(
            children: [
              Spacer(),
              GestureDetector(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ForgotPasswordScreen())),
                child: Text(
                  "Mot de passe oublié" + "?",
                  style: TextStyle(
                      fontSize:
                          getProportionateScreenWidth(context, bodyFontSize),
                      decoration: TextDecoration.underline),
                ),
              )
            ],
          ),
          FormError(errors: errors),
          DefaultButton(
            text: "Se connecter",
            press: () {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();

                signIn();
              }
            },
          ),
        ],
      ),
    );
  }

  TextFormField buildEmailFormField() {
    return TextFormField(
      style: TextStyle(
          fontSize: getProportionateScreenWidth(context, formFontSize)),
      keyboardType: TextInputType.emailAddress,
      onSaved: (newValue) => email = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: emailNullError);
        }
        if (emailValidatorRegExp.hasMatch(value)) {
          removeError(error: invalidEmailError);
        }
        email = value;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: emailNullError);
          return "";
        } else if (!emailValidatorRegExp.hasMatch(value)) {
          addError(error: invalidEmailError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Email",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: InkWell(
          child: Icon(
            Icons.mail_outline,
          ),
        ),
      ),
    );
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
      style: TextStyle(
        fontSize: getProportionateScreenWidth(context, formFontSize),
      ),
      obscureText: true,
      onSaved: (newValue) => password = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: passNullError);
        }
        password = value;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: passNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Mot de passe",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Icon(
          Icons.lock_outlined,
        ),
      ),
    );
  }

  void removeError({String error}) {
    if (errors.contains(error)) {
      setState(() {
        errors.remove(error);
      });
    }
  }

  Future<void> signIn() async {
    _auth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((result) async {
      if (result.user.emailVerified) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => NavScreen(
                      startingIndex: 0,
                    )));
      } else {
        addError(
            error: "Mail non vérifié, \n nouveau mail de vérification\nenvoyé");
        result.user.sendEmailVerification();
      }
    }).catchError((err) {
      if (err.toString() ==
          "[firebase_auth/too-many-requests] Access to this account has been temporarily disabled due to many failed login attempts. You can immediately restore it by resetting your password or you can try again later.") {
        addError(error: tooManyAttemptsError);
      } else if (err.toString() ==
          "[firebase_auth/wrong-password] The password is invalid or the user does not have a password.") {
        addError(error: kWrongPassword);
      } else {
        addError(
            error:
                "Il y a eu une erreur \nlors de l'authentification \nveuillez réessayer !");
      }
    });
  }
}
