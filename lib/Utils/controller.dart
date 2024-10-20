
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageController extends GetxController {
  final FlutterSecureStorage storage = FlutterSecureStorage();
  var loginOk = false.obs;

  Future<void> write({required String key, required String value}) async {
    await storage.write(key: key, value: value);
  }

  Future<String?> read({required String key}) async {
    return await storage.read(key: key);
  }

  Future<void> delete({required String key}) async {
    await storage.delete(key: key);
  }

  Future<void> writeBool({required String key, required bool value}) async {
    await storage.write(key: key, value: value.toString());
    if (key == 'loginOk') {
      loginOk.value = value; // Actualizar loginOk
    }
  }

  Future<bool> readBool({required String key}) async {
    String? value = await storage.read(key: key);
    bool boolValue = value == 'true';
    if (key == 'loginOk') {
      loginOk.value = boolValue; // Actualizar loginOk
    }
    return boolValue;
  }
}

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
    print("isFallDetected Variable: " + isFallDetected.value.toString());
  }
}

class UserController extends GetxController {
  RxInt user_id = 0.obs;
  RxString last_name = ''.obs;
  RxString first_name = ''.obs;
  RxString birth_date = ''.obs;
  RxString email = "".obs;
  RxString address = ''.obs;
  RxInt phone = 0.obs;
  RxInt municipio = 0.obs;
  
}

class ServerController extends GetxController{
  RxString url = 'https://tayma-app.com/tayma/api/'.obs;
  RxString host = 'tayma-app.com'.obs;
  var headers = {
  'Content-Type': 'application/json',
  'Cookie': 'PHPSESSID=0hkuiub8an17ghgd06b7aev0tc'
};
  
}

