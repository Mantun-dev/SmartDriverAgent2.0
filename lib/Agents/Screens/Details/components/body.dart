import 'package:flutter/material.dart';
import 'package:flutter_auth/Agents/models/plantilla.dart';
import 'package:flutter_auth/components/add_cart.dart';
import 'package:flutter_auth/components/description.dart';
import 'package:flutter_auth/components/plantilla_titleWithImage.dart';
//import 'package:flutter_auth/constants.dart';

class Body extends StatefulWidget {
  final Plantilla plantilla;
  const Body({Key key, this.plantilla}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: [
            SizedBox(
              height: size.height,
              child: Stack(
                children: [
                  Container(
                    width: size.width,
                    height: size.height,
                    margin: EdgeInsets.only(top: size.height * 0.25),
                    padding: EdgeInsets.only(
                      top: 30.0,
                      left: 0,
                      right: 0,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24)),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Description(plantilla: widget.plantilla),
                          AddToCart(plantilla: widget.plantilla),
                        ],
                      ),
                    ),
                  ),
                  PlantillaTitleWithImage(plantilla: widget.plantilla),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
