import 'package:flutter/material.dart';
import 'package:flutter_auth/Agents/models/dataAgent.dart';
import 'package:flutter_auth/Agents/models/network.dart';
import 'package:flutter_auth/Agents/models/plantilla.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
      child: Container(

        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        decoration: BoxDecoration(
            border: Border.all(
              color: Color.fromRGBO(238, 238, 238, 1),
              width: 2
            ),
            color: widget.plantilla.color,
            borderRadius: BorderRadius.circular(20)),
        child: Column(
          children: [
           Container(
              decoration: BoxDecoration(
                color: Color.fromRGBO(158, 158, 158, 0.18),
                borderRadius: BorderRadius.circular(10),
              ),
              width: 60,
              height: 60,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: SvgPicture.asset(widget.plantilla.image, color: Color.fromRGBO(40, 93, 169, 1)),
              ),
            ),

            SizedBox(height: 12),

            Text(
              widget.plantilla.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 6),

            Text(
              widget.plantilla.description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Colors.black,
                fontWeight: FontWeight.normal
              ),
            )
          ],
        ),
      ),
    );
  }
}
