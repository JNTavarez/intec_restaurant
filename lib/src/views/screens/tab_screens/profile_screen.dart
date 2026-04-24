import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../controllers/auth_controller.dart';
import '../components/my_drawer.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final authController = AuthController();
  final currentUser = FirebaseAuth.instance.currentUser;
  bool _isUploading = false;

  // Método para seleccionar y subir imagen
  Future<void> _pickAndUploadImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);

    if (pickedFile != null) {
      setState(() => _isUploading = true);

      try {
        String downloadUrl = await authController.uploadProfileImage(File(pickedFile.path), currentUser!.uid);

        // Actualizar Firestore con la nueva URL
        await FirebaseFirestore.instance.collection('users').doc(currentUser!.uid).update({
          'profile_image': downloadUrl,
        });
      } finally {
        setState(() => _isUploading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(title: const Text("P E R F I L"), centerTitle: true),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('users').doc(currentUser!.uid).snapshots(),
        builder: (context, snapshot) {
          //1. Si el documento ya no existe en la base de datos
          if (snapshot.hasData && !snapshot.data!.exists) {
            // Esperamos un frame para evitar errores de navegación durante el build
            WidgetsBinding.instance.addPostFrameCallback((_) {
              FirebaseAuth.instance.signOut(); // Esto activará el AuthGate
            });
            return const Center(child: Text("Tu cuenta ha sido eliminada."));
          }
          // 2. Verificar si hay errores
          if (snapshot.hasError) return const Center(child: Text("Error al cargar datos"));

          // 3. Verificar si está cargando
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // 4. Verificar si el documento existe de verdad
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text("El perfil no existe en la base de datos"));
          }

          // 5. Casting seguro (ahora que sabemos que existe)
          var userData = snapshot.data!.data() as Map<String, dynamic>;

          return SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),

                // FOTO DE PERFIL CON BOTÓN DE EDICIÓN
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 64,
                      backgroundColor: Colors.grey[300],
                      backgroundImage: userData['profileImageUrl'] != ''
                          ? NetworkImage(userData['profileImageUrl'])
                          : null,
                      child: userData['profileImageUrl'] == ''
                          ? const Icon(Icons.person, size: 60)
                          : (_isUploading ? const CircularProgressIndicator() : null),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: IconButton(
                        onPressed: _pickAndUploadImage,
                        icon: const CircleAvatar(
                          backgroundColor: Colors.orange,
                          radius: 18,
                          child: Icon(Icons.camera_alt, color: Colors.white, size: 18),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),
                Text("@${userData['username']}", style: const TextStyle(fontWeight: FontWeight.bold)),

                const SizedBox(height: 25),

                // CAMPOS DE INFORMACIÓN
                _buildProfileItem("Nombre", userData['fullname'], Icons.person, "fullname"),
                _buildProfileItem("Bio", userData['bio'], Icons.info_outline, "bio"),
                _buildProfileItem("Teléfono", userData['phone'], Icons.phone, "phone"),
                _buildProfileItem("Dirección", userData['address'], Icons.location_on, "address"),

                const SizedBox(height: 30),

                // BOTÓN CERRAR SESIÓN
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: OutlinedButton.icon(
                    onPressed: () => FirebaseAuth.instance.signOut(),
                    icon: const Icon(Icons.logout),
                    label: const Text("Cerrar Sesión"),
                    style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Widget para cada fila de datos que abre un editor
  Widget _buildProfileItem(String label, String value, IconData icon, String field) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          title: Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          subtitle: Text(value == '' ? "No completado" : value, style: const TextStyle(fontSize: 16)),
          leading: Icon(icon),
          trailing: const Icon(Icons.edit, size: 18),
          onTap: () => _showEditDialog(label, value, field),
        ),
      ),
    );
  }

  void _showEditDialog(String label, String value, String field) {
    TextEditingController controller = TextEditingController(text: value);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Editar $label"),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(hintText: "Escribe tu $label"),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancelar")),
          TextButton(
            onPressed: () async {
              await FirebaseFirestore.instance.collection('users').doc(currentUser!.uid).update({
                field: controller.text,
              });
              Navigator.pop(context);
            },
            child: const Text("Guardar"),
          ),
        ],
      ),
    );
  }
}