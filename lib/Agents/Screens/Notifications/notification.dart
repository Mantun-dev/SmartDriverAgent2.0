import 'package:flutter/material.dart';
import 'package:flutter_auth/Agents/Screens/Details/components/loader.dart';
import 'package:flutter_auth/Agents/Screens/Details/details_screen_changes.dart';
import 'package:flutter_auth/Agents/models/dataAgent.dart';
import 'package:flutter_auth/Agents/models/network.dart';
//import 'package:flutter_auth/Agents/models/dataAgent.dart';
import 'package:flutter_auth/Agents/models/plantilla.dart';
import 'package:flutter_auth/Agents/models/profileAgent.dart';
//import 'package:flutter_auth/Agents/models/profileAgent.dart';
//import 'package:flutter_auth/Agents/sharePrefers/preferencias_usuario.dart';
import 'package:flutter_auth/components/AppBarSuperior.dart';
import 'package:flutter_auth/components/backgroundB.dart';
import 'package:flutter_auth/components/solictud_cambio.dart';
import 'package:flutter_svg/svg.dart';
import '../../../components/AppBarPosterior.dart';

void main() {
  runApp(NotificationPage());
}

class NotificationPage extends StatefulWidget {
  //instancias de plantilla y perfil con sus variabless

  @override
  _NotificationPage createState() => _NotificationPage();
}

class _NotificationPage extends State<NotificationPage> {
  //variables
  Future<Profile>? item;
  Future<DataAgent>? itemx;

  @override
  void initState() {
    super.initState();
    itemx = fetchRefres();
    //indexar variable a fetch
    item = fetchProfile();
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundBody(
      child: Scaffold(
        backgroundColor: Colors.transparent,
                appBar: PreferredSize(
                  preferredSize: Size.fromHeight(56),
                  child: AppBarSuperior(item: 8)
                ),
                body: Column(
                  children: [
                    Expanded(
                      child: body(),
                    ),
                    AppBarPosterior(item:2),
                  ],
                ),
              ),
    );
  }

  Widget body(){
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all( 
            color: Color.fromRGBO(238, 238, 238, 1),
            width: 2
          ),
          color: Colors.white,
          borderRadius: BorderRadius.circular(20)
        ),

        child: Column(
          children: [
            Text(
              'Hoy',
              style: TextStyle(
                
              ),
            ),
          ],
        ),
        
      ),
    );
  }
}
