import 'dart:convert';

import 'package:flutter/material.dart';
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
import 'package:flutter_auth/main.dart';
import 'package:flutter_svg/svg.dart';
import 'package:quickalert/quickalert.dart';
import '../../../components/AppBarPosterior.dart';
import 'package:http/http.dart' as http;

import '../../../components/progress_indicator.dart';

void main() {
  runApp(ProfilePage());
}

class ProfilePage extends StatefulWidget {
  //instancias de plantilla y perfil con sus variabless
  final Plantilla? plantilla;
  final Profile? item;
  final Profile? itemx;
  const ProfilePage({Key? key, this.plantilla, this.item, this.itemx})
      : super(key: key);
  @override
  _DataTableExample createState() => _DataTableExample();
}

class _DataTableExample extends State<ProfilePage> {
  //variables
  Future<Profile>? item;
  Future<DataAgent>? itemx;
  int indexWithIsChosenTrue = 0;

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
                  child: AppBarSuperior(item: 1,)
                ),
                body: Column(
                  children: [
                    Expanded(
                      child: body(),
                    ),
                    SafeArea(child: AppBarPosterior(item:1)),
                  ],
                ),
              ),
    );
  }

  Padding body() {
    Size size = MediaQuery.of(context).size;
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
          child: ListView(
            children: [
                SizedBox(height: 20.0),
                //future builder para Profile
                FutureBuilder<Profile>(
                  future: item,
                  builder: (BuildContext context, abc) {
                    if (abc.connectionState == ConnectionState.done) {
                      //ingreso de data
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start, // Alinea los textos a la izquierda
                            children: [
                                            
                              Center(
                                child: Stack(
                                  children: [
                                    
                                    Container(
                                      width: 100,
                                      height: 100,
                                      child: SvgPicture.asset(
                                        "assets/icons/Perfil_Usuario.svg",
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                            
                                    Positioned(
                                      top: 0,
                                      bottom: 0,
                                      right: 0,
                                      left: 0,
                                      child: Padding(
                                        padding: const EdgeInsets.all(25.0),
                                        child: Container(
                                          child: SvgPicture.asset(
                                            "assets/icons/usuario.svg",
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10),
                              Center(
                                child: Text(
                                  '${abc.data!.agentFullname}',
                                  style: Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 16, fontWeight: FontWeight.w500),
                                  ),
                              ),
                              SizedBox(height: 30),
                                            
                              if (prefs.companyId == "8") ...{
                                if (abc.data == null) ...{
                                  Padding(
                                    padding: const EdgeInsets.only(right: 5, left: 10, bottom: 4),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 18,
                                          height: 18,
                                          child: SvgPicture.asset(
                                            "assets/icons/Numeral.svg",
                                            color: Theme.of(context).primaryIconTheme.color,
                                          ),
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          'No. empleado: ',
                                          style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 16, fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: 1,
                                    color: Theme.of(context).dividerColor,
                                  ),
                                  SizedBox(height: 20),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 5, left: 10, bottom: 4),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 18,
                                          height: 18,
                                          child: SvgPicture.asset(
                                            "assets/icons/telefono_num.svg",
                                            color: Theme.of(context).primaryIconTheme.color,
                                          ),
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          'Teléfono: ',
                                          style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 16, fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: 1,
                                    color: Theme.of(context).dividerColor,
                                  ),
                                  SizedBox(height: 20),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 5, left: 10, bottom: 4),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 18,
                                          height: 18,
                                          child: SvgPicture.asset(
                                            "assets/icons/correo.svg",
                                            color: Theme.of(context).primaryIconTheme.color,
                                          ),
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          'Email: ',
                                          style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 16, fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: 1,
                                    color: Theme.of(context).dividerColor,
                                  ),
                                  SizedBox(height: 20),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 5, left: 10, bottom: 4),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 18,
                                          height: 18,
                                          child: SvgPicture.asset(
                                            "assets/icons/Casa.svg",
                                            color: Theme.of(context).primaryIconTheme.color,
                                          ),
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          'Dirección: ',
                                          style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 16, fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: 1,
                                    color: Theme.of(context).dividerColor,
                                  ),
                                  SizedBox(height: 20),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 5, left: 10, bottom: 4),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 18,
                                          height: 18,
                                          child: SvgPicture.asset(
                                            "assets/icons/warning.svg",
                                            color: Theme.of(context).primaryIconTheme.color,
                                          ),
                                        ),
                                        SizedBox(width: 5),
                                        Flexible(
                                          child: Text(
                                            'Acceso autorizado: ',
                                            style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 16, fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: 1,
                                    color: Theme.of(context).dividerColor,
                                  ),
                                  SizedBox(height: 20),
                                } else ...{
                                  Padding(
                                    padding: const EdgeInsets.only(right: 5, left: 10, bottom: 4),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 18,
                                          height: 18,
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
                                                  text: "No. empleado: ",
                                                  style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 16, fontWeight: FontWeight.w500),
                                                ),
                                                TextSpan(
                                                  text: "${abc.data!.agentUser}",
                                                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 16),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: 1,
                                    color: Theme.of(context).dividerColor,
                                  ),

                                  SizedBox(height: 20),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 5, left: 10, bottom: 4),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 18,
                                          height: 18,
                                          child: SvgPicture.asset(
                                            "assets/icons/telefono_num.svg",
                                            color: Theme.of(context).primaryIconTheme.color,
                                          ),
                                        ),
                                        SizedBox(width: 5),
                                        Flexible(
                                          child: RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: "Teléfono: ",
                                                  style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 16, fontWeight: FontWeight.w500),
                                                ),
                                                TextSpan(
                                                  text: "${abc.data!.agentPhone}",
                                                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 16),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: 1,
                                    color: Theme.of(context).dividerColor,
                                  ),
                                  SizedBox(height: 20),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 5, left: 10, bottom: 4),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 18,
                                          height: 18,
                                          child: SvgPicture.asset(
                                            "assets/icons/correo.svg",
                                            color: Theme.of(context).primaryIconTheme.color,
                                          ),
                                        ),
                                        SizedBox(width: 5),
                                        Flexible(
                                          child: RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: "Email: ",
                                                  style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 16, fontWeight: FontWeight.w500),
                                                ),
                                                TextSpan(
                                                  text: "${abc.data!.agentEmail}",
                                                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 16),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: 1,
                                    color: Theme.of(context).dividerColor,
                                  ),
                                  SizedBox(height: 20),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 5, left: 10, bottom: 4),
                                    child: GestureDetector(
                                      onTap: () async{
                                        LoadingIndicatorDialog().show(context);
                                        http.Response responses = await http.get(Uri.parse('https://admin.smtdriver.com/multipleAgentLocations/${abc.data!.agentId}'));
                                        final resp = json.decode(responses.body);
                                                                               
                                        if(resp['ok']==true){
                                          LoadingIndicatorDialog().dismiss();
                                          direcciones(size, context, resp);
                                        }else{
                                          LoadingIndicatorDialog().dismiss();
                                          QuickAlert.show(
                                            context: context,
                                            title: "Alerta",
                                            text: '${resp['message']}',
                                            type: QuickAlertType.error,
                                            confirmBtnText: "Ok"
                                          );
                                        }
                                      },
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 18,
                                            height: 18,
                                            child: SvgPicture.asset(
                                              "assets/icons/Casa.svg",
                                              color: Theme.of(context).primaryIconTheme.color,
                                            ),
                                          ),
                                          SizedBox(width: 5),
                                          Flexible(
                                            child: RichText(
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text: "Dirección: ",
                                                    style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 16, fontWeight: FontWeight.w500),
                                                  ),
                                                  TextSpan(
                                                    text: "${abc.data!.agentReferencePoint}, ${abc.data!.neighborhoodName}, ${abc.data!.townName}",
                                                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 16),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 5),
                                          Container(
                                            width: 18,
                                            height: 18,
                                            child: SvgPicture.asset(
                                              "assets/icons/flechahaciaabajo.svg",
                                              color: Theme.of(context).primaryIconTheme.color,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 1,
                                    color: Theme.of(context).dividerColor,
                                  ),
                                  SizedBox(height: 20),
                                  
                                  if (abc.data!.neighborhoodReferencePoint == null)
                                    ...{}
                                  else ...{
                                    Padding(
                                    padding: const EdgeInsets.only(right: 5, left: 10, bottom: 4),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 18,
                                          height: 18,
                                          child: SvgPicture.asset(
                                            "assets/icons/warning.svg",
                                            color: Theme.of(context).primaryIconTheme.color,
                                          ),
                                        ),
                                        SizedBox(width: 5),
                                        RichText(
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                text: "Acceso autorizado: ",
                                                style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 16, fontWeight: FontWeight.w500),
                                              ),
                                              TextSpan(
                                                text: "${abc.data!.neighborhoodReferencePoint}",
                                                style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 16),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: 1,
                                    color: Theme.of(context).dividerColor,
                                  ),
                                  SizedBox(height: 20),
                                  }
                                },
                              } else ...{
                                if (abc.data == null) ...{
                                  Padding(
                                    padding: const EdgeInsets.only(right: 5, left: 10, bottom: 4),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 18,
                                          height: 18,
                                          child: SvgPicture.asset(
                                            "assets/icons/Numeral.svg",
                                            color: Theme.of(context).primaryIconTheme.color,
                                          ),
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          'No. empleado: ',
                                          style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 16, fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: 1,
                                    color: Theme.of(context).dividerColor,
                                  ),
                                  SizedBox(height: 20),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 5, left: 10, bottom: 4),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 20,
                                          height: 20,
                                          child: SvgPicture.asset(
                                            "assets/icons/compania.svg",
                                            color: Theme.of(context).primaryIconTheme.color,
                                          ),
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          'Cuenta: ',
                                          style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 16, fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: 1,
                                    color: Theme.of(context).dividerColor,
                                  ),
                                  SizedBox(height: 20),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 5, left: 10, bottom: 4),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 18,
                                          height: 18,
                                          child: SvgPicture.asset(
                                            "assets/icons/telefono_num.svg",
                                            color: Theme.of(context).primaryIconTheme.color,
                                          ),
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          'Teléfono: ',
                                          style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 16, fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: 1,
                                    color: Theme.of(context).dividerColor,
                                  ),
                                  SizedBox(height: 20),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 5, left: 10, bottom: 4),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 18,
                                          height: 18,
                                          child: SvgPicture.asset(
                                            "assets/icons/correo.svg",
                                            color: Theme.of(context).primaryIconTheme.color,
                                          ),
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          'Email: ',
                                          style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 16, fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: 1,
                                    color: Theme.of(context).dividerColor,
                                  ),
                                  SizedBox(height: 20),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 5, left: 10, bottom: 4),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 18,
                                          height: 18,
                                          child: SvgPicture.asset(
                                            "assets/icons/Casa.svg",
                                            color: Theme.of(context).primaryIconTheme.color,
                                          ),
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          'Dirección: ',
                                          style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 16, fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: 1,
                                    color: Theme.of(context).dividerColor,
                                  ),
                                  SizedBox(height: 20),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 5, left: 10, bottom: 4),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 18,
                                          height: 18,
                                          child: SvgPicture.asset(
                                            "assets/icons/warning.svg",
                                            color: Theme.of(context).primaryIconTheme.color,
                                          ),
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          'Acceso autorizado: ',
                                          style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 16, fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: 1,
                                    color: Theme.of(context).dividerColor,
                                  ),
                                  SizedBox(height: 20),
                                } else ...{
                                  Padding(
                                    padding: const EdgeInsets.only(right: 5, left: 10, bottom: 4),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 18,
                                          height: 18,
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
                                                  text: "No. empleado: ",
                                                  style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 16, fontWeight: FontWeight.w500),
                                                ),
                                                TextSpan(
                                                  text: "${abc.data!.agentUser}",
                                                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 16),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: 1,
                                    color: Theme.of(context).dividerColor,
                                  ),
                                  SizedBox(height: 20),
                                  if (abc.data!.countName == null)
                                    ...{
                                      Padding(
                                    padding: const EdgeInsets.only(right: 5, left: 10, bottom: 4),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 20,
                                          height: 20,
                                          child: SvgPicture.asset(
                                            "assets/icons/compania.svg",
                                            color: Theme.of(context).primaryIconTheme.color,
                                          ),
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          'Cuenta: ',
                                          style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 16, fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: 1,
                                    color: Theme.of(context).dividerColor,
                                  ),
                                  SizedBox(height: 20),
                                    }
                                  else ...{
                                    Padding(
                                    padding: const EdgeInsets.only(right: 5, left: 10, bottom: 4),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 20,
                                          height: 20,
                                          child: SvgPicture.asset(
                                            "assets/icons/compania.svg",
                                            color: Theme.of(context).primaryIconTheme.color,
                                          ),
                                        ),
                                        SizedBox(width: 5),
                                        Flexible(
                                          child: RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: "Cuenta: ",
                                                  style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 16, fontWeight: FontWeight.w500),
                                                ),
                                                TextSpan(
                                                  text: "${abc.data!.countName}",
                                                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 16),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: 1,
                                    color: Theme.of(context).dividerColor,
                                  ),
                                  SizedBox(height: 20),
                                  },

                                  Padding(
                                    padding: const EdgeInsets.only(right: 5, left: 10, bottom: 4),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 18,
                                          height: 18,
                                          child: SvgPicture.asset(
                                            "assets/icons/telefono_num.svg",
                                            color: Theme.of(context).primaryIconTheme.color,
                                          ),
                                        ),
                                        SizedBox(width: 5),
                                        Flexible(
                                          child: RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: "Teléfono: ",
                                                  style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 16, fontWeight: FontWeight.w500),
                                                ),
                                                TextSpan(
                                                  text: "${abc.data!.agentPhone}",
                                                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 16),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: 1,
                                    color: Theme.of(context).dividerColor,
                                  ),
                                  SizedBox(height: 20),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 5, left: 10, bottom: 4),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 18,
                                          height: 18,
                                          child: SvgPicture.asset(
                                            "assets/icons/correo.svg",
                                            color: Theme.of(context).primaryIconTheme.color,
                                          ),
                                        ),
                                        SizedBox(width: 5),
                                        Flexible(
                                          child: RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: "Email: ",
                                                  style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 16, fontWeight: FontWeight.w500),
                                                ),
                                                TextSpan(
                                                  text: "${abc.data!.agentEmail}",
                                                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 16),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: 1,
                                    color: Theme.of(context).dividerColor,
                                  ),
                                  SizedBox(height: 20),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 5, left: 10, bottom: 4),
                                    child: GestureDetector(
                                      onTap: () async{
                                        LoadingIndicatorDialog().show(context);
                                        http.Response responses = await http.get(Uri.parse('https://admin.smtdriver.com/multipleAgentLocations/${abc.data!.agentId}'));
                                        final resp = json.decode(responses.body);
                                                                               
                                        if(resp['ok']==true){
                                          LoadingIndicatorDialog().dismiss();
                                          direcciones(size, context, resp);
                                        }else{
                                          LoadingIndicatorDialog().dismiss();
                                          QuickAlert.show(
                                            context: context,
                                            title: "Alerta",
                                            text: '${resp['message']}',
                                            type: QuickAlertType.error,
                                            confirmBtnText: "Ok"
                                          );
                                        }
                                        
                                      },
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 18,
                                            height: 18,
                                            child: SvgPicture.asset(
                                              "assets/icons/Casa.svg",
                                              color: Theme.of(context).primaryIconTheme.color,
                                            ),
                                          ),
                                          SizedBox(width: 5),
                                          Flexible(
                                            child: RichText(
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text: "Dirección: ",
                                                    style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 16, fontWeight: FontWeight.w500),
                                                  ),
                                                  TextSpan(
                                                    text: "${abc.data!.agentReferencePoint}, ${abc.data!.neighborhoodName}, ${abc.data!.townName}",
                                                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 16),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 5),
                                          Container(
                                            width: 18,
                                            height: 18,
                                            child: SvgPicture.asset(
                                              "assets/icons/flechahaciaabajo.svg",
                                              color: Theme.of(context).primaryIconTheme.color,
                                            ),
                                          ),                                       
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 1,
                                    color: Theme.of(context).dividerColor,
                                  ),
                                  SizedBox(height: 20),
                                  if (abc.data!.neighborhoodReferencePoint == null)
                                    ...{}
                                  else ...{
                                    Padding(
                                    padding: const EdgeInsets.only(right: 5, left: 10, bottom: 4),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 18,
                                          height: 18,
                                          child: SvgPicture.asset(
                                            "assets/icons/warning.svg",
                                            color: Theme.of(context).primaryIconTheme.color,
                                          ),
                                        ),
                                        SizedBox(width: 5),
                                        Flexible(
                                          child: RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: "Acceso autorizado: ",
                                                  style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 16, fontWeight: FontWeight.w500),
                                                ),
                                                TextSpan(
                                                  text: "${abc.data!.neighborhoodReferencePoint}",
                                                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 16),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: 1,
                                    color: Theme.of(context).dividerColor,
                                  ),
                                  SizedBox(height: 20),
                                  }
                                },
                              },
                            ],
                          ),
                        ),
                      );
                    } else {
                      return WillPopScope(
                      onWillPop: () async => false,
                      child: SimpleDialog(
                         elevation: 20,
                        backgroundColor: Theme.of(context).cardColor,
                        children: [
                          Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(left: 16, top: 16, right: 16),
                                  child: CircularProgressIndicator(),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Text(
                                    'Cargando..', 
                                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 18),
                                    ),
                                )
                              ],
                            ),
                          )
                        ] ,
                      ),
                    );
                    }
                  },
                ),
                SizedBox(height: 20.0),
                Center(
                    child: Text(
                  'Horario laboral',
                  style: Theme.of(context).textTheme.labelMedium!.copyWith(fontSize: 16, fontWeight: FontWeight.w500),
                )),
                //ingreso de data por el future builder horario
                FutureBuilder<Profile>(
                  future: item,
                  builder: (BuildContext context, abc) {
                    if (abc.connectionState == ConnectionState.done) {
                      //data
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15)),
                        child: Card(
                          color: Theme.of(context).cardColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          elevation: 0,
                          child: Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(10)),
                            margin: EdgeInsets.symmetric(horizontal: 5.0),
                            width: 550,
                            height: 400,
                            child: Column(
                              children: [
                                if (prefs.companyId == "8") ...{
                                  DataTable(
                                    columns: [
                                      DataColumn(
                                          label: Text('Día',
                                              style: Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 14, fontWeight: FontWeight.w500))),
                                      DataColumn(
                                          label: Text('Salida',
                                              style: Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 14, fontWeight: FontWeight.w500))),
                                    ],
                                    rows: [
                                      if (abc.data == null) ...{
                                        DataRow(cells: [
                                          DataCell(Text('Lunes',
                                              style: Theme.of(context).textTheme.bodyMedium)),
                                          DataCell(Text(''))
                                        ]),
                                        DataRow(cells: [
                                          DataCell(Text('Martes',
                                              style: Theme.of(context).textTheme.bodyMedium)),
                                          DataCell(Text(''))
                                        ]),
                                        DataRow(cells: [
                                          DataCell(Text('Miercoles',
                                              style: Theme.of(context).textTheme.bodyMedium)),
                                          DataCell(Text(''))
                                        ]),
                                        DataRow(cells: [
                                          DataCell(Text('Jueves',
                                              style: Theme.of(context).textTheme.bodyMedium)),
                                          DataCell(Text(''))
                                        ]),
                                        DataRow(cells: [
                                          DataCell(Text('Viernes',
                                              style: Theme.of(context).textTheme.bodyMedium)),
                                          DataCell(Text(''))
                                        ]),
                                        DataRow(cells: [
                                          DataCell(Text('Sábado',
                                              style: Theme.of(context).textTheme.bodyMedium)),
                                          DataCell(Text(''))
                                        ]),
                                        DataRow(cells: [
                                          DataCell(Text('Domingo',
                                              style: Theme.of(context).textTheme.bodyMedium)),
                                          DataCell(Text(''))
                                        ]),
                                      } else ...{
                                        DataRow(cells: [
                                          DataCell(Text('Lunes',
                                              style: Theme.of(context).textTheme.bodyMedium)),
                                          DataCell(FutureBuilder<Profile>(
                                              future: item,
                                              builder: (context, abc) {
                                                if (abc.connectionState ==
                                                    ConnectionState.done) {
                                                  if ('${abc.data!.mondayOut}' ==
                                                      'null') {
                                                    return Text('Día libre',style: Theme.of(context).textTheme.bodyMedium);
                                                  } else if (abc.hasData) {
                                                    return Text(
                                                        '${abc.data!.mondayOut}',
                                                        style: Theme.of(context).textTheme.bodyMedium);
                                                  }
                                                } else {
                                                  return CircularProgressIndicator();
                                                }
                                                return CircularProgressIndicator();
                                              }))
                                        ]),
                                        DataRow(cells: [
                                          DataCell(Text('Martes',
                                              style: Theme.of(context).textTheme.bodyMedium)),
                                          DataCell(FutureBuilder<Profile>(
                                              future: item,
                                              builder: (context, abc) {
                                                if (abc.connectionState ==
                                                    ConnectionState.done) {
                                                  if ('${abc.data!.tuesdayOut}' ==
                                                      'null') {
                                                    return Text('Día libre',style: Theme.of(context).textTheme.bodyMedium);
                                                  } else if (abc.hasData) {
                                                    return Text(
                                                        '${abc.data!.tuesdayOut}',
                                                        style: Theme.of(context).textTheme.bodyMedium);
                                                  }
                                                } else {
                                                  return CircularProgressIndicator();
                                                }
                                                return CircularProgressIndicator();
                                              }))
                                        ]),
                                        DataRow(cells: [
                                          DataCell(Text('Miercoles',
                                              style: Theme.of(context).textTheme.bodyMedium)),
                                          DataCell(FutureBuilder<Profile>(
                                              future: item,
                                              builder: (context, abc) {
                                                if (abc.connectionState ==
                                                    ConnectionState.done) {
                                                  if ('${abc.data!.wednesdayOut}' ==
                                                      'null') {
                                                    return Text('Día libre',style: Theme.of(context).textTheme.bodyMedium);
                                                  } else if (abc.hasData) {
                                                    return Text(
                                                        '${abc.data!.wednesdayOut}',
                                                        style: Theme.of(context).textTheme.bodyMedium);
                                                  }
                                                } else {
                                                  return CircularProgressIndicator();
                                                }
                    
                                                return CircularProgressIndicator();
                                              }))
                                        ]),
                                        DataRow(cells: [
                                          DataCell(Text('Jueves',
                                              style: Theme.of(context).textTheme.bodyMedium)),
                                          DataCell(FutureBuilder<Profile>(
                                              future: item,
                                              builder: (context, abc) {
                                                if (abc.connectionState ==
                                                    ConnectionState.done) {
                                                  if ('${abc.data!.thursdayOut}' ==
                                                      'null') {
                                                    return Text('Día libre',style: Theme.of(context).textTheme.bodyMedium);
                                                  } else if (abc.hasData) {
                                                    return Text(
                                                        '${abc.data!.thursdayOut}',
                                                        style: Theme.of(context).textTheme.bodyMedium);
                                                  }
                                                } else {
                                                  return CircularProgressIndicator();
                                                }
                                                return CircularProgressIndicator();
                                              }))
                                        ]),
                                        DataRow(cells: [
                                          DataCell(Text('Viernes',
                                              style: Theme.of(context).textTheme.bodyMedium)),
                                          DataCell(FutureBuilder<Profile>(
                                              future: item,
                                              builder: (context, abc) {
                                                if (abc.connectionState ==
                                                    ConnectionState.done) {
                                                  if ('${abc.data!.fridayOut}' ==
                                                      'null') {
                                                    return Text('Día libre',style: Theme.of(context).textTheme.bodyMedium);
                                                  } else if (abc.hasData) {
                                                    return Text(
                                                        '${abc.data!.fridayOut}',
                                                        style: Theme.of(context).textTheme.bodyMedium);
                                                  }
                                                } else {
                                                  return CircularProgressIndicator();
                                                }
                                                return CircularProgressIndicator();
                                              }))
                                        ]),
                                        DataRow(cells: [
                                          DataCell(Text('Sábado',
                                              style: TextStyle(
                                                  color: Colors.white))),
                                          DataCell(FutureBuilder<Profile>(
                                              future: item,
                                              builder: (context, abc) {
                                                if (abc.connectionState ==
                                                    ConnectionState.done) {
                                                  if ('${abc.data!.saturdayOut}' ==
                                                      'null') {
                                                    return Text('Día libre',style: Theme.of(context).textTheme.bodyMedium);
                                                  } else if (abc.hasData) {
                                                    return Text(
                                                        '${abc.data!.saturdayOut}',
                                                        style: Theme.of(context).textTheme.bodyMedium);
                                                  }
                                                } else {
                                                  return CircularProgressIndicator();
                                                }
                                                return CircularProgressIndicator();
                                              }))
                                        ]),
                                        DataRow(cells: [
                                          DataCell(Text('Domingo',
                                              style: TextStyle(
                                                  color: Colors.black))),
                                          DataCell(FutureBuilder<Profile>(
                                              future: item,
                                              builder: (context, abc) {
                                                if (abc.connectionState ==
                                                    ConnectionState.done) {
                                                  if ('${abc.data!.sundayOut}' ==
                                                      'null') {
                                                    return Text('Día libre',style: Theme.of(context).textTheme.bodyMedium);
                                                  } else if (abc.hasData) {
                                                    return Text(
                                                        '${abc.data!.sundayOut}',
                                                        style: Theme.of(context).textTheme.bodyMedium);
                                                  }
                                                } else {
                                                  return CircularProgressIndicator();
                                                }
                                                return CircularProgressIndicator();
                                              }))
                                        ]),
                                      },
                                    ],
                                  ),
                                } else ...{
                                  DataTable(
                                    columns: [
                                      DataColumn(
                                          label: Text('Día',
                                              style: Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 14, fontWeight: FontWeight.w500))),
                                      DataColumn(
                                          label: Text('Entrada',
                                              style: Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 14, fontWeight: FontWeight.w500))),
                                      DataColumn(
                                          label: Text('Salida',
                                              style: Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 14, fontWeight: FontWeight.w500))),
                                    ],
                                    rows: [
                                      if (abc.data == null) ...{
                                        DataRow(cells: [
                                          DataCell(Text('Lunes',
                                              style: Theme.of(context).textTheme.bodyMedium)),
                                          DataCell(Text('')),
                                          DataCell(Text(''))
                                        ]),
                                        DataRow(cells: [
                                          DataCell(Text('Martes',
                                              style: Theme.of(context).textTheme.bodyMedium)),
                                          DataCell(Text('')),
                                          DataCell(Text(''))
                                        ]),
                                        DataRow(cells: [
                                          DataCell(Text('Miercoles',
                                              style: Theme.of(context).textTheme.bodyMedium)),
                                          DataCell(Text('')),
                                          DataCell(Text(''))
                                        ]),
                                        DataRow(cells: [
                                          DataCell(Text('Jueves',
                                              style: Theme.of(context).textTheme.bodyMedium)),
                                          DataCell(Text('')),
                                          DataCell(Text(''))
                                        ]),
                                        DataRow(cells: [
                                          DataCell(Text('Viernes',
                                              style: Theme.of(context).textTheme.bodyMedium)),
                                          DataCell(Text('')),
                                          DataCell(Text(''))
                                        ]),
                                        DataRow(cells: [
                                          DataCell(Text('Sábado',
                                              style:Theme.of(context).textTheme.bodyMedium)),
                                          DataCell(Text('')),
                                          DataCell(Text(''))
                                        ]),
                                        DataRow(cells: [
                                          DataCell(Text('Domingo',
                                              style: Theme.of(context).textTheme.bodyMedium)),
                                          DataCell(Text('')),
                                          DataCell(Text(''))
                                        ]),
                                      } else ...{
                                        DataRow(cells: [
                                          DataCell(Text('Lunes',
                                              style: Theme.of(context).textTheme.bodyMedium)),
                                          DataCell(FutureBuilder<Profile>(
                                              future: item,
                                              builder: (context, abc) {
                                                if (abc.connectionState ==
                                                    ConnectionState.done) {
                                                  if ('${abc.data!.mondayIn}' ==
                                                      'null') {
                                                    return Text('Día libre',
                                                        style: Theme.of(context).textTheme.bodyMedium);
                                                  } else if (abc.hasData) {
                                                    return Text(
                                                        '${abc.data!.mondayIn}',
                                                        style: Theme.of(context).textTheme.bodyMedium);
                                                  }
                                                } else {
                                                  return CircularProgressIndicator();
                                                }
                                                return CircularProgressIndicator();
                                              })),
                                          DataCell(FutureBuilder<Profile>(
                                              future: item,
                                              builder: (context, abc) {
                                                if (abc.connectionState ==
                                                    ConnectionState.done) {
                                                  if ('${abc.data!.mondayOut}' ==
                                                      'null') {
                                                    return Text(
                                                      'Día libre',
                                                      style: Theme.of(context).textTheme.bodyMedium);
                                                  } else if (abc.hasData) {
                                                    return Text(
                                                        '${abc.data!.mondayOut}',
                                                        style: Theme.of(context).textTheme.bodyMedium);
                                                  }
                                                } else {
                                                  return CircularProgressIndicator();
                                                }
                                                return CircularProgressIndicator();
                                              }))
                                        ]),
                                        DataRow(cells: [
                                          DataCell(Text('Martes',
                                              style: Theme.of(context).textTheme.bodyMedium)),
                                          DataCell(FutureBuilder<Profile>(
                                              future: item,
                                              builder: (context, abc) {
                                                if (abc.connectionState ==
                                                    ConnectionState.done) {
                                                  if ('${abc.data!.tuesdayIn}' ==
                                                      'null') {
                                                    return Text('Día libre',
                                                        style: Theme.of(context).textTheme.bodyMedium);
                                                  } else if (abc.hasData) {
                                                    return Text(
                                                        '${abc.data!.tuesdayIn}',
                                                        style: Theme.of(context).textTheme.bodyMedium);
                                                  }
                                                } else {
                                                  return CircularProgressIndicator();
                                                }
                                                return CircularProgressIndicator();
                                              })),
                                          DataCell(FutureBuilder<Profile>(
                                              future: item,
                                              builder: (context, abc) {
                                                if (abc.connectionState ==
                                                    ConnectionState.done) {
                                                  if ('${abc.data!.tuesdayOut}' ==
                                                      'null') {
                                                    return Text('Día libre',
                                                        style: Theme.of(context).textTheme.bodyMedium);
                                                  } else if (abc.hasData) {
                                                    return Text(
                                                        '${abc.data!.tuesdayOut}',
                                                        style: Theme.of(context).textTheme.bodyMedium);
                                                  }
                                                } else {
                                                  return CircularProgressIndicator();
                                                }
                                                return CircularProgressIndicator();
                                              }))
                                        ]),
                                        DataRow(cells: [
                                          DataCell(Text('Miercoles',
                                              style: Theme.of(context).textTheme.bodyMedium)),
                                          DataCell(FutureBuilder<Profile>(
                                              future: item,
                                              builder: (context, abc) {
                                                if (abc.connectionState ==
                                                    ConnectionState.done) {
                                                  if ('${abc.data!.wednesdayIn}' ==
                                                      'null') {
                                                    return Text('Día libre',style: Theme.of(context).textTheme.bodyMedium);
                                                  } else if (abc.hasData) {
                                                    return Text(
                                                        '${abc.data!.wednesdayIn}',
                                                        style: Theme.of(context).textTheme.bodyMedium);
                                                  }
                                                } else {
                                                  return CircularProgressIndicator();
                                                }
                                                return CircularProgressIndicator();
                                              })),
                                          DataCell(FutureBuilder<Profile>(
                                              future: item,
                                              builder: (context, abc) {
                                                if (abc.connectionState ==
                                                    ConnectionState.done) {
                                                  if ('${abc.data!.wednesdayOut}' ==
                                                      'null') {
                                                    return Text('Día libre',style: Theme.of(context).textTheme.bodyMedium);
                                                  } else if (abc.hasData) {
                                                    return Text(
                                                        '${abc.data!.wednesdayOut}',
                                                        style: Theme.of(context).textTheme.bodyMedium);
                                                  }
                                                } else {
                                                  return CircularProgressIndicator();
                                                }
                    
                                                return CircularProgressIndicator();
                                              }))
                                        ]),
                                        DataRow(cells: [
                                          DataCell(Text('Jueves',
                                              style: Theme.of(context).textTheme.bodyMedium)),
                                          DataCell(FutureBuilder<Profile>(
                                              future: item,
                                              builder: (context, abc) {
                                                if (abc.connectionState ==
                                                    ConnectionState.done) {
                                                  if ('${abc.data!.thursdayIn}' ==
                                                      'null') {
                                                    return Text('Día libre',style: Theme.of(context).textTheme.bodyMedium);
                                                  } else if (abc.hasData) {
                                                    return Text(
                                                        '${abc.data!.thursdayIn}',
                                                        style: Theme.of(context).textTheme.bodyMedium);
                                                  }
                                                } else {
                                                  return CircularProgressIndicator();
                                                }
                                                return CircularProgressIndicator();
                                              })),
                                          DataCell(FutureBuilder<Profile>(
                                              future: item,
                                              builder: (context, abc) {
                                                if (abc.connectionState ==
                                                    ConnectionState.done) {
                                                  if ('${abc.data!.thursdayOut}' ==
                                                      'null') {
                                                    return Text('Día libre',style: Theme.of(context).textTheme.bodyMedium);
                                                  } else if (abc.hasData) {
                                                    return Text(
                                                        '${abc.data!.thursdayOut}',
                                                        style: Theme.of(context).textTheme.bodyMedium);
                                                  }
                                                } else {
                                                  return CircularProgressIndicator();
                                                }
                                                return CircularProgressIndicator();
                                              }))
                                        ]),
                                        DataRow(cells: [
                                          DataCell(Text('Viernes',
                                              style: Theme.of(context).textTheme.bodyMedium)),
                                          DataCell(FutureBuilder<Profile>(
                                              future: item,
                                              builder: (context, abc) {
                                                if (abc.connectionState ==
                                                    ConnectionState.done) {
                                                  if ('${abc.data!.fridayIn}' ==
                                                      'null') {
                                                    return Text('Día libre',style: Theme.of(context).textTheme.bodyMedium);
                                                  } else if (abc.hasData) {
                                                    return Text(
                                                        '${abc.data!.fridayIn}',
                                                        style: Theme.of(context).textTheme.bodyMedium);
                                                  }
                                                } else {
                                                  return CircularProgressIndicator();
                                                }
                                                return CircularProgressIndicator();
                                              })),
                                          DataCell(FutureBuilder<Profile>(
                                              future: item,
                                              builder: (context, abc) {
                                                if (abc.connectionState ==
                                                    ConnectionState.done) {
                                                  if ('${abc.data!.fridayOut}' ==
                                                      'null') {
                                                    return Text('Día libre',style: Theme.of(context).textTheme.bodyMedium);
                                                  } else if (abc.hasData) {
                                                    return Text(
                                                        '${abc.data!.fridayOut}',
                                                        style: Theme.of(context).textTheme.bodyMedium);
                                                  }
                                                } else {
                                                  return CircularProgressIndicator();
                                                }
                                                return CircularProgressIndicator();
                                              }))
                                        ]),
                                        DataRow(cells: [
                                          DataCell(Text('Sábado',
                                              style: Theme.of(context).textTheme.bodyMedium)),
                                          DataCell(FutureBuilder<Profile>(
                                              future: item,
                                              builder: (context, abc) {
                                                if (abc.connectionState ==
                                                    ConnectionState.done) {
                                                  if ('${abc.data!.saturdayIn}' ==
                                                      'null') {
                                                    return Text('Día libre',style: Theme.of(context).textTheme.bodyMedium);
                                                  } else if (abc.hasData) {
                                                    return Text(
                                                        '${abc.data!.saturdayIn}',
                                                        style: Theme.of(context).textTheme.bodyMedium);
                                                  }
                                                } else {
                                                  return CircularProgressIndicator();
                                                }
                                                return CircularProgressIndicator();
                                              })),
                                          DataCell(FutureBuilder<Profile>(
                                              future: item,
                                              builder: (context, abc) {
                                                if (abc.connectionState ==
                                                    ConnectionState.done) {
                                                  if ('${abc.data!.saturdayOut}' ==
                                                      'null') {
                                                    return Text('Día libre',style: Theme.of(context).textTheme.bodyMedium);
                                                  } else if (abc.hasData) {
                                                    return Text(
                                                        '${abc.data!.saturdayOut}',
                                                        style: Theme.of(context).textTheme.bodyMedium);
                                                  }
                                                } else {
                                                  return CircularProgressIndicator();
                                                }
                                                return CircularProgressIndicator();
                                              }))
                                        ]),
                                        DataRow(cells: [
                                          DataCell(Text('Domingo',
                                              style: Theme.of(context).textTheme.bodyMedium)),
                                          DataCell(FutureBuilder<Profile>(
                                              future: item,
                                              builder: (context, abc) {
                                                if (abc.connectionState ==
                                                    ConnectionState.done) {
                                                  if ('${abc.data!.sundayIn}' ==
                                                      'null') {
                                                    return Text('Día libre',style: Theme.of(context).textTheme.bodyMedium);
                                                  } else if (abc.hasData) {
                                                    return Text(
                                                        '${abc.data!.sundayIn}',
                                                        style: Theme.of(context).textTheme.bodyMedium);
                                                  }
                                                } else {
                                                  return CircularProgressIndicator();
                                                }
                                                return CircularProgressIndicator();
                                              })),
                                          DataCell(FutureBuilder<Profile>(
                                              future: item,
                                              builder: (context, abc) {
                                                if (abc.connectionState ==
                                                    ConnectionState.done) {
                                                  if ('${abc.data!.sundayOut}' ==
                                                      'null') {
                                                    return Text('Día libre',style: Theme.of(context).textTheme.bodyMedium);
                                                  } else if (abc.hasData) {
                                                    return Text(
                                                        '${abc.data!.sundayOut}',
                                                        style: Theme.of(context).textTheme.bodyMedium);
                                                  }
                                                } else {
                                                  return CircularProgressIndicator();
                                                }
                                                return CircularProgressIndicator();
                                              }))
                                        ]),
                                      },
                                    ],
                                  ),
                                },
                              ],
                            ),
                          ),
                        ),
                      );
                    } else {
                      return WillPopScope(
                      onWillPop: () async => false,
                      child: SimpleDialog(
                         elevation: 20,
                        backgroundColor: Theme.of(context).cardColor,
                        children: [
                          Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(left: 16, top: 16, right: 16),
                                  child: CircularProgressIndicator(),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Text(
                                    'Cargando..', 
                                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 18),
                                    ),
                                )
                              ],
                            ),
                          )
                        ] ,
                      ),
                    );
                    }
                  },
                ),

                FutureBuilder<DataAgent>(
                    future: itemx,
                    builder: (context, abc) {
                      if (abc.connectionState == ConnectionState.done) {
                        if (abc.data!.companyId != 7) {
                          return Center(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return DetailScreenChanges(plantilla: plantilla[3]);
                                }));
                              },
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "¿Tu información es incorrecta? ",
                                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 12)
                                    ),
                                    TextSpan(
                                      text: "Solicita un cambio aquí",
                                      style: Theme.of(context).textTheme.labelMedium!.copyWith(fontSize: 12)
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        } else {
                          Text('');
                        }
                      } else {
                        return Text("");
                      }
                      return Text("");
                    }
                          ),
              SizedBox(height: 50)
            ]
          ),
        ),
      ),
    );
  }

  Future<Object?> direcciones(Size size, BuildContext context, var resp) {
  
    if( resp['res'].length>0){
      for (int i = 0; i < resp['res'].length; i++) {
        if (resp['res'][i]['isChosen'] == true) {
          indexWithIsChosenTrue = i;
          break; // Termina el bucle una vez que se encuentra el elemento deseado
        }
      }
    }

    return showGeneralDialog(
                                          barrierColor: Colors.black.withOpacity(0.6),
                                          transitionBuilder: (context, a1, a2, widget) {
                                            final curvedValue = Curves.easeInOut.transform(a1.value);
                                            return StatefulBuilder(
                                              builder: (context, setState){
                                                return Transform.translate(
                                              offset: Offset(0.0, (1 - curvedValue) * size.height / 2),
                                              child: Opacity(
                                                opacity: a1.value,
                                                child: Align(
                                                  alignment: Alignment.bottomCenter,
                                                  child: Container(
                                                    width: size.width,
                                                    decoration: BoxDecoration(
                                                      color: Theme.of(navigatorKey.currentContext!).cardColor,
                                                      borderRadius: BorderRadius.only(
                                                        topLeft: Radius.circular(30.0),
                                                        topRight: Radius.circular(30.0),
                                                      ),
                                                    ),
                                                    child: Padding(
                                                      padding: const EdgeInsets.symmetric(horizontal: 30),
                                                      child: SingleChildScrollView(
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Padding(
                                                              padding: const EdgeInsets.only(
                                                                  right: 120, left: 120, top: 15, bottom: 20),
                                                              child: GestureDetector(
                                                                onTap: () => Navigator.pop(context),
                                                                child: Container(
                                                                  decoration: BoxDecoration(
                                                                      color: Theme.of(navigatorKey.currentContext!).dividerColor,
                                                                      borderRadius:
                                                                          BorderRadius.circular(80)),
                                                                  height: 6,
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(height: 10),
                                                            Center(
                                                              child: Text(
                                                                'Tus direcciones',
                                                                style: Theme.of(navigatorKey.currentContext!).textTheme.labelMedium!.copyWith(fontSize: 20, fontWeight: FontWeight.w500),
                                                              ),
                                                            ),
                                                            SizedBox(height: 30),
                                                            resp['res'].length>0?
                                                            Column(
                                                              children: List.generate(
                                                              resp['res'].length,
                                                              (index) {
                                                                return Padding(
                                                                  padding: const EdgeInsets.only(bottom: 10),
                                                                  child: Column(
                                                                    children: [
                                                                      GestureDetector(
                                                                        onTap: () async{
                                                                
                                                                          if(index!=indexWithIsChosenTrue){
                                                                            LoadingIndicatorDialog().show(context);
                                                                            var data = {
                                                                              'agentLocationId': resp['res'][index]['agentLocationId'].toString(), 
                                                                              'userId' : resp['res'][index]['agentId'].toString(), 
                                                                              'userAgent': 'mobile'
                                                                            };
                                                                
                                                                            http.Response response = await http.post(Uri.parse('https://admin.smtdriver.com/chooseLocationAgent'), body: data);
                                                                
                                                                            var dataR = json.decode(response.body);
                                                                            
                                                                            if(dataR['ok']==true){
                                                                              LoadingIndicatorDialog().dismiss();
                                                                              setState(() {
                                                                                resp['res'][indexWithIsChosenTrue]['isChosen']=false;
                                                                                resp['res'][index]['isChosen']=true;
                                                                
                                                                                indexWithIsChosenTrue = index;                                                                                                                                         
                                                                              });
                                                                
                                                                              QuickAlert.show(
                                                                                context: navigatorKey.currentContext!,
                                                                                title: dataR['message'].toString(),
                                                                                text: dataR['db'][0]['msg'].toString(),
                                                                                type: QuickAlertType.success,
                                                                                confirmBtnText: "Ok"
                                                                              );
                                                                            }else{
                                                                              LoadingIndicatorDialog().dismiss();
                                                                              QuickAlert.show(
                                                                                context: navigatorKey.currentContext!,
                                                                                title: dataR['message'].toString(),
                                                                                text: dataR['db'][0]['msg'].toString(),
                                                                                type: QuickAlertType.error,
                                                                                confirmBtnText: "Ok"
                                                                              );
                                                                            }
                                                                          }                                                                    
                                                                        },
                                                                        child: Row(
                                                                          children: [
                                                                            Container(
                                                                              width: 24,
                                                                              height: 24,
                                                                              child: SvgPicture.asset(
                                                                                "assets/icons/accesoautorizado.svg",
                                                                                color: Theme.of(navigatorKey.currentContext!).primaryIconTheme.color,
                                                                              ),
                                                                            ),
                                                                            SizedBox(width: 5),
                                                                            Flexible(
                                                                              child: Text(
                                                                                '${resp['res'][index]['locationReferencePoint']}, ${resp['res'][index]['neighborhoodReferencePoint']}, ${resp['res'][index]['townName']}',
                                                                                style: Theme.of(navigatorKey.currentContext!).textTheme.bodyMedium!.copyWith(fontSize: 18),
                                                                              ),
                                                                            ),
                                                                            
                                                                            Padding(
                                                                              padding: const EdgeInsets.only(left: 20),
                                                                              child: Container(
                                                                                width: 24,
                                                                                height: 24,
                                                                                child: SvgPicture.asset(
                                                                                  "assets/icons/check.svg",
                                                                                  color: resp['res'][index]['isChosen']==true? Color.fromRGBO(40, 169, 83, 1): Colors.transparent,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      SizedBox(height: 5),
                                                                      Container(
                                                                        height: 1,
                                                                        color: Theme.of(navigatorKey.currentContext!).dividerColor,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                );
                                                              }
                                                            ),
                                                            )
                                                            : 
                                                            Center(
                                                              child: Text(
                                                                'No tiene direcciones disponibles.',
                                                                style: Theme.of(navigatorKey.currentContext!).textTheme.bodyMedium!.copyWith(fontSize: 18),
                                                              ),
                                                            ),
                                                                                      
                                                            SizedBox(height: 40),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                              }
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
  }
}