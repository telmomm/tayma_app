
import 'package:flutter/material.dart';
//import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_bcrypt/flutter_bcrypt.dart';
import 'dart:convert'; 
import 'dart:async'; 
import 'package:get/get.dart';

import '../../Utils/post.dart';
import '../../Utils/controller.dart';

class LoginScreen extends StatefulWidget {
  final Function onLoginSuccess;

  LoginScreen({required this.onLoginSuccess});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  //final FlutterSecureStorage _storage = FlutterSecureStorage();
  //final storage = Get.find<StorageController>();
  final StorageController storage = Get.find<StorageController>();
  final UserController userController = Get.find<UserController>();

  Future<void> _login() async {
    String email = _emailController.text;
    String password = _passwordController.text;
    
    var body = json.encode({
      'email': email,//'telmo@gmail.com',//email,
      'password': password//'admin' //password
      });
    var response = await sendRequest(
      url: 'phone_users/login.php',
      body: body,
      http_request: 'GET',
      serverController: Get.find<ServerController>()
    );

    String responseBody = await response.stream.bytesToString();
    print(responseBody);
    if (response.statusCode == 200) {
      var responseData = json.decode(responseBody);
      //String hashedPassword = responseData['usuario']['password'];
      //print(hashedPassword);
      //if (await FlutterBcrypt.verify(password: password, hash: hashedPassword)) {
      if (responseData['resultado'] == true) {
        setState(() {
          storage.loginOk.value = true;
        });
        await storage.writeBool(key: 'loginOk', value: true);
        await storage.write(key: 'email', value: email);
        //userController.user_id.value = responseData['user']['user_id'];

        // Obtener una instancia del UserController
        UserController userController = Get.find<UserController>();

        // Guardar todos los datos del usuario en el UserController
        Map<String, dynamic> userData = responseData['user'];
        for (var entry in userData.entries) {
          switch (entry.key) {
            case 'first_name':
              userController.first_name.value = entry.value;
              break;
            case 'last_name':
              userController.last_name.value = entry.value;
              break;
            case 'user_id':
              userController.user_id.value = int.parse(entry.value.toString());
              break;
            case 'birth_date':
              userController.birth_date.value = entry.value;
              break;
            case 'email':
              userController.email.value = entry.value;
              break;
            case 'address':
              userController.address.value = entry.value;
              break;
            /*case 'phone':
              userController.phone.value = entry.value;
              break;
            */
            case 'municipio':
              userController.municipio.value = int.parse(entry.value.toString());
              break;
            default:
              await storage.write(key: entry.key, value: entry.value.toString());
          }
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login exitoso')),
        );
        widget.onLoginSuccess();
        Navigator.pop(context);
      } else {
        print('Contraseña incorrecta');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Contraseña incorrecta')),
        );
      }
    } else {
      print('Error en el servidor');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error en el servidor')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Contraseña'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue, // Color azul
                ),
                child: Text('Login'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}