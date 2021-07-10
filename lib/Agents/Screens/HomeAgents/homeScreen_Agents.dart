import 'package:flutter/material.dart';
import 'package:flutter_auth/Agents/Screens/HomeAgents/components/body.dart';
import 'package:flutter_auth/Agents/Screens/Profile/profile_screen.dart';
import 'package:flutter_auth/components/menu_lateral.dart';
import 'package:flutter_svg/svg.dart';

import '../../../constants.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: Body(),
      drawer: MenuLateral(),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: kColorAppBar,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
      actions: <Widget>[
        //aquí está el icono de las notificaciones
        IconButton(
          icon: SvgPicture.asset(
            "assets/icons/user.svg",
            width: 100,
          ),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return ProfilePage();
            }));
          },
        ),
        SizedBox(width: kDefaultPadding / 2)
      ],
    );
  }
}
