import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../models/user_profile.dart';
import '../components/my_drawer.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        title: Text(currentUser?.email?.split('@')[0] ?? "Perfil",
            style: const TextStyle(fontWeight: FontWeight.bold)),
        // actions: [
        //   IconButton(icon: const Icon(Icons.menu), onPressed: () {
        //   }),
        // ],
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser?.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          var userData = snapshot.data!.data() as Map<String, dynamic>?;
          UserProfile profile = UserProfile.fromFirestore(userData ?? {}, currentUser!.uid);

          return Column(
            children: [
              // CABECERA TIPO INSTAGRAM
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: profile.profileImageUrl.isNotEmpty
                          ? NetworkImage(profile.profileImageUrl)
                          : null,
                      child: profile.profileImageUrl.isEmpty ? const Icon(Icons.person, size: 40) : null,
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildStatColumn("12", "Pedidos"),
                          _buildStatColumn("150", "Puntos"),
                          _buildStatColumn("5", "Cupones"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // NOMBRE Y BIO
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(profile.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text(profile.bio),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // BOTÓN EDITAR PERFIL
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(40),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () => _showEditDialog(context, profile),
                  child: const Text("Editar Perfil", style: TextStyle(color: Colors.black)),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatColumn(String value, String label) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }

  // DIÁLOGO PARA EDITAR EN TIEMPO REAL
  void _showEditDialog(BuildContext context, UserProfile profile) {
    final nameController = TextEditingController(text: profile.name);
    final bioController = TextEditingController(text: profile.bio);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 20, right: 20, top: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Editar Perfil", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextField(controller: nameController, decoration: const InputDecoration(labelText: "Nombre")),
            TextField(controller: bioController, decoration: const InputDecoration(labelText: "Bio")),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await FirebaseFirestore.instance.collection('users').doc(profile.uid).set({
                  'name': nameController.text,
                  'bio': bioController.text,
                }, SetOptions(merge: true));
                Navigator.pop(context);
              },
              child: const Text("Guardar Cambios"),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
