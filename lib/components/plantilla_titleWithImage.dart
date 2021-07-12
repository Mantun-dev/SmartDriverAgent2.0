import 'package:flutter/material.dart';
import 'package:flutter_auth/Agents/models/plantilla.dart';
import '../constants.dart';

class PlantillaTitleWithImage extends StatelessWidget {
  const PlantillaTitleWithImage({
    Key key,
    @required this.plantilla,
  }) : super(key: key);

  final Plantilla plantilla;

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            plantilla.title,
            style: Theme.of(context)
                .textTheme
                .headline4
                .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[              
              // Container( 
              //   width: 200,
              //   height: 162,
                              
              //   child: Column(                                 
              //     children: [
              //       Text("Nota",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: kCardColor2,)),
              //       Text('Si tiene algún inconveniente con su programación, puede escribir al número: ',style: TextStyle(color: kgray)),                         
              //       TextButton(onPressed: () => launch('tel://3317-4537'),
              //       child: Text('3317-4537',style: TextStyle(color: Colors.blue[500],fontSize: 15))),
              //     ],
              //   ),
              // ),
              //SizedBox(width: 150),
              Container(                
                width: 125,
                height: 150,                
                child: Column(
                  children: [
                    Hero(
                      //aquí esta el otro id
                      tag: "${plantilla.id}",
                      child: Image.asset(
                        plantilla.image,
                        fit: BoxFit.cover,                      
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
