import 'package:flutter/material.dart';


class FallingButton extends StatefulWidget {
  final VoidCallback onPressed;
  final VoidCallback onCompleted;
  final VoidCallback onInit;
  final int durationInSeconds;

  FallingButton({
    required this.onInit,
    required this.onPressed,
    required this.onCompleted,
    this.durationInSeconds = 10
  });

  @override
  FallingButtonState createState() => FallingButtonState();
}

class FallingButtonState extends State<FallingButton> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  bool isButtonPressed = false;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: Duration(seconds: widget.durationInSeconds));
    //Init the animation
    controller.forward();
    controller.addListener(() {
      setState(() {});
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onInit();
    });

    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        //print('Confirmed Falling');
        setState((){
          isButtonPressed = false;
        });
        widget.onPressed();
        //controller.reset();
      }
      if (status == AnimationStatus.dismissed) {
        setState((){
          isButtonPressed = false;
        });
        widget.onCompleted();
        controller.reset();
      }

    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(

      onTapDown: (_){
        controller.reverse();
        setState((){
          isButtonPressed = true;
        });
      },
      onTapUp: (_) {
        if (controller.status == AnimationStatus.reverse) {
          controller.forward();
        }
      },
      child: Container(
        width: 200.0, // Ajusta el valor según sea necesario
        height: 200.0, // Ajusta el valor según sea necesario
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            SizedBox(
              width: 300.0, // Ajusta el valor según sea necesario
              height: 300.0, // Ajusta el valor según sea necesario
              child: CircularProgressIndicator(
                value: 1.0,
                strokeWidth: 20.0,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
              ),
            ),
            SizedBox(
              width: 300.0, // Ajusta el valor según sea necesario
              height: 300.0, // Ajusta el valor según sea necesario
              child: CircularProgressIndicator(
                value: controller.value,
                strokeWidth: 20.0,
                valueColor: AlwaysStoppedAnimation<Color>(const Color.fromARGB(255, 243, 33, 33)),
              ),
            ),
            //Icon(Icons.add_location, size: 150.0), // Ajusta el tamaño del icono según sea necesario
            Text(
              '${controller.duration != null ? (controller.duration!.inSeconds * (1-controller.value)).round() + 1 : 0}',
              style: Theme.of(context).textTheme.headline4!.copyWith(
                fontSize: 60, // Ajusta el tamaño del texto a tu gusto
                fontWeight: FontWeight.bold, // Hace que el texto sea en negrita
              ),
            ),
          ],
        ),
      ),
    );
  }
}
