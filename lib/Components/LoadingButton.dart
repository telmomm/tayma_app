import 'package:flutter/material.dart';

class LoadingButton extends StatefulWidget {
  final VoidCallback onPressed;

  LoadingButton({required this.onPressed});

  @override
  LoadingButtonState createState() => LoadingButtonState();
}

class LoadingButtonState extends State<LoadingButton> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  bool isButtonPressed = false;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(vsync: this, duration: Duration(seconds: 1));
    controller.addListener(() {
      setState(() {});
    });
    controller.addStatusListener((status) {
    if (status == AnimationStatus.completed) {
      //print('Button pressed');
      setState((){
        isButtonPressed = true;
      });
      controller.reset();
      widget.onPressed();
      
      // Aquí puedes poner el código que quieres que se ejecute cuando la animación se complete
    }
  });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_){
        //print("Button pressed");
        controller.forward();
        setState((){
          isButtonPressed = true;
        });
      },
      onTapUp: (_) {
        if (controller.status == AnimationStatus.forward) {
          controller.reverse();
        }
      },
      child: Container(
        width: 250.0, // Ajusta el valor según sea necesario
        height: 250.0, // Ajusta el valor según sea necesario
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            SizedBox(
              width: 400.0, // Ajusta el valor según sea necesario
              height: 400.0, // Ajusta el valor según sea necesario
              child: CircularProgressIndicator(
                value: 1.0,
                strokeWidth: 25.0,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
              ),
            ),
            SizedBox(
              width: 300.0, // Ajusta el valor según sea necesario
              height: 300.0, // Ajusta el valor según sea necesario
              child: CircularProgressIndicator(
                value: controller.value,
                strokeWidth: 25.0,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            ),
            //Icon(Icons.sos, size: 150.0), 
            Image.asset(('assets/images/tayma.png'), width: 200.0, height: 200.0), // Ajusta el tamaño según sea necesario
            // Ajusta el tamaño del icono según sea necesario
          ],
        ),
      ),
    );
  }
}

