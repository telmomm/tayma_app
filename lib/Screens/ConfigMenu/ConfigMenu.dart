import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'GeneralMenu.dart';
import 'LegalAdvise.dart';

final Uri _url = Uri.parse('https://telmomm.github.io/tayma_app/ManualUsuario/');

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
            "Version 0.1.3",
          ),      
        ],
      ),
    );
  }
}
