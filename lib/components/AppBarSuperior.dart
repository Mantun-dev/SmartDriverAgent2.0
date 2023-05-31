
import 'package:flutter/material.dart';
import 'package:flutter_auth/Agents/Screens/HomeAgents/homeScreen_Agents.dart';
import 'package:flutter_auth/Agents/Screens/Profile/profile_screen.dart';


class AppBarSuperior extends StatefulWidget {
  int? item;

  AppBarSuperior({this.item});

  @override
  _AppBarSuperior createState() => _AppBarSuperior(item: item);
}

class _AppBarSuperior extends State<AppBarSuperior> {
  int? item;

  _AppBarSuperior({this.item});

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return AppBar(
      backgroundColor: Color.fromRGBO(40, 93, 169, 1),
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white, size: 25),
      automaticallyImplyLeading: false, 
      actions: <Widget>[

        item!=0?Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: 45,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white,
                width: 0.5,
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return HomeScreen();
                    })
                  );
              },
            ),
          ),
        ):Padding(
          padding: const EdgeInsets.all(8.0),
          child: menu(size),
        ),

        if(item==0)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top:8.0),
              child: Container(
                width: 110,
                height: 110,
                child: Image.asset('assets/images/logo.png'),
              ),
            ),
          ),

        if(item==1)
          Expanded(
            child: Center(
              child: Text(
                "Datos personales",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.normal,
                  fontSize: 21
                ),
              ),
            ),
          ),

          if(item==2)
          Expanded(
            child: Center(
              child: Text(
                "Próximos viajes",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.normal,
                  fontSize: 21
                ),
              ),
            ),
          ),

          if(item==3)
          Expanded(
            child: Center(
              child: Text(
                "Historial de viajes",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.normal,
                  fontSize: 21
                ),
              ),
            ),
          ),

          if(item==4)
          Expanded(
            child: Center(
              child: Text(
                "Código QR",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.normal,
                  fontSize: 21
                ),
              ),
            ),
          ),

          if(item==5)
          Expanded(
            child: Center(
              child: Text(
                "Solicitud de cambios",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.normal,
                  fontSize: 21
                ),
              ),
            ),
          ),

        item==0?Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: 45,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white,
                width: 0.5,
              ),
            borderRadius: BorderRadius.circular(10.0),
            ),
            child: IconButton(
              icon: Icon(Icons.person_outline),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return ProfilePage();
                  })
                );
              },
            ),
          ),
        ):Padding(
          padding: const EdgeInsets.all(8.0),
          child: menu(size),
        )
        
      ],
    );
  }

  Container menu(size) {
    return Container(
      width: 45,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white,
          width: 0.5,
        ),
      borderRadius: BorderRadius.circular(10.0),
      ),
      child: IconButton(
        icon: Icon(
          Icons.menu,
          color: Colors.white,
        ),
        onPressed: () {
          showGeneralDialog(
            barrierColor: Colors.black.withOpacity(0.6),
            transitionBuilder: (context, a1, a2, widget) {
              final curvedValue = Curves.easeInOut.transform(a1.value);
              return Transform.translate(
                offset: Offset(0.0, (1 - curvedValue) * size.height / 2),
                child: Opacity(
                  opacity: a1.value,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: size.height / 2,
                      width: size.width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30.0),
                          topRight: Radius.circular(30.0),
                        ),
                      ),
                    ),
                  ),
                ),
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
            
        },
      ),
    );
      
  }

}
