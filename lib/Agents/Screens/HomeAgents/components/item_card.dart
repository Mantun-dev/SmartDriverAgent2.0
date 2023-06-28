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
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).shadowColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                width: 60,
                height: 60,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SvgPicture.asset(
                    widget.plantilla.image,
                    color: Theme.of(context).primaryIconTheme.color,
                  ),
                ),
              ),

              SizedBox(height: 12),

              Text(
                widget.plantilla.title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 15),
              ),

              SizedBox(height: 6),

              Text(
                widget.plantilla.description,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 12),
              ),
            ],
          ),
        ),
      )

    );
  }
}
