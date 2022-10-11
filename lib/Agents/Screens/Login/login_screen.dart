import 'package:flutter/material.dart';
import 'package:flutter_auth/Agents/Screens/Login/components/body.dart';

import '../../../constants.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(child: Body()),
    );
  }
}
