import 'package:flutter/material.dart';
import 'package:intec_restaurant/src/views/screens/auth_screens/register_screen.dart';
import 'package:provider/provider.dart';

import '../../../controllers/auth_controller.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = context.watch<AuthController>();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
             Icon(Icons.lock_open_rounded, size: 80, color: Theme.of(context).colorScheme.inversePrimary),
            const SizedBox(height: 25),
            const Text("BIENVENIDO DE NUEVO", style: TextStyle(fontSize: 16)),
            const SizedBox(height: 25),

            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: "Email", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Contraseña", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 25),

            authController.isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
              style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
              onPressed: () async {
                String? error = await authController.signIn(
                    emailController.text,
                    passwordController.text
                );
                if (error != null) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
                }
              },
              child: const Text("Iniciar Sesión"),
            ),

            TextButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (c) => RegisterScreen())),
              child: const Text("¿No tienes cuenta? Regístrate aquí"),
            )
          ],
        ),
      ),
    );
  }
}