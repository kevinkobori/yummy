import 'package:flutter/material.dart';

import 'constants.dart';

ThemeData theme() {
  return ThemeData(
    pageTransitionsTheme: const PageTransitionsTheme(builders: {
      TargetPlatform.android: CupertinoPageTransitionsBuilder(),
    }),
    scaffoldBackgroundColor: Colors.white,
    canvasColor: Colors.white,
    accentColor: AppColors.rosaClaro,
    fontFamily: "Muli",
    appBarTheme: appBarTheme(),
    textTheme: textTheme(),
    inputDecorationTheme: inputDecorationTheme(),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) => states.contains(MaterialState.disabled)
              ? Colors.grey[700]
              : Colors.white,
        ),
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) => Colors.transparent,
        ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
        ),
      ),
    ),
  );
}

InputDecorationTheme inputDecorationTheme() {
  final OutlineInputBorder _outlineInputBorder = OutlineInputBorder(
    borderSide: BorderSide(color: AppColors.rosaClaro),
    gapPadding: 10,
  );
  return InputDecorationTheme(
    floatingLabelBehavior: FloatingLabelBehavior.always,
    contentPadding: const EdgeInsets.symmetric(horizontal: 42, vertical: 20),
    enabledBorder: _outlineInputBorder,
    focusedBorder: _outlineInputBorder,
    border: _outlineInputBorder,
  );
}

TextTheme textTheme() {
  return TextTheme(
    bodyText1: TextStyle(color: Colors.grey[800]),
    bodyText2: TextStyle(color: Colors.grey[800]),
  );
}

AppBarTheme appBarTheme() {
  return AppBarTheme(
    color: Colors.white,
    elevation: 1,
    shadowColor: AppColors.azulClaro,
    centerTitle: true,
    iconTheme: IconThemeData(
      color: AppColors.azulClaro,
    ),
    titleSpacing: 0,
    textTheme: TextTheme(
      headline6: TextStyle(
        color: AppColors.azulClaro,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
