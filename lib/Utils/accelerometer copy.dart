
import 'package:sensors/sensors.dart';
import 'dart:math'; 
import 'dart:async';
import 'package:get/get.dart';

//Timer objects
Timer? _timer;

//Accelerometer values
final double thresholdMagnitude = 12.0; //Acceleration threshold (in m/s^2)
final int detectionTime = 30; //Detection time in ms

//Complementary filter
double alpha = 0.95;

//Internal vars
double gravityX = 0.0, gravityY = 0.0, gravityZ = 0.0;
 
class FallController extends GetxController {
  var isFallDetected = false.obs;

  void checkMagnitude(double magnitude, double threshold, int time) {
    if (magnitude > threshold) {
      if (_timer == null || !_timer!.isActive) {
        _timer = Timer(Duration(milliseconds: time), () {
          if (magnitude > threshold) {
            print("Posible caída detectada");
            
            isFallDetected.value = true;
            //print(isFallDetected.value);
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

  void listenToAccelerometerEvents() {
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

      checkMagnitude(magnitude, thresholdMagnitude, detectionTime);
    });
  });
}

}