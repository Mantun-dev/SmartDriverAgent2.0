import 'package:flutter/material.dart';
import 'package:flutter_auth/Agents/Screens/Details/components/body.dart';
import 'package:flutter_auth/Agents/models/dataAgent.dart';
import 'package:flutter_auth/Agents/models/network.dart';
import 'package:flutter_auth/Agents/models/plantilla.dart';
import 'package:flutter_auth/components/AppBarSuperior.dart';

//import 'package:flutter_auth/Drivers/components/menu_lateralDriver.dart';
import '../../../components/AppBarPosterior.dart';
import '../../../components/backgroundB.dart';

class DetailScreenChanges extends StatefulWidget {
  final Plantilla plantilla;

  final DataAgent? item;
  const DetailScreenChanges({Key? key, required this.plantilla, this.item})
      : super(key: key);

  @override
  _DetailScreenChangesState createState() => _DetailScreenChangesState();
}

class _DetailScreenChangesState extends State<DetailScreenChanges> {
  Future<DataAgent>? item;

  @override
  void initState() {
    super.initState();
    item = fetchRefres();
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundBody(
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
                  appBar: PreferredSize(
                    preferredSize: Size.fromHeight(56),
                    child: AppBarSuperior(item: 5,)
                  ),
                  body: Column(
                    children: [
                      Expanded(
                        child: Body(plantilla: widget.plantilla),
                      ),
                      AppBarPosterior(item:-1),
                    ],
                  ),
                ),
      ),
    );
  }
}
