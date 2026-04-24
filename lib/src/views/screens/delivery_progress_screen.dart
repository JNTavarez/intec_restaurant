import 'package:flutter/material.dart';
import 'package:intec_restaurant/src/views/screens/home_screen.dart';

class DeliveryProgressScreen extends StatefulWidget {
  const DeliveryProgressScreen({super.key});

  @override
  State<DeliveryProgressScreen> createState() => _DeliveryProgressScreenState();
}

class _DeliveryProgressScreenState extends State<DeliveryProgressScreen> {
  @override
  void initState() {
    super.initState();
    // Simulamos un tiempo de espera para el procesamiento
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        // Al terminar, volvemos al inicio o a una pantalla de agradecimiento
        //Navigator.popUntil(context, (route) => route.isFirst);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
          (route) => false,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("¡Pedido enviado con éxito!")),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Aquí puedes usar Lottie.asset('assets/delivery_anim.json')
            // si tienes una animación de Lottie. Por ahora usaremos iconos:
            const Icon(Icons.delivery_dining, size: 100, color: Colors.orange),

            const SizedBox(height: 25),

            const CircularProgressIndicator(color: Colors.orange),

            const SizedBox(height: 25),

            const Text(
              "¡Estamos preparando tu pedido!",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 10),
              child: Text(
                "Tu deliciosa comida estará en camino en unos momentos...",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
