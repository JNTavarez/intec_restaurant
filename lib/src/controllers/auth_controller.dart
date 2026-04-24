import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthController extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  User? get currentUser => _auth.currentUser;

  // Registro con Email y Contraseña
  Future<String?> signUp(
    String email,
    String password,
    String fullname,
    String username,
  ) async {
    _setLoading(true);
    try {
      // 1. Crear el usuario en Firebase Auth
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      // 2. Crear el documento en Firestore con campos iniciales
      String uid = userCredential.user!.uid;
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'uid': uid,
        'fullname': fullname,
        'username': username,
        'email': email,
        'address': '', // Vacío para completar luego
        'phone': '', // Vacío para completar luego
        'bio': '', // Vacío para completar luego
        'profileImageUrl': '',
        'createdAt': FieldValue.serverTimestamp(),
      });

      _setLoading(false);
      return null;
    } on FirebaseAuthException catch (e) {
      _setLoading(false);
      return e.message;
    }
  }

  // Inicio de Sesión
  Future<String?> signIn(String email, String password) async {
    _setLoading(true);
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      _setLoading(false);
      return null;
    } on FirebaseAuthException catch (e) {
      _setLoading(false);
      return e.message;
    }
  }

  // Cerrar Sesión
  Future<void> signOut() async {
    await _auth.signOut();
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<String> uploadProfileImage(File imageFile, String uid) async {
    try {
      // 1. Crear una referencia al lugar donde se guardará la foto
      // La ruta será: profile_images / {ID_DEL_USUARIO}.jpg
      Reference ref = FirebaseStorage.instance
          .ref()
          .child('profile_images')
          .child('$uid.jpg');

      // 2. Subir el archivo al Storage
      UploadTask uploadTask = ref.putFile(imageFile);

      // 3. Esperar a que la subida termine
      TaskSnapshot snapshot = await uploadTask;

      // 4. Obtener y retornar la URL pública de la imagen
      String downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      print("Error al subir imagen: $e");
      throw Exception("Error al cargar la imagen de perfil");
    }
  }
}
