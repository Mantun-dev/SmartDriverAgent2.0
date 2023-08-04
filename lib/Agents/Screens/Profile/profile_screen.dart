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
import 'package:flutter_svg/svg.dart';
import '../../../components/AppBarPosterior.dart';

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
                                      ],
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
                                      ],
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
}