import 'package:flutter/material.dart';
import 'package:flutter_auth/Agents/Screens/Welcome/components/body.dart';
import 'package:flutter_auth/constants.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        height: size.height,
        width: size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/fondo.png'), 
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Body(),
        ),
      ),
    );
  }
}

