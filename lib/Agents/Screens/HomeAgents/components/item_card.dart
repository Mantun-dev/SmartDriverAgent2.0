import 'package:flutter/material.dart';
import 'package:flutter_auth/Agents/models/dataAgent.dart';
import 'package:flutter_auth/Agents/models/network.dart';
import 'package:flutter_auth/Agents/models/plantilla.dart';
import 'package:flutter_auth/constants.dart';

class ItemCard extends StatefulWidget {
  final Plantilla plantilla;
  final Function press;
  final DataAgent item;
  const ItemCard({Key key, this.plantilla, this.press, this.item}) : super(key: key);

  @override
  _ItemCardState createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  Future<DataAgent> item;

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [          
          Expanded(
              child: Container(
            padding: EdgeInsets.all(kDefaultPadding),
            decoration: BoxDecoration(
                color: widget.plantilla.color,
                borderRadius: BorderRadius.circular(16)),
            child: Hero(
              tag: "${widget.plantilla.id}",
              child: Image.asset(
                widget.plantilla.image,
              ),
            ),
          )),
          Padding(
              padding: EdgeInsets.symmetric(vertical: kDefaultPadding / 4),
              child: Text(
                widget.plantilla.title,
                style: TextStyle(color: kTextColor, fontSize: 15),
          ))
        ],
      ),
    );
  }
}
