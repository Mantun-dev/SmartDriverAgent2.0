import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
//import 'package:flutter_auth/Agents/Screens/Chat/chatapis.dart';

import 'package:flutter_auth/Agents/Screens/HomeAgents/components/body.dart';
import 'package:flutter_auth/Agents/Screens/Login/login_screen.dart';
import 'package:flutter_auth/Agents/models/network.dart';
//import 'package:flutter_auth/Agents/models/profileAgent.dart';
//import 'package:flutter_auth/Agents/models/network.dart';
import 'package:flutter_auth/components/AppBarSuperior.dart';
//import 'package:http/http.dart' as http;
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import '../../../components/AppBarPosterior.dart';
import '../../../components/backgroundH.dart';

class HomeScreen extends StatefulWidget {
    
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {  
  //final StreamSocket streamSocket = StreamSocket(host: 'djc5t.localtonet.com');
  String? agentId;
  @override
  void initState() {    
    super.initState(); 
    WidgetsBinding.instance.addObserver(this);

    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          this.closeSession();
        });
      }
    });

    fetchProfile().then((val){      
      prefs.usuarioId = val.agentId!;
    });
  }
    void didChangeAppLifecycleState(AppLifecycleState state) {
    // setState(() {
    // });
    if (AppLifecycleState.resumed == state) {
      if(mounted){
        //print('hola');
        closeSession();
        //Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) =>DetailScreen(plantilla: plantilla[0])),(Route<dynamic> route) => false);
      }
    }
  }

  closeSession() async {
    fetchRefres().then((value) {
      if (value.disabled == 1 ) {
        fetchDeleteSession();
        prefs.remove();
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => LoginScreen()),
            (Route<dynamic> route) => false);
            QuickAlert.show(
              context: context,
              type: QuickAlertType.error,
              title: "Lo sentimos",
              text: "Usuario deshabilitado",
            );
      }
    });
  }

  @override
  void dispose() {    
    super.dispose();
    WidgetsBinding.instance.addObserver(this);
    //streamSocket.close();
  }
  
  @override
  Widget build(BuildContext context) {
    return BackgroundHome(
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
                  appBar: PreferredSize(
                    preferredSize: Size.fromHeight(56),
                    child: AppBarSuperior(item: 0,)
                  ),
                  body: Column(
                    children: [
                      Expanded(
                        child: Body(),
                      ),
                      SafeArea(child: AppBarPosterior(item:0)),
                    ],
                  ),
                ),
      ),
    );
  }
}
