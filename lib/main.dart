//Libraries
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

//Import Components
import 'Components/LoadingButton.dart';
import 'Components/FallingButton.dart';
import 'Components/SettingsButton.dart';
import 'Components/SnackBarMessage.dart';

//Import Utils
import 'Utils/gps.dart';
import 'Utils/accelerometer.dart';

//Import Styles
import 'styles.dart';

//Import Screens
import 'Screens/ConfigMenu/ConfigMenu.dart';

//Internal variables
bool isFallDetected = false;
final FallController fallController = FallController();

void main() {
  Get.put(FallController());
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {

  final FallController fallController = Get.put(FallController());
  bool isButtonPressed = false;
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  Position gpsPosition = Position(latitude: 0.0, longitude: 0.0, timestamp: DateTime.now(), accuracy: double.infinity, altitude: 0.0, heading: 0.0, speed: 0.0, speedAccuracy: 0.0);

  @override
  void initState() {
    super.initState();
    fallController.listenToAccelerometerEvents();
  
  }

  void onFallNotDetected() {
    //final FallController fallController = Get.find();
    fallController.isFallDetected.value = false;
    setState(() {
      isFallDetected = false;
    });
}

  @override
  Widget build(BuildContext context) {
    final FallController fallController = Get.find();
    return MaterialApp(
      scaffoldMessengerKey: _scaffoldMessengerKey,

      home: ScaffoldMessenger(
        child: Scaffold(
          appBar: appBarStyle(context, 'TAYMA SOS'), // estilo del appbar
          body: 
          Stack(
            children: [

              Center(
                child: Obx(() {
                  
                  return fallController.isFallDetected.value
                    ? Builder(
                        builder: (BuildContext context) {
                          return FallingButton(
                            onInit: (){
                              print("Snack Bar Caída");
                              SnackBarMessage(
                                context: context,
                                text: "Caída detectada",
                              ).show();
                            },
                            onPressed: () {
                              //onButtonPressed();
                              //print("Falling Button Pressed");
                              onFallNotDetected();
                              print("Confirmed Falling");
                              SnackBarMessage(
                                context: context,
                                text: "Enviando mensaje de alarma",
                              ).show();
                            },
                            onCompleted: () async {
                              onFallNotDetected();
                              print("Canceled Falling");
                              SnackBarMessage(
                                context: context,
                                text: "Caída anulada",
                              ).show();
                            }
                          );
                        },
                      )
                    : Builder(
                        builder: (BuildContext context) {
                          return LoadingButton(
                            onPressed: () async {
                              //onButtonPressed();
                              print("SOS Button Pressed");
                              SnackBarMessage(
                                context: context,
                                text: "Enviando mensaje de emergencia..",
                              ).show();
                              gpsPosition = await getGpsPosition();
                              setState(() {});
                            },
                          );
                        },
                      );
                }),
              ),
              Column(
                children: <Widget>[
                  Expanded(
                    child: Align(
                      alignment: FractionalOffset.bottomCenter,
                      child: Text(
                        "Longitude " + gpsPosition.longitude.toString() + " - Latitude " + gpsPosition.latitude.toString(),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  /*
                  Text(
                    "Fall Detected: " + fallController.isFallDetected.value.toString(),
                    textAlign: TextAlign.center,
                  )
                  */
                ],
              ),
              //Text("Longitude " + gpsPosition.longitude.toString() + " - Latitude " + gpsPosition.latitude.toString()),
              SettingsButton(),
            ],
          ),
        )
      )
    );
  }
}