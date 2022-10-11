import 'package:flutter/material.dart';
import 'package:flutter_auth/Agents/Screens/Register/components/body.dart';
import 'package:flutter_auth/constants.dart';

class RegisterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(child: Body()),
    );
  }
}
