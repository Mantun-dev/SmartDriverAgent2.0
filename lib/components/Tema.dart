import 'package:flutter/material.dart';

const familyFont = 'Roboto';

final ThemeData appThemeDataLight = ThemeData(
  fontFamily: familyFont,

  primaryColor: const Color.fromRGBO(40, 93, 169, 1),
  scaffoldBackgroundColor:const Color.fromRGBO(248, 248, 248, 1),

  primaryColorLight: Colors.white,
  primaryColorDark: Colors.black,

  cardColor: Colors.white,
  hintColor: const Color.fromRGBO(158, 158, 158, 1),
  focusColor: const Color.fromRGBO(40, 93, 169, 1),
  hoverColor: Color(0xffc32c37),
  errorColor: Color(0xffc32c37),

  dividerColor: Color.fromRGBO(158, 158, 158, 1),

  shadowColor: Color.fromRGBO(158, 158, 158, 0.18),


  appBarTheme: AppBarTheme(backgroundColor: Colors.white),

  primaryIconTheme: IconThemeData(color: const Color.fromRGBO(40, 93, 169, 1),),

  textTheme: const TextTheme(

    labelSmall: TextStyle( 
      color: Colors.black,
      fontSize: 9,
      fontFamily: familyFont,
      fontWeight: FontWeight.normal
    ),

    titleLarge: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontFamily: familyFont,
      fontWeight: FontWeight.normal
    ),

    titleMedium: TextStyle(
      color: Colors.black,
      fontFamily: familyFont,
      fontWeight: FontWeight.bold
    ),

    bodyMedium: TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.normal
    ),

  ),
);


final ThemeData appThemeDataDark = ThemeData(
  
);