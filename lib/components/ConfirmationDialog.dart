import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ConfirmationLoadingDialog {
  static final ConfirmationLoadingDialog _singleton = ConfirmationLoadingDialog._internal();
  late BuildContext _context;
  bool isDisplayed = false;

  factory ConfirmationLoadingDialog() {
    return _singleton;
  }

  ConfirmationLoadingDialog._internal();

  show(BuildContext context, {String text = 'Cargando...',}) {
    if(isDisplayed) {
      return;
    }
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        _context = context;
        isDisplayed = true;
        return WillPopScope(
          onWillPop: () async => false,
          child: SimpleDialog(
            backgroundColor: Colors.white,
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
                        text,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  dismiss() {
    if(isDisplayed) {
      Navigator.pop(_context);
      isDisplayed = false;
    }
  }
}

class ConfirmationDialog {
  static final ConfirmationDialog _singleton = ConfirmationDialog._internal();
  late BuildContext _context;
  bool isDisplayed = false;

  factory ConfirmationDialog() {
    return _singleton;
  }

  ConfirmationDialog._internal();

  show(BuildContext context, {
    required String title,
    required String type,
    required VoidCallback onConfirm,
    required VoidCallback onCancel,
  }) {
    if (isDisplayed) {
      return;
    }
    Color containerC;
    Color circleC;
    String iconAsset;
    if (type == '0') {
      containerC = Color.fromRGBO(40, 169, 83, 1);
      circleC = Color.fromRGBO(0, 191, 95, 1);
      iconAsset = "assets/icons/check.svg";
    } else {
      containerC = Color.fromRGBO(172, 33, 33, 1);
      circleC = Color.fromRGBO(201, 32, 32, 1);
      iconAsset = "assets/icons/cancelar.svg";
    }
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        _context = context;
        isDisplayed = true;
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            elevation: 0,
            backgroundColor: Colors.transparent,
            content: SingleChildScrollView(
              child: Column(

                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0),
                      ),
                      color: containerC,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(right: 100.0, left: 100, bottom: 30, top: 30),
                      child: CircleAvatar(
                        backgroundColor: circleC,
                        radius: 30.0 + 10.0, 
                        child: Padding(
                          padding: EdgeInsets.all(15.0), 
                          child: SvgPicture.asset(
                            iconAsset,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),


                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10.0),
                        bottomRight: Radius.circular(10.0),
                      ),
                      color: Colors.white, 
                    ),
                    child: Column(children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Text(
                          title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20, bottom: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    side: BorderSide(color: Colors.black),
                                  ),
                                ),
                                backgroundColor: MaterialStateProperty.all(Colors.transparent),
                              ),
                              onPressed: () {
                                onCancel();
                                dismiss();
                              },
                              child: Text(
                                'No',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(width: 20),
                            TextButton(
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    side: BorderSide(color: Color.fromRGBO(40, 93, 169, 1)),
                                  ),
                                ),
                                backgroundColor: MaterialStateProperty.all(Color.fromRGBO(40, 93, 169, 1)),
                              ),
                              onPressed: () {
                                onConfirm();
                              },
                              child: Text(
                                'Sí',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ]),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  dismiss() {
    if (isDisplayed) {
      Navigator.pop(_context);
      isDisplayed = false;
    }
  }
}

void main() {
  runApp(MaterialApp(
    home: MyWidget(),
  ));
}

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Confirmation Dialog'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            ConfirmationDialog().show(
              context,
              title: '¿Está seguro?',
              type: '0',
              onConfirm: () {
                print('Confirmado');
              },
              onCancel: () {
                print('Cancelado');
              },
            );
          },
          child: Text('Mostrar confirmación'),
        ),
      ),
    );
  }
}
