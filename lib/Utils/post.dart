import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


  Future<void> sendPostRequest(Position position, {int timeoutSeconds = 5}) async {
    var url = Uri.parse('https://digitanimal-labs.com/tayma/api/events/add_events.php');

    var body = {
      "hook_event": "button_pressed_hold",
      "device": {
        "name": "TestName",
        "serial_number": "SerialNumber"
      },
      "event": {
        "name": "button",
        "timestamp": DateTime.now().toIso8601String(),
        "meta": {
          "cached_address": true,
          "address_country": "Spain",
          "address_state": "",
          "cached_address_lat": position.latitude,
          "address_city": "",
          "cached_address_lon": position.longitude,
        },
        "click_type": "hold"
      },
      "last_location": {
        "timestamp": DateTime.now().toIso8601String(),
        "latitude": position.latitude,
        "longitude": position.longitude,
        "formatted_address": " "
      }
    };

    try {
      var response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      ).timeout(Duration(seconds: timeoutSeconds));

      if (response.statusCode == 200) {
        print('Solicitud POST enviada con éxito.');
      } else {
        print('Error al enviar la solicitud POST: ${response.statusCode}.');
      }
    } catch (e) {
      if (e is http.ClientException && e.message.contains('timed out')) {
        print('La solicitud POST ha superado el tiempo de espera.');
      } else {
        print('Error al enviar la solicitud POST: $e');
      }
    }
  }


