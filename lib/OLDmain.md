import 'package:flutter/material.dart';
import 'Screens/ConfigMenu/ConfigMenu.dart';

import 'dart:math'; 
import 'dart:async';

import 'package:sensors/sensors.dart';
import 'package:geolocator/geolocator.dart';

import 'package:get/get.dart';


//Import components
import 'Components/LoadingButton.dart';
import 'Components/FallingButton.dart';

//Import utils
import 'Utils/gps.dart';
import 'Utils/post.dart';
import 'Utils/accelerometer.dart';

//Import styles
import 'styles.dart';

Timer? _timer;

bool isFallDetected = false;

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


  @override
  void initState() {
    super.initState();
    fallController.listenToAccelerometerEvents();
  }

  
  bool isButtonPressed = false;

void onButtonPressed() async {
  await Future.delayed(Duration(seconds: 2));

  //print('Button');
  //Position position = await getGpsPosition();
  //print('Posición GPS obtenida: ${position.latitude}, ${position.longitude}');
  //await sendPostRequest(position, timeoutSeconds: 20);
}

void onFallNotDetected() {
  final FallController fallController = Get.find();
  fallController.isFallDetected.value = false;
  setState(() {
    isFallDetected = false;
  });
}

  void OLDcheckMagnitude(double magnitude, double threshold) {
    //print("Magnitud: $magnitude - Umbral: $threshold");
  if (magnitude > threshold) {
    if (_timer == null || !_timer!.isActive) {
      _timer = Timer(Duration(milliseconds: 50), () {
        if (magnitude > threshold) {
          print("Posible caída detectada");
          setState(() {
            isFallDetected = true;
          });
          //Position position = await getGpsPosition();
          //print("Posicion GPS: ${position.latitude}, ${position.longitude}");
        }
        _timer = null;
      });
    }
  } else {
    _timer?.cancel();
    _timer = null;
  }
}  

  void OLDlistenToAccelerometerEvents() {
  accelerometerEvents.listen((AccelerometerEvent accelerometerEvent) {
    gyroscopeEvents.listen((GyroscopeEvent gyroscopeEvent) {
      // Aplicar el filtro complementario
      double accX = accelerometerEvent.x;
      double accY = accelerometerEvent.y;
      double accZ = accelerometerEvent.z;

      double gyroX = gyroscopeEvent.x;
      double gyroY = gyroscopeEvent.y;
      double gyroZ = gyroscopeEvent.z;

      double pitch = atan2(accY, sqrt(accX * accX + accZ * accZ));
      double roll = atan2(accX, sqrt(accY * accY + accZ * accZ));

      gravityX = alpha * (gravityX + gyroX * 0.02) + (1 - alpha) * roll;
      gravityY = alpha * (gravityY + gyroY * 0.02) + (1 - alpha) * pitch;
      gravityZ = alpha * (gravityZ + gyroZ * 0.02);

      double linearAccelerationX = accX - gravityX;
      double linearAccelerationY = accY - gravityY;
      double linearAccelerationZ = accZ - gravityZ;

      // Calcular la magnitud (coordenada máxima en 3D)
      double magnitude = sqrt(
        linearAccelerationX * linearAccelerationX +
        linearAccelerationY * linearAccelerationY +
        linearAccelerationZ * linearAccelerationZ
      );

      // Implementar la lógica de detección de caídas
      //print(magnitude);
      if (magnitude > thresholdMagnitude) {
        //print("Caida detectada");
        //Position position = await getGpsPosition();
       // print("Posicion GPS: ${position.latitude}, ${position.longitude}");
      }
      OLDcheckMagnitude(magnitude, thresholdMagnitude);
    });
  });
}

  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  Position gpsPosition = Position(latitude: 0.0, longitude: 0.0, timestamp: DateTime.now(), accuracy: double.infinity, altitude: 0.0, heading: 0.0, speed: 0.0, speedAccuracy: 0.0);

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
              Builder(
                builder: (BuildContext context) {
                  if (fallController.isFallDetected.value) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Possible fall detected...'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    });
                  }
                  return Container(); // Devuelve un widget vacío si no se detecta una caída
                },
              ),

              Center(
                child: fallController.isFallDetected.value
                  ? Builder(
                    builder: (BuildContext context) {
                      return FallingButton(
                        onPressed: () {
                      //onButtonPressed();
                      //print("Falling Button Pressed");
                      onFallNotDetected();
                      print("Confirmed Falling");
                      ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Sending Falling Message...'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                    },
                    onCompleted: () async {
                      onFallNotDetected();
                      print("Canceled Falling");
                      ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Cancelling Falling Message...'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        
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
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Sending SOS Message...'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                          gpsPosition = await getGpsPosition();
                        setState(() {});
                        },
                      );
                    },
                  )
                //child: LoadingButton(),
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
                ],
              ),
              //Text("Longitude " + gpsPosition.longitude.toString() + " - Latitude " + gpsPosition.latitude.toString()),
              Positioned(
                top: 10.0, // adjust this to change the position
                right: 10.0, // adjust this to change the position
                child: Builder(
                  builder: (BuildContext context) {
                    return FloatingActionButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ConfigMenu()),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Settings button pressed'),
                          duration: Duration(seconds: 2),
                        ),
          );
                      },
                      child: Icon(Icons.settings),
                    );
                  },
                ),
              ),
            ],
          ),
          //bottomNavigationBar: MyBottomNavigationBar(),
        )
      )
    );
  }
}