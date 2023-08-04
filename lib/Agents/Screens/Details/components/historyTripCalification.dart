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
  final calificacion;

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
    required this.adminNombre,
    required this.calificacion
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
            padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 30),
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
                              style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 15, fontWeight: FontWeight.normal),
                            ),
                            TextSpan(
                              text: "${this.widget.idViaje}",
                              style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 15, fontWeight: FontWeight.w500),
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
                              style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 15, fontWeight: FontWeight.normal),
                            ),
                            TextSpan(
                              text: "${this.widget.fechaViaje}",
                              style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 15, fontWeight: FontWeight.w400),
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
                    'Calificación',
                    style: Theme.of(context).textTheme.labelMedium!.copyWith(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                ),

                SizedBox(height: 15),

                Center(
                  child: Text(
                    '${this.widget.calificacion}.0',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 35, fontWeight: FontWeight.w500),
                  ),
                ),

                SizedBox(height: 15),

                Center(
                  child: Text(
                    'Conducción',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
                conduccion(),

                SizedBox(height: 25),

                Center(
                  child: Text(
                    'Amabilidad del motorista',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
                amabilidad(),

                SizedBox(height: 25),

                Center(
                  child: Text(
                    'Condiciones del vehículo',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
                condicion(),

                SizedBox(height: 25),

                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage("assets/images/perfil-usuario-general.png"), // Cambia la ruta al archivo PNG
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Tú',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),

                SizedBox(height: 5),

                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Fecha: ",
                            style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 12, fontWeight: FontWeight.normal),
                          ),
                          TextSpan(
                            text: "${this.widget.fechaViaje}",
                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 12, fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    ),

                SizedBox(height: 10),

                Text(
                  '${this.widget.comentario}',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 15, fontWeight: FontWeight.normal),
                ),

                SizedBox(height: 10),

                Container(
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(228, 228, 228, 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                '${this.widget.adminNombre}',
                                style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w500),
                              ),
                            ),
                                  
                            Text(
                              'Fecha: ',
                              style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.black, fontSize: 15, fontWeight: FontWeight.normal),
                            ),
                                  
                            Text(
                              '${this.widget.adminComentarioFecha}',
                              style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                                  
                        SizedBox(height: 10),
                                  
                        Align(
                          alignment: Alignment.centerLeft, // Alineación izquierda para el último Text
                          child: Text(
                            '${this.widget.adminComentario}',
                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.black, fontSize: 15, fontWeight: FontWeight.normal),
                          ),
                        ),
                                  
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 10),

              ],
            ),
          ),
        )
      )
    );
  }

  Column conduccion() {
    return Column(
                children: [
                  SizedBox(height: 5),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        Icon(
                          Icons.sentiment_very_dissatisfied,
                          size: 50,
                          color: this.widget.calificacionConduccion > 0
                              ? Colors.red
                              : Color.fromRGBO(228, 228, 228, 1),
                        ),

                      SizedBox(width: 5),

                      Icon(
                        Icons.sentiment_dissatisfied,
                        size: 50,
                        color: this.widget.calificacionConduccion > 1
                            ? Colors.redAccent
                            : Color.fromRGBO(228, 228, 228, 1),
                      ),

                      SizedBox(width: 5),

                      Icon(
                        Icons.sentiment_neutral,
                        size: 50,
                        color: this.widget.calificacionConduccion > 2
                            ? Colors.amber
                            : Color.fromRGBO(228, 228, 228, 1),
                      ),

                      SizedBox(width: 5),

                      Icon(
                        Icons.sentiment_satisfied,
                        size: 50,
                        color: this.widget.calificacionConduccion > 3
                            ? Colors.lightGreen
                            : Color.fromRGBO(228, 228, 228, 1),
                      ),

                      SizedBox(width: 5),

                        Icon(
                          Icons.sentiment_very_satisfied,
                          size: 50,
                          color: this.widget.calificacionConduccion > 4
                              ? Colors.green
                              : Color.fromRGBO(228, 228, 228, 1),
                        ),

                      ],
                    ),
                  )
                ],
              );
  }

  Column amabilidad() {
    return Column(
                children: [
                  SizedBox(height: 5),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        Icon(
                          Icons.sentiment_very_dissatisfied,
                          size: 50,
                          color: this.widget.calificacionAmabilidad > 0
                              ? Colors.red
                              : Color.fromRGBO(228, 228, 228, 1),
                        ),

                      SizedBox(width: 5),

                      Icon(
                        Icons.sentiment_dissatisfied,
                        size: 50,
                        color: this.widget.calificacionAmabilidad > 1
                            ? Colors.redAccent
                            : Color.fromRGBO(228, 228, 228, 1),
                      ),

                      SizedBox(width: 5),

                      Icon(
                        Icons.sentiment_neutral,
                        size: 50,
                        color: this.widget.calificacionAmabilidad > 2
                            ? Colors.amber
                            : Color.fromRGBO(228, 228, 228, 1),
                      ),

                      SizedBox(width: 5),

                      Icon(
                        Icons.sentiment_satisfied,
                        size: 50,
                        color: this.widget.calificacionAmabilidad > 3
                            ? Colors.lightGreen
                            : Color.fromRGBO(228, 228, 228, 1),
                      ),

                      SizedBox(width: 5),

                        Icon(
                          Icons.sentiment_very_satisfied,
                          size: 50,
                          color: this.widget.calificacionAmabilidad > 4
                              ? Colors.green
                              : Color.fromRGBO(228, 228, 228, 1),
                        ),

                      ],
                    ),
                  )
                ],
              );
  }

  Column condicion() {
    return Column(
                children: [
                  SizedBox(height: 5),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        Icon(
                          Icons.sentiment_very_dissatisfied,
                          size: 50,
                          color: this.widget.calificacionVehiculo > 0
                              ? Colors.red
                              : Color.fromRGBO(228, 228, 228, 1),
                        ),

                      SizedBox(width: 5),

                      Icon(
                        Icons.sentiment_dissatisfied,
                        size: 50,
                        color: this.widget.calificacionVehiculo > 1
                            ? Colors.redAccent
                            : Color.fromRGBO(228, 228, 228, 1),
                      ),

                      SizedBox(width: 5),

                      Icon(
                        Icons.sentiment_neutral,
                        size: 50,
                        color: this.widget.calificacionVehiculo > 2
                            ? Colors.amber
                            : Color.fromRGBO(228, 228, 228, 1),
                      ),

                      SizedBox(width: 5),

                      Icon(
                        Icons.sentiment_satisfied,
                        size: 50,
                        color: this.widget.calificacionVehiculo > 3
                            ? Colors.lightGreen
                            : Color.fromRGBO(228, 228, 228, 1),
                      ),

                      SizedBox(width: 5),

                        Icon(
                          Icons.sentiment_very_satisfied,
                          size: 50,
                          color: this.widget.calificacionVehiculo > 4
                              ? Colors.green
                              : Color.fromRGBO(228, 228, 228, 1),
                        ),

                      ],
                    ),
                  )
                ],
              );
  }
}