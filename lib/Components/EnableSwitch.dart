import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Utils/controller.dart';

class EnableSwitch extends StatefulWidget {
  @override
  _EnableSwitchState createState() => _EnableSwitchState();
}

class _EnableSwitchState extends State<EnableSwitch> {
  final GeneralMenuController _controller = Get.find<GeneralMenuController>();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300.0, // Define la anchura del componente
      child: Container(
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Colors.grey[200], // Fondo gris claro
          borderRadius: BorderRadius.circular(10.0), // Esquinas curvadas
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'DETECCIÓN DE CAÍDAS',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0
                  ),
                ),
                Obx(() => Text(
                  _controller.isFallDetectionEnabled.value ? 'Activado' : 'Desactivado',
                  style: TextStyle(
                    fontSize: 14.0,
                  ),
                )),
              ],
            ),
            Obx(() => Switch(
              value: _controller.isFallDetectionEnabled.value,
              onChanged: (value) {
                _controller.toggleFallDetection(value);
              },
            )),
          ],
        ),
      ),
    );
  }
}