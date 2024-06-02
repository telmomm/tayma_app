
import 'package:get/get.dart';

class GeneralMenuController extends GetxController {
  RxString deviceName = ''.obs;
  RxString serialNumber = ''.obs;
  RxBool isFallDetectionEnabled = true.obs;
  RxBool isFallDetected = false.obs;

  void toggleFallDetection(bool value) {
    isFallDetectionEnabled.value = value;

    // Si isFallDetectionEnabled se desactiva, restablece isFallDetected a false
    if (!isFallDetectionEnabled.value) {
      isFallDetected.value = false;
    }
    print("isFallDetected VAriable: " + isFallDetected.value.toString());
  }
}