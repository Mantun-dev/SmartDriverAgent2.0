import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_auth/Agents/Screens/Details/details_screen.dart';
import 'package:flutter_auth/Agents/Screens/HomeAgents/components/background.dart';
import 'package:flutter_auth/Agents/Screens/HomeAgents/components/item_card.dart';
import 'package:flutter_auth/Agents/Screens/HomeAgents/components/rateMyDriver.dart';
import 'package:flutter_auth/Agents/Screens/Welcome/welcome_screen.dart';
import 'package:flutter_auth/Agents/models/dataAgent.dart';
import 'package:flutter_auth/Agents/models/messageCount.dart';
import 'package:flutter_auth/Agents/models/plantilla.dart';
import 'package:flutter_auth/Agents/sharePrefers/preferencias_usuario.dart';
import 'package:flutter_auth/Agents/models/network.dart';
import 'package:flutter_auth/constants.dart';
import 'package:sweetalert/sweetalert.dart';
import 'package:package_info/package_info.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show json;

import 'package:url_launcher/url_launcher.dart';


class Body extends StatefulWidget {
  //declaración de la clase data agen y su variable item
  final DataAgent item;

  const Body({Key key, this.item}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  
  //variables globales para HomeAgents
  int _value;
  Future<DataAgent> item;
  final prefs = new PreferenciasUsuario();  
  String ip = "https://smtdriver.com";
  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
  );
  
  //variables y funciones que necesitan inialización
  @override
  void initState() { 
  super.initState();
    _value = 0;
    //realización callback para mostrar cuentas en agentes

    SchedulerBinding.instance.addPostFrameCallback((_){
    if (mounted) {
      
      setState(() {        
       this._showErrorAlert();
      });
    }
    }
    ); 

 
   SchedulerBinding.instance.addPostFrameCallback((_){
     if (mounted) {
     setState(() {        
      this._showAlert();
     });
      
     }
    }
     );    
      //callback
    _initPackageInfo();
    //fetchVersion(); 
    // SchedulerBinding.instance.addPostFrameCallback((_){
    //   if (mounted) {        
    //     setState(() {        
    //   //    _showVersionTrue();
    //     });
    //   }
    // });
   

    item = fetchRefres();
  }
  Future<void> _initPackageInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
      prefs.versionOld = _packageInfo.version;
    });
  }


  void _showVersionTrue() async{    
      //validacion
      if (prefs.versionOld != prefs.versionNew) {
        showAlertVersion();        
      }    
   
  }
  _launchURL() async {
  const url = 'https://play.google.com/store/apps/details?id=com.smartdriver.devs';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

  showAlertVersion()async{
    showGeneralDialog(
      barrierColor: Colors.black.withOpacity(0.5),
      transitionBuilder: (context, a1, a2, widget) {
        final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
        return Transform(transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
          child: Opacity(opacity: a1.value,
            child:AlertDialog(
        content: Container(
          width: 400,
          height: 140,
          child: Column(
            children: <Widget>[

              Icon(Icons.warning, color: Colors.orangeAccent, size: 35.0),
              SizedBox(height: 10),
              Text(
                'Actualización disponible',
                style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold
                ),
              ),

              SizedBox(height: 20),
              Row(
                mainAxisAlignment:MainAxisAlignment.spaceAround,
                children: [
                  
                    TextButton(
                      style: TextButton.styleFrom(
                        primary: Colors.white,
                        backgroundColor: Colors.orange
                      ),
                      onPressed: () => {
                            Navigator.pop(context),                                            
                      },
                      child: Text('Después'),                
                    ), 
                   
                  Column(
                    children: [

                    TextButton(
                      style: TextButton.styleFrom(
                        primary: Colors.white,
                        backgroundColor: Colors.green
                      ),
                      onPressed: () => {
                            Navigator.pop(context),
                                                                              
                            _launchURL(),
                            
                      },
                      child: Text('Descargar'),                
                    ), 
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      )
    ) );
        
    },
    transitionDuration: Duration(milliseconds: 200),
    barrierDismissible: false,
    barrierLabel: '',
    context: context,
    pageBuilder: (context, animation1, animation2) {
      return null;
    }); 
  
}

//función fetch para enviar la cuenta seleccionada 
  Future<dynamic>fetchCountSend(String agentId, String countId) async {
    Map data = {
      'agentId' : agentId,
      'countId' : countId
    };
    //apis para send Count
    http.Response responses = await http.get(Uri.encodeFull('$ip/api/refreshingAgentData/${prefs.nombreUsuario}'));
    final si = DataAgent.fromJson(json.decode(responses.body));
    http.Response response = await http.get(Uri.encodeFull('$ip/api/getCounts/${si.companyId}'));
    Map<String, dynamic>.from(json.decode(response.body));
    http.Response respons = await http.post(Uri.encodeFull('$ip/api/registerCount'), body: data);
    //alertas 
    final yep = MessageAccount.fromJson(json.decode(respons.body));
      if (yep.ok == true && respons.statusCode == 200  && countId == '0' ) {    
          SweetAlert.show(context,
          title: 'Cuentas',
          subtitle: ' No ha seleccionado una cuenta valida\n si no desea hacerlo presione cancelar.',
          style: SweetAlertStyle.error
        );        
      }else if(yep.ok == true && respons.statusCode == 200){
        SweetAlert.show(context,
          title: yep.title,
          subtitle: yep.message,
          style: SweetAlertStyle.success
        );              
      }    
    return Map<String, dynamic>.from(json.decode(response.body));
  }

  @override
  Widget build(BuildContext context) {    
    RateMyApp();
    return SingleChildScrollView(
      child: Container(
        child: Background(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(padding: EdgeInsets.only(top: 10.0),
                child: Text('Smart Driver',style: Theme.of(context).textTheme.headline4.copyWith(fontWeight: FontWeight.bold),),                   
              ),
              SizedBox(height: 15), 

              //future builder para hacer la validación que aparezcan 3 o las 4 cards
              // las que necesarias a mostrar
              FutureBuilder<DataAgent>(
                future: item,                
                builder: (BuildContext context, abc) {
                  if (abc.connectionState == ConnectionState.done) {
                    //validación
                    if (abc.data.companyId != 7) {
                      return Expanded(
                        child: Padding(padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
                        child: GridView.builder(
                          //todas las cards
                          itemCount: plantilla.length,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,mainAxisSpacing: kDefaultPadding,crossAxisSpacing: kDefaultPadding,childAspectRatio: 0.60),
                          itemBuilder: (context, index) => ItemCard(
                            plantilla: plantilla[index],                        
                            press: () { 
                              setState((){Navigator.push(context,MaterialPageRoute(builder: (context) {return DetailScreen(plantilla: plantilla[index]);}));});
                            }
                          )
                        ),
                      ));
                    }else{
                      return Expanded(
                        child: Padding(padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
                        child: GridView.builder(
                          //3 cards
                          itemCount: 3,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,mainAxisSpacing: kDefaultPadding,crossAxisSpacing: kDefaultPadding,childAspectRatio: 0.60),
                          itemBuilder: (context, index) => ItemCard(
                            plantilla: plantilla[index],                        
                            press: () { 
                              setState((){Navigator.push(context,MaterialPageRoute(builder: (context) {return DetailScreen(plantilla: plantilla[index]);}));});
                            }
                          )
                        ),
                      ));
                    }
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              ),
              SizedBox(height: 50)
            ],
          ),
        ),
      ),
    );
  } 


//función onChanged para el valor de la cuenta
  void onChanged(int value) async{
    setState((){
      _value = value;
    });
  }


// función hace la validación de mostrar alerta
  void _showErrorAlert() async{
    http.Response responses = await http.get(Uri.encodeFull('$ip/api/refreshingAgentData/${prefs.nombreUsuario}'));
    final si = DataAgent.fromJson(json.decode(responses.body));
    http.Response response = await http.get(Uri.encodeFull('$ip/api/getCounts/${si.companyId}'));
    Map<String, dynamic> no = new Map<String, dynamic>.from(json.decode(response.body));
    print(no['counts'].length);
    //aquí se hace la validación de mostra cuando sea null el countId
    if(no['counts'].length == 0 || no['counts'].length == null){

    }else{
      if (si.countId == null) {
       showAlertDialog();
      }
    }                          
  }

//función de creación de alerta para mostrar cuentas de agente
  showAlertDialog()async{
    //apis de manera directa para obtener la data
    http.Response responses = await http.get(Uri.encodeFull('$ip/api/refreshingAgentData/${prefs.nombreUsuario}'));
    final si = DataAgent.fromJson(json.decode(responses.body));
    http.Response response = await http.get(Uri.encodeFull('$ip/api/getCounts/${si.companyId}'));
    Map<String, dynamic> no = new Map<String, dynamic>.from(json.decode(response.body));
    showGeneralDialog(
      barrierColor: Colors.black.withOpacity(0.5),
      transitionBuilder: (context, a1, a2, widget) {
        final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
        return Transform(transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
          child: Opacity(opacity: a1.value,
            child: AlertDialog(
              shape: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
              title: Center(child: Text('¿A qué cuenta pertenece?')), 
              content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState){
                return Container(height: 200,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        //iteración de cuentas, muestra cada una de ellas con su valor
                        for (int i = 0; i < no['counts'].length; i++)...{                              
                          ListTile(                              
                            title: Text('${no['counts'][i]['countName']}',style: Theme.of(context).textTheme.subtitle1.copyWith(color: i == no['counts'].length ? Colors.black38 : Colors.black),),
                            leading: Radio(
                              value: no['counts'][i]['countId'],
                              groupValue: _value,                              
                              activeColor: Colors.blue,
                              onChanged: i == no['counts'].length ? null : (value){                                                                      
                              setState(() {
                                onChanged(value);
                                print(value);                                      
                              });},                                                                  
                            ),                              
                                ),
                        }, 
                      ]
                    ),
                  ),
                );
              }),                  
              actions:<Widget> [                          
                TextButton(style: TextButton.styleFrom(primary: Colors.white,backgroundColor: Colors.green,),
                  onPressed: () => {
                      setState((){
                        //función fetch send count
                        fetchCountSend(si.agentId.toString(), _value.toString());
                        Navigator.pop(context);                                                  
                      }),
                  },
                  child: Text('Enviar'),                            
                ),                                  
                TextButton(style: TextButton.styleFrom(primary: Colors.white,backgroundColor: Colors.blueAccent),
                  onPressed: () => {
                    Navigator.pop(context),
                  },
                  child: Text('Cerrar'),                                                            
                ),
                SizedBox(width: 55.0),                                            
              ],
            ),
          ),
        );
      },
      transitionDuration: Duration(milliseconds: 200),
      barrierDismissible: true,
      barrierLabel: '',
      context: context,
      pageBuilder: (context, animation1, animation2) {
        return null;
      });      
  }


void _showAlert()async{
    http.Response responses = await http.get(Uri.encodeFull('$ip/api/refreshingAgentData/${prefs.nombreUsuario}'));
    final si = DataAgent.fromJson(json.decode(responses.body));

    if (si.agentStatus == false) {
      showAlertDialogMessage();
    }
}
  //función de creación de alerta para mostrar cuentas de agente
  showAlertDialogMessage(){
    //apis de manera directa para obtener la data
    showGeneralDialog(
      barrierColor: Colors.black.withOpacity(0.5),
      transitionBuilder: (context, a1, a2, widget) {
        final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
        return Transform(transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
          child: Opacity(opacity: a1.value,
            child: AlertDialog(
              shape: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
              title: Center(child: Text("🔺¡Usuario no agendado!🔺",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: kCardColor2,)),), 
              content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState){
                return Container(height: 120,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [                                                 
                          SizedBox(height: 5),
                          if (prefs.companyId == "7")... {
                            Text('Este usuario no está siendo agendado para el servicio de transporte, comuniquese con su supervisor.',style: TextStyle(color: kgray)),                                                    
                          } else... {
                            Text('Este usuario no está siendo agendado para el servicio de transporte, sin embargo, puede solicitar el uso de transporte mediante un ticket.',style: TextStyle(color: kgray)),                        
                          }
                      ]
                    ),
                  ),
                );
              }),                  
              actions:<Widget> [                          
                Center(
                  child: TextButton(style: TextButton.styleFrom(primary: Colors.white,backgroundColor: Colors.green,),
                    onPressed: () => {
                        setState((){
                          Navigator.pop(context);                                                  
                        }),
                    },
                    child: Text('Entendido'),                            
                  ),
                ),                                                                                
              ],
            ),
          ),
        );
      },
      transitionDuration: Duration(milliseconds: 200),
      barrierDismissible: true,
      barrierLabel: '',
      context: context,
      pageBuilder: (context, animation1, animation2) {
        return null;
      });      
  }

}
