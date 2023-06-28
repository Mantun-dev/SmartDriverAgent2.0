import 'package:flutter/material.dart';

const familyFont = 'Roboto';

final ThemeData appThemeDataLight = ThemeData(
  fontFamily: familyFont,

  primaryColor: const Color.fromRGBO(40, 93, 169, 1),
  scaffoldBackgroundColor:const Color.fromRGBO(248, 248, 248, 1),

  primaryIconTheme: IconThemeData(
    color: const Color.fromRGBO(40, 93, 169, 1)
  ),

  cardColor: Colors.white,
  hintColor: const Color.fromRGBO(158, 158, 158, 1),
  focusColor: Color(0xffc32c37),
  errorColor: Color(0xffc32c37),


  appBarTheme: AppBarTheme(backgroundColor: Colors.white),

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
    )

  ),
);


final ThemeData appThemeDataDark = ThemeData(
  
);