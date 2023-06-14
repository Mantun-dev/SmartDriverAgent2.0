import 'package:flutter/material.dart';
import 'package:flutter_auth/Agents/Screens/Signup/components/body.dart';

class SignUpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(child: SafeArea(child: Body())),
    );
  }
}
