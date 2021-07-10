import 'package:flutter/material.dart';
import 'package:flutter_auth/Agents/Screens/Details/components/body.dart';
import 'package:flutter_auth/Agents/Screens/HomeAgents/homeScreen_Agents.dart';
import 'package:flutter_auth/Agents/models/dataAgent.dart';
import 'package:flutter_auth/Agents/models/network.dart';
import 'package:flutter_auth/Agents/models/plantilla.dart';
import 'package:flutter_auth/components/menu_lateral.dart';

//import 'package:flutter_auth/Drivers/components/menu_lateralDriver.dart';
import '../../../constants.dart';

class DetailScreen extends StatefulWidget {
  final Plantilla plantilla;

    final DataAgent item;
  const DetailScreen({Key key, this.plantilla,  this.item}) : super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
    Future<DataAgent> item;
  
  @override  
  void initState() {  
    super.initState();  
    item = fetchRefres();  
  } 
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                setState(() {                  
                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context)=>
                  HomeScreen()), (Route<dynamic> route) => false);
                });
              },
            ),
            SizedBox(width: kDefaultPadding / 4)
          ],
          backgroundColor: kColorAppBar,
          elevation: 15,
        ),
        drawer: MenuLateral(),
        backgroundColor: widget.plantilla.color,
        //drawer: DriverMenuLateral(),
        body: Body(plantilla: widget.plantilla),
      ),
    );
  }
}
