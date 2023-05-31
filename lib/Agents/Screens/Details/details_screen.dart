import 'package:flutter/material.dart';
import 'package:flutter_auth/Agents/Screens/Details/components/body.dart';
import 'package:flutter_auth/Agents/Screens/HomeAgents/homeScreen_Agents.dart';
import 'package:flutter_auth/Agents/models/dataAgent.dart';
import 'package:flutter_auth/Agents/models/network.dart';
import 'package:flutter_auth/Agents/models/plantilla.dart';
import 'package:flutter_auth/components/AppBarSuperior.dart';

//import 'package:flutter_auth/Drivers/components/menu_lateralDriver.dart';
import '../../../components/menu_lateral.dart';
import '../../../constants.dart';

class DetailScreen extends StatefulWidget {
  final Plantilla plantilla;

  final DataAgent? item;
  const DetailScreen({Key? key, required this.plantilla, this.item})
      : super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  Future<DataAgent>? item;

  @override
  void initState() {
    super.initState();
    item = fetchRefres();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: secondColor, size: 35),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.arrow_circle_left,
                size: 40,
                color: thirdColor,
              ),
              onPressed: () {
                setState(() {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (BuildContext context) => HomeScreen()),
                      (Route<dynamic> route) => false);
                });
              },
            ),
            SizedBox(width: kDefaultPadding / 4)
          ],
          backgroundColor: backgroundColor,
          elevation: 15,
        ),
        drawer: MenuLateral(),
        body: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Colors.blue,
                Colors.red,
              ],
            )),
            child: Body(plantilla: widget.plantilla)),
      ),
    ]);
  }
}
