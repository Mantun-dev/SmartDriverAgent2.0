import 'package:flutter/material.dart';
//import 'package:flutter_auth/Agents/models/dataAgent.dart';
//import 'package:flutter_auth/Agents/models/profileAgent.dart';
//import 'package:flutter_auth/Agents/sharePrefers/preferencias_usuario.dart';
import 'package:flutter_auth/components/AppBarSuperior.dart';
import 'package:flutter_auth/components/backgroundB.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../components/AppBarPosterior.dart';

class TripCalification extends StatefulWidget {

  final nombreMotorista;
  final idViaje;
  final fechaViaje;
  final calificacionConduccion;
  final calificacionAmabilidad;
  final calificacionVehiculo;
  final comentario;
  final fechaComentario;
  final adminComentario;
  final adminComentarioFecha;
  final adminNombre;

  const TripCalification({
    Key? key,
    required this.nombreMotorista,
    required this.idViaje,
    required this.fechaViaje,
    required this.calificacionConduccion,
    required this.calificacionAmabilidad,
    required this.calificacionVehiculo,
    required this.comentario,
    required this.fechaComentario,
    required this.adminComentario,
    required this.adminComentarioFecha,
    required this.adminNombre
  }) : super(key: key);
  @override
  _DataTableExample createState() => _DataTableExample();
}

class _DataTableExample extends State<TripCalification> {


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundBody(
      child: Scaffold(
        backgroundColor: Colors.transparent,
                appBar: PreferredSize(
                  preferredSize: Size.fromHeight(56),
                  child: AppBarSuperior(item: 33)
                ),
                body: Column(
                  children: [
                    Expanded(
                      child: body(),
                    ),
                    SafeArea(child: AppBarPosterior(item:-1)),
                  ],
                ),
              ),
    );
  }

  Widget body() {

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: ConstrainedBox(
        constraints: BoxConstraints(
        maxWidth: 700.0, // Aquí defines el ancho máximo deseado
      ),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all( 
              color: Theme.of(context).disabledColor,
              width: 2
            ),
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(20)
          ),

          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: ListView(
              children: [
          
                Container(
                  width: 100,
                  height: 100,
                  child: Image.asset(
                    "assets/images/perfilmotorista.png",
                  ),
                ),
                
                SizedBox(height: 10),
          
                Center(
                  child: Text(
                    'Viaje con ${this.widget.nombreMotorista}',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                ),

                SizedBox(height: 25),

                Row(
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      child: SvgPicture.asset(
                        "assets/icons/Numeral.svg",
                        color: Theme.of(context).primaryIconTheme.color,
                      ),
                    ),
                    SizedBox(width: 5),
                    Flexible(
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Viaje: ",
                              style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 15, fontWeight: FontWeight.w500),
                            ),
                            TextSpan(
                              text: "${this.widget.idViaje}",
                              style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 10),

                Row(
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      child: SvgPicture.asset(
                        "assets/icons/calendar2.svg",
                        color: Theme.of(context).primaryIconTheme.color,
                      ),
                    ),
                    SizedBox(width: 5),
                    Flexible(
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Fecha: ",
                              style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 15, fontWeight: FontWeight.w500),
                            ),
                            TextSpan(
                              text: "${this.widget.fechaViaje}",
                              style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 25),

                Center(
                  child: Text(
                    'Calificación y comentarios',
                    style: Theme.of(context).textTheme.labelMedium!.copyWith(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                ),

                SizedBox(height: 20),

                Center(
                  child: Text(
                    '${this.widget.calificacionConduccion}.0',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 45, fontWeight: FontWeight.w500),
                  ),
                ),

                SizedBox(height: 10),

                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      Stack(
                        children: [
                          Container(
                            width: 38,
                            height: 38,
                            child: SvgPicture.asset(
                              "assets/icons/estrella.svg",
                              color: this.widget.calificacionConduccion >0? Colors.black:Color.fromRGBO(228, 228, 228, 1),
                            ),
                          ),
                          if(this.widget.calificacionConduccion>0)...{
                            Positioned.fill(
                              child: Align(
                                alignment: Alignment.center,
                                child: Container(
                                  width: 32,
                                  height: 32,
                                  child: SvgPicture.asset(
                                    "assets/icons/estrella.svg",
                                    color: Colors.yellow,
                                  ),
                                ),
                              ),
                            ),
                          }
                        ],
                      ),

                    SizedBox(width: 20),

                    Stack(
                        children: [
                          Container(
                            width: 38,
                            height: 38,
                            child: SvgPicture.asset(
                              "assets/icons/estrella.svg",
                              color: this.widget.calificacionConduccion >0? Colors.black:Color.fromRGBO(228, 228, 228, 1),
                            ),
                          ),
                          if(this.widget.calificacionConduccion>0)...{
                            Positioned.fill(
                              child: Align(
                                alignment: Alignment.center,
                                child: Container(
                                  width: 32,
                                  height: 32,
                                  child: SvgPicture.asset(
                                    "assets/icons/estrella.svg",
                                    color: Colors.yellow,
                                  ),
                                ),
                              ),
                            ),
                          }
                        ],
                      ),

                    SizedBox(width: 20),

                    Stack(
                        children: [
                          Container(
                            width: 38,
                            height: 38,
                            child: SvgPicture.asset(
                              "assets/icons/estrella.svg",
                              color: this.widget.calificacionConduccion >0? Colors.black:Color.fromRGBO(228, 228, 228, 1),
                            ),
                          ),
                          if(this.widget.calificacionConduccion>0)...{
                            Positioned.fill(
                              child: Align(
                                alignment: Alignment.center,
                                child: Container(
                                  width: 32,
                                  height: 32,
                                  child: SvgPicture.asset(
                                    "assets/icons/estrella.svg",
                                    color: Colors.yellow,
                                  ),
                                ),
                              ),
                            ),
                          }
                        ],
                      ),

                    SizedBox(width: 20),

                    Stack(
                        children: [
                          Container(
                            width: 38,
                            height: 38,
                            child: SvgPicture.asset(
                              "assets/icons/estrella.svg",
                              color: this.widget.calificacionConduccion >4? Colors.black:Color.fromRGBO(228, 228, 228, 1),
                            ),
                          ),
                          if(this.widget.calificacionConduccion>4)...{
                            Positioned.fill(
                              child: Align(
                                alignment: Alignment.center,
                                child: Container(
                                  width: 32,
                                  height: 32,
                                  child: SvgPicture.asset(
                                    "assets/icons/estrella.svg",
                                    color: Colors.yellow,
                                  ),
                                ),
                              ),
                            ),
                          }
                        ],
                      ),

                    SizedBox(width: 20),

                      Stack(
                        children: [
                          Container(
                            width: 38,
                            height: 38,
                            child: SvgPicture.asset(
                              "assets/icons/estrella.svg",
                              color: this.widget.calificacionConduccion >4? Colors.black:Color.fromRGBO(228, 228, 228, 1),
                            ),
                          ),
                          if(this.widget.calificacionConduccion>4)...{
                            Positioned.fill(
                              child: Align(
                                alignment: Alignment.center,
                                child: Container(
                                  width: 32,
                                  height: 32,
                                  child: SvgPicture.asset(
                                    "assets/icons/estrella.svg",
                                    color: Colors.yellow,
                                  ),
                                ),
                              ),
                            ),
                          }
                        ],
                      ),

                    ],
                  ),
                )
          
              ],
            ),
          ),
        )
      )
    );
  }
}