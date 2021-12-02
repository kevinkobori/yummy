import 'package:flutter/material.dart';

const int _blackPrimaryValue = 0xFF000000;
const MaterialColor primaryBlack = MaterialColor(
  _blackPrimaryValue,
  <int, Color>{
    50: Color(0xFF000000),
    100: Color(0xFF000000),
    200: Color(0xFF000000),
    300: Color(0xFF000000),
    400: Color(0xFF000000),
    500: Color(_blackPrimaryValue),
    600: Color(0xFF000000),
    700: Color(0xFF000000),
    800: Color(0xFF000000),
    900: Color(0xFF000000),
  },
);

const kAccentColor = Color(0xFFFF7643);
const kPrimaryLightColor = Color(0xFFFFECDF);
const kPrimaryGradientColor = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFFFFA53E), Color(0xFFFF7643)],
);
const kSecondaryColor = Color(0xFF979797);
const kTextColor = Color(0xFF757575);

const kAnimationDuration = Duration(milliseconds: 200);

const TextStyle headingStyle = TextStyle(
  fontSize: 28,
  fontWeight: FontWeight.bold,
  color: Colors.black,
  height: 1.5,
);

const defaultDuration = Duration(milliseconds: 250);

final RegExp emailValidatorRegExp =
    RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
const String kEmailNullError = "Please Enter your email";
const String kInvalidEmailError = "Please Enter Valid Email";
const String kPassNullError = "Please Enter your password";
const String kShortPassError = "Password is too short";
const String kMatchPassError = "Passwords don't match";
const String kNamelNullError = "Please Enter your name";
const String kPhoneNumberNullError = "Please Enter your phone number";
const String kAddressNullError = "Please Enter your address";

final otpInputDecoration = InputDecoration(
  contentPadding: const EdgeInsets.symmetric(vertical: 15),
  border: outlineInputBorder(),
  focusedBorder: outlineInputBorder(),
  enabledBorder: outlineInputBorder(),
);

OutlineInputBorder outlineInputBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(15),
    borderSide: const BorderSide(color: kTextColor),
  );
}

const color1 = Color(0xFF262d3d);
const color2 = Color(0xFF14191f);
const color3 = Color(0xFF39adea);
const color4 = Color(0xFF474fd8);
const color5 = Color(0xFF232939);

const color6 = Color(0xFF151e28);
const color7 = Color(0xFF15212f);
const color8 = Color(0xFF122236);
const color9 = Color(0xFF262d3d);

class AppColors {
  static Color azul = Colors.blue;
  static Color grafite = Colors.grey[800];
  static Color branco = Colors.white;
  static Color azulClaro = Colors.blue[300];
  static Color azulMuitoClaro = Colors.blue[200];
  static Color azulExtraClaro = Colors.blue[100];
  static Color azulMarinhoEscuro = Colors.blueGrey[900];

  static Color rosaClaro = Colors.pink[300];
  static Color rosaMuitoClaro = Colors.pink[200];
  static Color rosaExtraClaro = Colors.pink[100];
}
