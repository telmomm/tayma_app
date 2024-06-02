import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


  Future<void> sendPostRequest(Position position, {int timeoutSeconds = 5}) async {
    //var url = Uri.parse('https://digitanimal-labs.com/tayma/api/events/add_events.php');
    var url1 = Uri.parse('https://tayma-server.onrender.com/api/add_events');
    var url = Uri.parse('https://tayma-server.onrender.com/api/get_events?limit=1');
    var headers = {
      'Content-Type': 'application/json'
    };
    var body1 = {
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

    var body = {
  "hook_event": "button_pressed_hold",
  "device": {
    "name": "TiFiz3",
    "serial_number": "K0K0K0"
  },
  "event": {
    "name": "button",
    "timestamp": "2021-10-09T09:26:22Z",
    "meta": {
      "cached_address": true,
      "address_country": "Spain",
      "address_state": "Castile and León",
      "cached_address_lat": 42.119081,
      "address_city": "Castile and León",
      "cached_address_lon": -3.426753
    },
    "click_type": "hold"
  },
  "last_location": {
    "timestamp": "2022-10-31T09:01:22Z",
    "latitude": 42.119082,
    "longitude": -3.426753,
    "formatted_address": "C. Cantarranas, 20, 09650 Campolara, Burgos"
  }
};
    
    var request = http.Request('POST', url1)
      ..headers.addAll(headers)
      ..body = jsonEncode(body1);
   try {
      http.StreamedResponse response = await request.send();
      //var response = await http.get(
       // url,
        //headers: headers,
        //body: jsonEncode(body),
     // );//.timeout(Duration(seconds: timeoutSeconds));

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
    
/*
    try {
      var testResponse = await http.get(Uri.parse('https://www.google.com'));
      if (testResponse.statusCode == 200) {
        print('Conexión a Internet funcionando correctamente.');
      } else {
        print('No se pudo conectar a Google. Código de estado: ${testResponse.statusCode}');
      }
    } catch (e) {
      print('Error al intentar conectar a Google: $e');
    }
*/
  }


