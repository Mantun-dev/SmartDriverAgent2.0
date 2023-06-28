
import 'package:flutter/material.dart';
import 'package:flutter_auth/Agents/Screens/HomeAgents/homeScreen_Agents.dart';
import 'package:flutter_auth/Agents/Screens/Profile/profile_screen.dart';
import 'package:flutter_auth/components/progress_indicator.dart';
import 'package:flutter_svg/svg.dart';
import 'package:quickalert/quickalert.dart';

import '../Agents/Screens/Details/details_screen.dart';
import '../Agents/Screens/Details/details_screen_changes.dart';
import '../Agents/Screens/Details/details_screen_history.dart';
import '../Agents/Screens/Details/details_screen_qr.dart';
import '../Agents/Screens/Welcome/welcome_screen.dart';
import '../Agents/models/network.dart';
import '../Agents/models/plantilla.dart';


class AppBarSuperior extends StatefulWidget {
  final int? item;

  AppBarSuperior({this.item});

  @override
  _AppBarSuperior createState() => _AppBarSuperior(item: item);
}

class _AppBarSuperior extends State<AppBarSuperior> {
  int? item;

  _AppBarSuperior({this.item});

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return AppBar(
      backgroundColor: Theme.of(context).primaryColor,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white, size: 25),
      automaticallyImplyLeading: false, 
      actions: <Widget>[

        item!=0?Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              if(item==7){
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return DetailScreenChanges(plantilla: plantilla[3]);
                }));
              }
              else{
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return HomeScreen();
                  })
                );
              }
            },
            child: Container(
              width: 45,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white,
                  width: 0.5,
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: SvgPicture.asset(
                  "assets/icons/flecha_atras_oscuro.svg",
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ):Padding(
          padding: const EdgeInsets.all(8.0),
          child: menu(size, context),
        ),

        if(item==0)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top:8.0),
              child: Container(
                width: 110,
                height: 110,
                child: Image.asset('assets/images/logo.png'),
              ),
            ),
          ),

        if(item==1)
          Expanded(
            child: Center(
              child: Text(
                "Datos personales",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.normal,
                  fontSize: 21
                ),
              ),
            ),
          ),

          if(item==2)
          Expanded(
            child: Center(
              child: Text(
                "Próximos viajes",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.normal,
                  fontSize: 21
                ),
              ),
            ),
          ),

          if(item==3)
          Expanded(
            child: Center(
              child: Text(
                "Historial de viajes",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.normal,
                  fontSize: 21
                ),
              ),
            ),
          ),

          if(item==4)
          Expanded(
            child: Center(
              child: Text(
                "Código QR",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.normal,
                  fontSize: 21
                ),
              ),
            ),
          ),

          if(item==5)
          Expanded(
            child: Center(
              child: Text(
                "Solicitud de cambios",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.normal,
                  fontSize: 21
                ),
              ),
            ),
          ),

          if(item==6)
          Expanded(
            child: Center(
              child: Text(
                "Salas",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.normal,
                  fontSize: 21
                ),
              ),
            ),
          ),

          if(item==7)
          Expanded(
            child: Center(
              child: Text(
                "Tus tickets",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.normal,
                  fontSize: 21
                ),
              ),
            ),
          ),

          if(item==8)
          Expanded(
            child: Center(
              child: Text(
                "Notificaciones",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.normal,
                  fontSize: 21
                ),
              ),
            ),
          ),

        item==0?Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 40,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white,
                    width: 0.5,
                  ),
                borderRadius: BorderRadius.circular(10.0),
                ),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return ProfilePage();
                      })
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SvgPicture.asset(
                      "assets/icons/usuario.svg",
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
                top: 5,
                right: 5,
                child: Container(
                  width: 10,
                  height: 10,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color.fromRGBO(0, 255, 85, 1),
                          border: Border.all(color: Colors.black, width: 0.5),
                    )),
              ),
          ],
        ):Padding(
          padding: const EdgeInsets.all(8.0),
          child: menu(size, context),
        )
        
      ],
    );
  }

  Container menu(size, contextP) {
    return Container(
      width: 45,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white,
          width: 0.5,
        ),
      borderRadius: BorderRadius.circular(10.0),
      ),
      child: IconButton(
        icon: Icon(
          Icons.menu,
          color: Colors.white,
        ),
        onPressed: () {
          showGeneralDialog(
            barrierColor: Colors.black.withOpacity(0.6),
            transitionBuilder: (context, a1, a2, widget) {
              final curvedValue = Curves.easeInOut.transform(a1.value);
              return Transform.translate(
                offset: Offset(0.0, (1 - curvedValue) * size.height / 2),
                child: Opacity(
                  opacity: a1.value,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: size.height / 2,
                      width: size.width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30.0),
                          topRight: Radius.circular(30.0),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 120, left: 120, top: 15, bottom: 20),
                              child: GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Color.fromRGBO(187, 187, 187, 1),
                                    borderRadius: BorderRadius.circular(80)
                                  ),
                                  height: 6,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.push(
                                    contextP,
                                    MaterialPageRoute(builder: (contextP) {
                                      return ProfilePage();
                                    })
                                  );
                                },
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 25,
                                            height: 25,
                                            child: SvgPicture.asset(
                                              "assets/icons/usuario.svg",
                                              color: Color.fromRGBO(40, 93, 169, 1),
                                            ),
                                          ),
                                          Text(
                                            ' Mi perfil',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.normal,
                                              decoration: TextDecoration.none,
                                              fontFamily: 'Roboto'
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: 15,
                                      height: 15,
                                      child: SvgPicture.asset(
                                        "assets/icons/flechader.svg",
                                        color: Color.fromRGBO(40, 93, 169, 1),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 12),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.push(contextP, MaterialPageRoute(builder: (contextP) {
                                  return DetailScreen(plantilla: plantilla[0]);
                                }));
                                },
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 25,
                                            height: 25,
                                            child: SvgPicture.asset(
                                              "assets/icons/proximo_viaje.svg",
                                              color: Color.fromRGBO(40, 93, 169, 1),
                                            ),
                                          ),
                                          Text(' Próximos viajes', 
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.normal,
                                              decoration: TextDecoration.none,
                                              fontFamily: 'Roboto'
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: 15,
                                      height: 15,
                                      child: SvgPicture.asset(
                                        "assets/icons/flechader.svg",
                                        color: Color.fromRGBO(40, 93, 169, 1),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                           SizedBox(height: 12),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.push(contextP, MaterialPageRoute(builder: (contextP) {
                                  return DetailScreenHistoryTrip(plantilla: plantilla[1]);
                                }));
                                },
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 25,
                                            height: 25,
                                            child: SvgPicture.asset(
                                              "assets/icons/historial_de_viaje.svg",
                                              color: Color.fromRGBO(40, 93, 169, 1),
                                            ),
                                          ),
                                          Text(' Historial de viajes', 
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.normal,
                                              decoration: TextDecoration.none,
                                              fontFamily: 'Roboto'
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: 15,
                                      height: 15,
                                      child: SvgPicture.asset(
                                        "assets/icons/flechader.svg",
                                        color: Color.fromRGBO(40, 93, 169, 1),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 12),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.push(contextP, MaterialPageRoute(builder: (contextP) {
                                  return DetailScreenQr(plantilla: plantilla[2]);
                                }));
                                },
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 25,
                                            height: 25,
                                            child: SvgPicture.asset(
                                              "assets/icons/QR.svg",
                                              color: Color.fromRGBO(40, 93, 169, 1),
                                            ),
                                          ),
                                          Text(' Generar código QR', 
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.normal,
                                              decoration: TextDecoration.none,
                                              fontFamily: 'Roboto'
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: 15,
                                      height: 15,
                                      child: SvgPicture.asset(
                                        "assets/icons/flechader.svg",
                                        color: Color.fromRGBO(40, 93, 169, 1),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 12),                                                     
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);

                                  Navigator.push(contextP, MaterialPageRoute(builder: (contextP) {
                                  return DetailScreenChanges(plantilla: plantilla[3]);
                                }));
                                },
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 25,
                                            height: 25,
                                            child: SvgPicture.asset(
                                              "assets/icons/solicitud_de_cambio.svg",
                                              color: Color.fromRGBO(40, 93, 169, 1),
                                            ),
                                          ),
                                          Text(' Solicitud de cambios', 
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.normal,
                                              decoration: TextDecoration.none,
                                              fontFamily: 'Roboto'
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: 15,
                                      height: 15,
                                      child: SvgPicture.asset(
                                        "assets/icons/flechader.svg",
                                        color: Color.fromRGBO(40, 93, 169, 1),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 12),      
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              child: GestureDetector(
                                onTap: () {
                                  
                                },
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 25,
                                            height: 25,
                                            child: SvgPicture.asset(
                                              "assets/icons/tema.svg",
                                              color: Color.fromRGBO(40, 93, 169, 1),
                                            ),
                                          ),
                                          Text(' Tema', 
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.normal,
                                              decoration: TextDecoration.none,
                                              fontFamily: 'Roboto'
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: 15,
                                      height: 15,
                                      child: SvgPicture.asset(
                                        "assets/icons/flechader.svg",
                                        color: Color.fromRGBO(40, 93, 169, 1),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 12),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              child: GestureDetector(
                                onTap: () {
                                  
                                },
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 25,
                                            height: 25,
                                            child: SvgPicture.asset(
                                              "assets/icons/idioma.svg",
                                              color: Color.fromRGBO(40, 93, 169, 1),
                                            ),
                                          ),
                                          Text(' Idiomas', 
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.normal,
                                              decoration: TextDecoration.none,
                                              fontFamily: 'Roboto'
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: 15,
                                      height: 15,
                                      child: SvgPicture.asset(
                                        "assets/icons/flechader.svg",
                                        color: Color.fromRGBO(40, 93, 169, 1),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            
                            SizedBox(height: 12),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              child: GestureDetector(
                                onTap: () {
                                            QuickAlert.show(
                                              context: context,
                                              title: "Está seguro que desea salir?",          
                                              type: QuickAlertType.success,
                                              confirmBtnText: 'Confirmar',
                                              cancelBtnText: 'Cancelar',
                                              showCancelBtn: true,  
                                              confirmBtnTextStyle: TextStyle(fontSize: 15, color: Colors.white),
                                              cancelBtnTextStyle:TextStyle(color: Colors.red, fontSize: 15, fontWeight:FontWeight.bold ), 
                                              onConfirmBtnTap:() {
                                                LoadingIndicatorDialog().show(context);

                                                fetchDeleteSession();
                                                prefs.remove();
                                                prefs.removeData();
                                                
                                                new Future.delayed(new Duration(seconds: 2), () {
                                                  LoadingIndicatorDialog().dismiss();
                                                  Navigator.pop(context);
                                                  Navigator.pop(context);
                                                  Navigator.of(contextP).pushAndRemoveUntil(
                                                      MaterialPageRoute(
                                                          builder: (BuildContext contextP) => WelcomeScreen()),
                                                      (Route<dynamic> route) => false);
                                                      QuickAlert.show(
                                                        context: context,
                                                        type: QuickAlertType.success,
                                                        text: "¡Gracias por usar Smart Driver!",
                                                      );
                                                });
                                              },
                                              onCancelBtnTap: (() {
                                                Navigator.pop(context);
                                                Navigator.pop(context);
                                                /*QuickAlert.show(
                                                  context: context,
                                                  type: QuickAlertType.success,
                                                  text: "Cancelado",
                                                );*/
                                              })
                                            );
                                },
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 25,
                                            height: 25,
                                            child: SvgPicture.asset(
                                              "assets/icons/cerrar-sesion.svg",
                                              color: Color.fromRGBO(40, 93, 169, 1),
                                            ),
                                          ),
                                          Text(' Cerrar sesión', 
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.normal,
                                              decoration: TextDecoration.none,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: 15,
                                      height: 15,
                                      child: SvgPicture.asset(
                                        "assets/icons/flechader.svg",
                                        color: Color.fromRGBO(40, 93, 169, 1),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
            transitionDuration: Duration(milliseconds: 200),
            barrierDismissible: true,
            barrierLabel: '',
            context: context,
            pageBuilder: (context, animation1, animation2) {
              return widget;
            },
          );

            
        },
      ),
    );
      
  }

}
