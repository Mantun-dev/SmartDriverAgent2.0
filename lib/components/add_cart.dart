import 'package:flutter/material.dart';
import 'package:flutter_auth/Agents/models/plantilla.dart';

import 'package:flutter_auth/constants.dart';

class AddToCart extends StatelessWidget {
  const AddToCart({
    Key key,
    @required this.plantilla,

  }) : super(key: key);

  final Plantilla plantilla;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: kDefaultPadding),
      child: Row(
        children: <Widget>[],
      ),
    );
  }
}
