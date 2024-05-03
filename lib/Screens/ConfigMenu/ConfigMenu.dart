import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'GeneralMenu.dart';
import 'AboutScreen.dart';

class UrlScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('URL de aviso'),
      ),
      body: Center(
        child: Text('Aquí van las opciones de configuración de URL'),
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

Future<String> getAppVersion() async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  return packageInfo.version;
}

class ConfigMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configuración'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text('Ajustes Generales'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => GeneralMenu()),
              );
            },
          ),
         
          ListTile(
            title: Text('Acerca de'),
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AboutScreen()),
              );
            },
          ),
          FutureBuilder<String>(
            future: getAppVersion(),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              if (snapshot.hasData) {
                return ListTile(
                  title: Text('Versión de la aplicación: ${snapshot.data}'),
                );
              } else {
                return CircularProgressIndicator();
              }
            },
          ),
        ],
      ),
    );
  }
}