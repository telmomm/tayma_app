import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:get/get.dart';
import 'dart:core';
import  './controller.dart';

var common = {
  'url': 'https://tayma-app.com/tayma/api/events/',
  'headers': {
    'Cookie': 'PHPSESSID=0hkuiub8an17ghgd06b7aev0tc'
  },
  'host': 'tayma-app.com',
};

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

Future<void> sendPostRequest(Position position, {int timeoutSeconds = 10}) async {
  var headers = {
    'Cookie': 'PHPSESSID=0hkuiub8an17ghgd06b7aev0tc'
  };
  var host = 'tayma-app.com';
  var data = json.encode({
  "user_id": 11,
  "hook_event": "prueba",
  "timestamp": "2022-10-09T09:26:22Z",
  "location": {
    "latitude": 42.119081,
    "longitude": -3.426753
  },
  "device": null
});

  try {
    // Resolver el nombre del host a una dirección IP
    List<InternetAddress> addresses = await InternetAddress.lookup(host);
    if (addresses.isNotEmpty) {
      var ipAddress = addresses.first.address;
      //print('Dirección IP del host: $ipAddress');
      
      // Proceder con la solicitud  utilizando la dirección IP resuelta
      HttpOverrides.global = MyHttpOverrides();
      var request = http.Request('POST', Uri.parse('https://$ipAddress/tayma/api/events/new_add_events.php'));
      request.body = json.encode({
        "user_id": 11,
        "hook_event": "prueba",
        "timestamp": "2022-10-09T09:26:22Z",
        "location": {
          "latitude": 42.119081,
          "longitude": -3.426753
        },
        "device": null
      });
      request.headers.addAll(headers);

      // Establecer un tiempo de espera para la solicitud
      var response = await request.send().timeout(Duration(seconds: timeoutSeconds));

      if (response.statusCode == 200) {
        print(await response.stream.bytesToString());
      } else {
        print(response.reasonPhrase);
      }
    } else {
      print('No se pudo resolver el nombre del host.');
    }
  } catch (e) {
    if (e is SocketException) {
      print('Error de conexión: No se pudo resolver el nombre del host.');
    } else if (e is TimeoutException) {
      print('La solicitud GET ha superado el tiempo de espera.');
    } else {
      print('Error al enviar la solicitud GET: $e');
    }
  }
}

Future<void> postNewEvent(Position position, UserController user, hook_event) async {

  var body = json.encode({
    "user_id": user.user_id.value,
    "hook_event": hook_event,
    "timestamp": position.timestamp?.toIso8601String() ?? '',
    "location": {
      "latitude": position.latitude,
      "longitude": position.longitude
    },
    "device": null
  });
  print(body);

  var response = await sendRequest(
    url: 'events/new_add_events.php',
    body: body,
    http_request: 'POST',
    serverController: Get.find<ServerController>()
  );
  String responseBody = await response.stream.bytesToString();
  print(responseBody);


}

//Future<void> sendRequest({
Future<http.StreamedResponse> sendRequest({
  required String url,
  required String body, 
  required String http_request,
  required ServerController serverController,
  int timeoutSeconds = 10
  }) async {

  try {
    // Resolver el nombre del host a una dirección IP
    List<InternetAddress> addresses = await InternetAddress.lookup(serverController.host.value);
    if (addresses.isNotEmpty) {
      var ipAddress = addresses.first.address;
      //print('Dirección IP del host: $ipAddress');
      
      // Proceder con la solicitud  utilizando la dirección IP resuelta
      HttpOverrides.global = MyHttpOverrides();

      var headers = serverController.headers;

      var uri = Uri.parse(serverController.url.value + url);
      
      //replace tayma-app.com of the uri to the ipAdress
      uri = uri.replace(host: ipAddress);
      //print(uri);
      var request = http.Request(http_request, uri);
      
      request.headers.addAll(headers);
      request.body = body;

      // Establecer un tiempo de espera para la solicitud
      var response = await request.send().timeout(Duration(seconds: timeoutSeconds));
      //print(response.statusCode);
      //print(response.reasonPhrase);
      return response;
      if (response.statusCode == 200) {
        print(await response.stream.bytesToString());
      } else {
        print(response.reasonPhrase);
      }
    } else {
      print('No se pudo resolver el nombre del host.');
    }
  } catch (e) {
    if (e is SocketException) {
      print('Error de conexión: No se pudo resolver el nombre del host.');
    } else if (e is TimeoutException) {
      print('La solicitud GET ha superado el tiempo de espera.');
    } else {
      print('Error al enviar la solicitud GET: $e');
    }
  }
    return http.StreamedResponse(Stream.empty(), 500);
}