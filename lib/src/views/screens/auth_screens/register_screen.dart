import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../controllers/auth_controller.dart';

class RegisterScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController fullnameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();

  RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = context.watch<AuthController>();

    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          children: [
            Icon(Icons.person_add_rounded, size: 80, color: Theme.of(context).colorScheme.inversePrimary),
            const SizedBox(height: 25),
            const Text("CREA TU CUENTA", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 25),

            // Campos de texto
            _buildTextField(fullnameController, "Nombre Completo", Icons.person),
            const SizedBox(height: 10),
            _buildTextField(usernameController, "Nombre de Usuario", Icons.alternate_email),
            const SizedBox(height: 10),
            _buildTextField(emailController, "Email", Icons.email),
            const SizedBox(height: 10),
            _buildTextField(passwordController, "Contraseña", Icons.lock, isObscure: true),

            const SizedBox(height: 25),

            authController.isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(55),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () async {
                String? error = await authController.signUp(
                  emailController.text,
                  passwordController.text,
                  fullnameController.text,
                  usernameController.text,
                );

                if (error == null) {
                  Navigator.pop(context); // Volver al AuthGate que nos mandará al Home
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
                }
              },
              child: const Text("Registrarse"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {bool isObscure = false}) {
    return TextField(
      controller: controller,
      obscureText: isObscure,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}