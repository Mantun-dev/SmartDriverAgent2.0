import 'package:flutter/material.dart';
import 'package:flutter_auth/Agents/models/dataAgent.dart';
import 'package:flutter_auth/Agents/models/network.dart';
import 'package:flutter_auth/Agents/models/plantilla.dart';
import 'package:flutter_auth/constants.dart';

class ItemCard extends StatefulWidget {
  final Plantilla plantilla;
  final VoidCallback? press;

  final DataAgent? item;
  const ItemCard(
      {Key? key, required this.plantilla, required this.press, this.item})
      : super(key: key);

  @override
  _ItemCardState createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  Future<DataAgent>? item;

  @override
  void initState() {
    super.initState();
    item = fetchRefres();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.press,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 350,
            height: 160,
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: Colors.white.withOpacity(0.7),
                      blurRadius: 15,
                      spreadRadius: 1,
                      offset: Offset(0, 0)),
                  BoxShadow(
                      color: Colors.black,
                      blurRadius: 20,
                      spreadRadius: 2,
                      offset: Offset(5, 5)),
                ],
                color: widget.plantilla.color,
                borderRadius: BorderRadius.circular(20)),
            child: Column(
              children: [
                Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Hero(
                          tag: "${widget.plantilla.id}",
                          child: Container(
                            padding: EdgeInsets.only(top: 15),
                            // padding: EdgeInsets.only(right: 150),
                            height: 100,
                            child: Image.asset(
                              widget.plantilla.image,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12, left: 10),
                          child: Text(
                            widget.plantilla.title,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                color: GradiantV_2,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 9, left: 10),
                          child: Text(
                            widget.plantilla.description,
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
