//Libraries
import 'dart:isolate';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:TAYMA/Services/notification_service.dart';

//Import Components
import 'Components/LoadingButton.dart';
import 'Components/FallingButton.dart';
import 'Components/SettingsButton.dart';
import 'Components/SnackBarMessage.dart';
import 'Components/NotificationButton.dart';

//Import Utils
import 'Utils/gps.dart';
import 'Utils/accelerometer.dart';
import 'Utils/post.dart';
import 'Utils/controller.dart';

//Import Styles
import 'styles.dart';

//Import Screens
//import 'Screens/ConfigMenu/ConfigMenu.dart';

//Internal variables
bool isFallDetected = false;
//final FallController fallController = FallController();

void main() async {
  //Get.put(FallController());
  Get.put(GeneralMenuController()); 

  await NotificationService.initializeNotification();

  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {

  //final FallController fallController = Get.put(FallController());
  bool isButtonPressed = false;
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  Position gpsPosition = Position(latitude: 0.0, longitude: 0.0, timestamp: DateTime.now(), accuracy: double.infinity, altitude: 0.0, heading: 0.0, speed: 0.0, speedAccuracy: 0.0);

  @override
  void initState() {
    super.initState();
    FallController fallController = FallController();
    fallController.listenToAccelerometerEvents();
  }

  void onFallNotDetected() {
    //final FallController fallController = Get.find();
    generalMenuController.isFallDetected.value = false;
    setState(() {
      isFallDetected = false;
    });

  }
  
  @override
  Widget build(BuildContext context) {
    //final FallController fallController = Get.find();
    final GeneralMenuController generalMenuController = Get.find();
    FallController fallController = FallController();
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
                  
                  return generalMenuController.isFallDetected.value && generalMenuController.isFallDetectionEnabled.value
                    ? Builder(
                        builder: (BuildContext context) {
                          return FallingButton(
                            onInit: (){
                              print("Snack Bar Caída");
                              NotificationService.showNotification(
                                title: "TAYMA",
                                body: "Caída detectada",
                              );
                              
                              SnackBarMessage(
                                context: context,
                                text: "Caída detectada",
                              ).show();
                            },
                            onPressed: () async {
                              //onButtonPressed();
                              //print("Falling Button Pressed");
                              onFallNotDetected();
                              print("Confirmed Falling");
                              NotificationService.showNotification(
                                title: "TAYMA",
                                body: "Enviando mensaje de alarma...",
                              );
                              SnackBarMessage(
                                context: context,
                                text: "Enviando mensaje de alarma",
                              ).show();

                             /*await sendPostRequest(
                                gpsPosition,
                                timeoutSeconds: 5
                              );
                              */
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
                              NotificationService.showNotification(
                                title: "TAYMA",
                                body: "Enviando mensaje de emergencia...",
                              );
                              print("SOS Button Pressed");
                              SnackBarMessage(
                                context: context,
                                text: "Enviando mensaje de emergencia...",
                              ).show();
                              gpsPosition = await getGpsPosition();
                              setState(() {});
                              /*await sendPostRequest(
                                gpsPosition,
                                timeoutSeconds: 5
                              );
                              */
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