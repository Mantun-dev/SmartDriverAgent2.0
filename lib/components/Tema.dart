import 'package:flutter/material.dart';

final ThemeData appThemeDataLight = ThemeData(
  fontFamily: 'Roboto',
  primaryColor: const Color(0xFF285DA9),
  splashColor:const Color(0xF8F8F8F8),
  cardTheme: const CardTheme(
    color:   Color(0xF8F8F8F8),
  ),
  hintColor: Colors.grey[200],
  scaffoldBackgroundColor:const Color(0xFFFFFFFF),
  //canvasColor: const Color.fromARGB(255, 113, 122, 134),
  appBarTheme: const AppBarTheme(backgroundColor: Color(0xFF285DA9),),
  textTheme: const TextTheme(
    displayLarge: TextStyle(
      color: Color.fromARGB(255, 0, 0, 0),
      fontSize: 18,
      fontWeight: FontWeight.w600,
      fontFamily: 'Roboto',
    ),    

    // Agrega otro estilo de texto con un color diferente
    displayMedium: TextStyle(
      color: Color(0xFF285DA9), // Cambia este color al que desees
      fontSize: 15.0, // Cambia el tamaño de fuente según tus necesidades      
      fontFamily: 'Roboto',
    ),
    displaySmall: 
    TextStyle(
      color: Color(0xFF000000),
      fontSize: 16,
      fontWeight: FontWeight.w400,
      fontFamily: 'Roboto'
    //  fontWeight: FontWeight.w200,
    ),
    headlineLarge: 
    TextStyle(
      color: Color(0xFF000000),
      fontSize: 16,
      fontWeight: FontWeight.w800,
      fontFamily: 'Roboto',
    ),
    // headlineMedium: TextStyle(
    //   color: Color.fromARGB(255, 255, 255, 255),
    //   fontSize: 20,
    //   fontFamily: 'Muli'
    //   //fontWeight: FontWeight.w300,
    // ),
    headlineSmall: TextStyle(
      color: Color(0xFF000000),
      fontSize: 20,
      fontFamily: 'Roboto',
      fontWeight: FontWeight.w600,
    ),
    titleSmall: TextStyle(
      color: Color(0xFF000000),
      fontSize: 16,
      fontWeight: FontWeight.w400,
      fontFamily: 'Roboto'
    //  fontWeight: FontWeight.w200,
    ),
    titleLarge: TextStyle(
      color: Color.fromARGB(255, 0, 0, 0),
      fontSize: 18,
      fontWeight: FontWeight.w600,
      fontFamily: 'Roboto',
    ),
    titleMedium: TextStyle(
      color: Color.fromARGB(255, 0, 0, 0), // Cambia este color al que desees
      fontSize: 15.0, // Cambia el tamaño de fuente según tus necesidades 
      fontWeight: FontWeight.w600,     
      fontFamily: 'Roboto',
    ),
    bodyMedium: TextStyle(
      color: Color.fromARGB(255, 0, 0, 0), // Cambia este color al que desees
      fontSize: 15.0, // Cambia el tamaño de fuente según tus necesidades      
      fontWeight: FontWeight.w400,
      fontFamily: 'Roboto',
    ),
    bodyLarge: TextStyle(
      color: Color(0xFF285DA9), // Cambia este color al que desees
      fontSize: 15.0, // Cambia el tamaño de fuente según tus necesidades      
      fontWeight: FontWeight.w600,
      fontFamily: 'Roboto',
    ),
    labelMedium: TextStyle(
      color: Color(0xFF000000),
      fontSize: 18,
      fontWeight: FontWeight.w300,
      fontFamily: 'Roboto'
    ),
    //Texto pequeño perfil
    labelSmall: TextStyle(
      color: Color(0xFF000000),
      fontSize: 16,
      fontWeight: FontWeight.w300,
      fontFamily: 'Roboto'
    )
  ),
);


final ThemeData appThemeDataDark = ThemeData(
  primaryColor: const Color(0xFF285DA9),
  fontFamily: 'Roboto',
  textTheme: const TextTheme(displayLarge: TextStyle(
    color: Color.fromARGB(255, 203, 206, 221),
    fontSize: 72.0, fontWeight: FontWeight.bold))
);