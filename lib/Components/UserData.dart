import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Utils/controller.dart';
import '../Utils/post.dart';
import 'dart:convert';
import 'package:intl/intl.dart';


class UserData extends StatefulWidget {
  @override
  _UserDataState createState() => _UserDataState();
}

class _UserDataState extends State<UserData> {
  UserController userController = Get.find<UserController>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _municipioController = TextEditingController();
  final TextEditingController _userIdController = TextEditingController();

  List<Map<String, dynamic>> municipios = [];
  
  
  

  @override
  void initState() {
    super.initState();
    _firstNameController.text = userController.first_name.value;
    _lastNameController.text = userController.last_name.value;
    _birthDateController.text = userController.birth_date.value;
    _emailController.text = userController.email.value;
    _addressController.text = userController.address.value;
    _phoneController.text = userController.phone.value.toString();
    _municipioController.text = userController.municipio.value.toString();
    _userIdController.text = userController.user_id.value.toString();

    _initializeData();
    
  }
  Future<void> _initializeData() async {
    var response = await sendRequest(
      url: 'cities/get_cities.php',
      http_request: 'GET',
      serverController: Get.find<ServerController>(),
      body: ''
    );

    if (response.statusCode == 200) {// Accede al cuerpo de la respuesta directamente
    String responseBody = await response.stream.bytesToString();
    //print(responseBody);
    //asigna a municipios cada uno de los name_city dentro de 'cities'
    var data = json.decode(responseBody);
    //borrar todo menos cities
    data = data['cities'];
  
    setState(() {
        municipios = List<Map<String, dynamic>>.from(data.map((item) => {
          'id_city': item['id_city'],
          'name_city': item['name_city']
        }));
      });
    // Procesa la respuesta aquí
  } else {
    print('Error en la solicitud: ${response.statusCode}');
  }

}

    Future<void> _saveChanges() async {
      Map<String, dynamic> updatedData = {};

      updatedData['user_id'] = userController.user_id.value.toString();
      updatedData['first_name'] = userController.first_name.value;
      updatedData['last_name'] = userController.last_name.value;
      updatedData['birth_date'] = userController.birth_date.value;
      updatedData['email'] = userController.email.value;
      updatedData['address'] = userController.address.value;
      updatedData['phone'] = userController.phone.value.toString();
      updatedData['municipio'] = userController.municipio.value.toString();      

      print(json.encode(updatedData));
      var response = await sendRequest(
        url: 'phone_users/update_user.php',
        body: json.encode(updatedData),
        http_request: 'POST',
        serverController: Get.find<ServerController>()
      );
      
      if (response.statusCode == 200) {
        // Actualizar los valores en el UserController
        updatedData.forEach((key, value) {
          switch (key) {
            case 'first_name':
              userController.first_name.value = value;
              break;
            case 'user_id':
              userController.user_id.value = int.parse(value);
              break;
            case 'last_name':
              userController.last_name.value = value;
              break;
            case 'birth_date':
              userController.birth_date.value = value;
              break;
            case 'email':
              userController.email.value = value;
              break;
            case 'address':
              userController.address.value = value;
              break;
            case 'phone':
              userController.phone.value = int.parse(value);
              break;
            case 'municipio':
              userController.municipio.value = int.parse(value);
              break;

          }
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Cambios guardados exitosamente')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar los cambios')),
        );
      }
    }

  @override
  Widget build(BuildContext context) {
    UserController userController = Get.find<UserController>();
    return Column(
      children: [
        
        TextField(
          controller: _firstNameController,
          decoration: InputDecoration(labelText: 'Nombre'),
          onChanged: (value) => userController.first_name.value = value,
        ),
        TextField(
          controller: _lastNameController,
          decoration: InputDecoration(labelText: 'Apellidos'),
          onChanged: (value) => userController.last_name.value = value,
        ),
        TextField(
          decoration: InputDecoration(labelText: 'ID de usuario'),
          controller: _userIdController,
          readOnly: true,
        ),

        TextField(
          controller: _birthDateController,
          decoration: InputDecoration(labelText: 'Fecha de nacimiento'),
          readOnly: true, // Hace que el campo de texto sea de solo lectura
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime(2100),
            );

            if (pickedDate != null) {
              String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
              _birthDateController.text = formattedDate;
              userController.birth_date.value = formattedDate;
            }
          },
        ),
        TextField(
          controller: _emailController,
          decoration: InputDecoration(labelText: 'Email'),
          onChanged: (value) => userController.email.value = value,
        ),
        TextField(
          controller: _addressController,
          decoration: InputDecoration(labelText: 'Dirección'),
          onChanged: (value) => userController.address.value = value,
        ),
        TextField(
          controller: _phoneController,
          decoration: InputDecoration(labelText: 'Teléfono'),
          keyboardType: TextInputType.number, // Establece el tipo de teclado a numérico
          onChanged: (value) => userController.phone.value = int.parse(value),
        ),
        Text(
          'Municipio',
          textAlign: TextAlign.left,
        ),
        DropdownButton<int>(
          value: userController.municipio.value == 0 ? null : userController.municipio.value,
          hint: Text('Selecciona un municipio'),
          items: municipios.map((municipio) {
            return DropdownMenuItem<int>(
              value: municipio['id_city'],
              child: Text(municipio['name_city']),
            );
          }).toList(),
          onChanged: (int? newValue) {
            setState(() {
              userController.municipio.value = newValue!;
              _municipioController.text = newValue.toString();
            });
          },
        ),
        Center(
              child: ElevatedButton(
                onPressed: _saveChanges,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Color azul
                ),
                child: Text('Guardar cambios'),
              ),
            ),
        
      ],
    );
  /*
    return Obx(() {
      return ListTile(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _firstNameController,
              decoration: InputDecoration(labelText: 'Nombre'),
              onChanged: (value) => userController.first_name.value = value,
            ),
            TextField(
              controller: _lastNameController,
              decoration: InputDecoration(labelText: 'Apellidos '),
              onChanged: (value) => userController.last_name.value = value,
            ),
            
            
            
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _saveChanges,
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue, // Color azul
                ),
                child: Text('Guardar cambios'),
              ),
            ),
          ],
        ),
      );
    });*/
  }
}