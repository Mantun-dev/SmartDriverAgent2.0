import 'package:flutter/material.dart';
import 'package:flutter_auth/Agents/Screens/Restore/components/body.dart';
import 'package:flutter_auth/constants.dart';

class RestoreScreen extends StatelessWidget {
  const RestoreScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(child: SafeArea(child: Body())),
    );
  }
}
