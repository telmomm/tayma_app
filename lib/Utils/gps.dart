  import 'package:sensors/sensors.dart';
import 'package:geolocator/geolocator.dart';

  Future<Position> getGpsPosition() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    print("Posicion GPS: ${position.latitude}, ${position.longitude}");
    return position;
  }
