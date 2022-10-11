import 'package:flutter/material.dart';
import 'package:flutter_auth/Agents/Screens/Signup/components/body.dart';
import 'package:flutter_auth/constants.dart';

class SignUpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(child: Body()),
    );
  }
}
