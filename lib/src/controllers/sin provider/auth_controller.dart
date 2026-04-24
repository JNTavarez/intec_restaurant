import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthController {
  final _firebaseAuth = FirebaseAuth.instance;
  final _firebaseFirestore = FirebaseFirestore.instance;

  //metodo para registrar un usuario
  Future<String> RegisterUser(
    String fullName,
    String email,
    String password,
  ) async {
    String res = "Something went wrong";

    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      //guardamos el usuario registrado en la BD
      await _firebaseFirestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
            "full_name": fullName,
            "profile_image": "",
            "email": email,
            "uid": userCredential.user!.uid,
            "city": "",
          });
      res = "success";
    } on FirebaseException catch (e) {
      if (e.code == "weak-password") {
        res = " The password provided is too weak";
      } else if (e.code == "email-already-in-use") {
        res = "The account already exists for that email";
      }
    } catch (e) {
      res = e.toString();
    }

    return res;
  }

  //login de usuario
  Future<String> loginUser(String email, String password) async {
    String res = "Something went wrong";

    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      res = "success";
    } on FirebaseException catch (e) {
      if (e.code == " user-not-found") {
        res = "user not found";
      } else if (e.code == "wrong-password") {
        res = "Wrong password provided for this user";
      }
    } catch (e) {
      print(e.toString());
      res = e.toString();
    }
    return res;
  }
}
