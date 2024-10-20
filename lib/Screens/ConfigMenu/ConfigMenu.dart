import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter_bcrypt/flutter_bcrypt.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // Importa dart:convert para usar json.decode
import 'dart:io'; // Asegúrate de importar dart:io
import 'dart:async'; // Importa dart:async para TimeoutException
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Utils/post.dart';
import '../../Utils/controller.dart';

import 'LoginScreen.dart';
import '../../Components/UserData.dart';

class ConfigMenu extends StatefulWidget {
  @override
  _ConfigMenuState createState() => _ConfigMenuState();
}

class _ConfigMenuState extends State<ConfigMenu> {
  //final FlutterSecureStorage _storage = FlutterSecureStorage();
  UserController userController = Get.find<UserController>();
  StorageController storageController = Get.find<StorageController>();

  //String? _loginOk;
  final storage = Get.find<StorageController>();


  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    await storage.readBool(key: 'loginOk'); // Solo leer el valor
  }

  Future<void> _logout() async {
    await storage.writeBool(key: 'loginOk', value: false); // Actualizar el valor
    await storage.delete(key: 'email');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configuración'),
      ),
      body: Obx(() =>ListView(
        children: <Widget>[
          storage.loginOk.value
            ? Column(
                children: [
                  UserData(),
                  Center(
                    child: ElevatedButton(
                      onPressed: _logout,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,

                        //primary: Colors.red, // Color rojo
                      ),
                      child: Text('Logout'),
                    ),
                  ),
                ],
              )
            : Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen(onLoginSuccess: _checkLoginStatus)),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // Color azul
                  ),
                  child: Text('Login'),
                ),
              ),

          ListTile(
            title: Text('Aviso Legal'),
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LegalAdviseScreen()),
              );
            },
          ),
          ListTile(
              title: Text('Manual de Usuario'),
              onTap: () => launch('https://telmomm.github.io/tayma_app/ManualUsuario/'),
            ),
            
            Text(
              "Versión 0.1.5",
              textAlign: TextAlign.center,
            ),
        ],
      ),
      ),
    );
  }
}

class UserIdScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ID de usuario'),
      ),
      body: Center(
        child: Text('Aquí van las opciones de configuración de ID de usuario'),
      ),
    );
  }
}

class GeneralMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menú General'),
      ),
      body: Center(
        child: Text('Contenido del Menú General'),
      ),
    );
  }
}

class LegalAdviseScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Aviso Legal'),
      ),
      body: Center(
        child: Text('Contenido del Aviso Legal'),
      ),
    );
  }
}
