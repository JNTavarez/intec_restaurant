// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:intec_restaurant/src/controllers/auth_controller.dart';
// import 'package:intec_restaurant/src/views/screens/auth_screens/login_screen.dart';
//
//
//
// class RegisterScreen extends StatefulWidget {
//   const RegisterScreen({super.key});
//
//   @override
//   State<RegisterScreen> createState() => _RegisterScreenState();
// }
//
// class _RegisterScreenState extends State<RegisterScreen> {
//
//
//
//   GlobalKey<FormState> _key = GlobalKey<FormState>();
//   final _fullNameController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _confirmPasswordController = TextEditingController();
//
//   late String email;
//   late String password;
//   late String fullName;
//
//   bool _isLoading = false;
//
//   final _authController = AuthController();
//
//   //metodo para realizar el registro del usuario
//   void register() async{
//     if(_key.currentState!.validate()){
//       //ejecutamos el proceso de login
//       setState(() {
//         _isLoading = true;
//       });
//       String res = await _authController.RegisterUser(_fullNameController.text, _emailController.text, _passwordController.text);
//
//       if (res == 'success'){
//         Future.delayed(Duration.zero, () {
//           Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen(),));
//           ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Account Created')));
//         },);
//       }else{
//         setState(() {
//           _isLoading = false;
//         });
//         Future.delayed(Duration.zero, () {
//           ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res)));
//         },);
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: Theme.of(context).colorScheme.surface,
//       body: Center(
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: EdgeInsets.symmetric(horizontal: 20),
//             child: Form(
//               key: _key,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text('Create a New Account', style: GoogleFonts.roboto(
//                     textStyle: TextStyle(
//                         fontSize: 40,
//                         fontWeight: FontWeight.bold
//                     ),
//                   ),),
//                   SizedBox(
//                     height: 40,
//                   ),
//                   TextFormField(
//                     controller: _fullNameController,
//                     validator: nameValidator.call,
//                     keyboardType: TextInputType.text,
//                     decoration: InputDecoration(
//                         border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(12)
//                         ),
//                         labelText: "name",
//                         labelStyle: GoogleFonts.roboto(),
//                         hintText: "your name",
//                         hintStyle: GoogleFonts.roboto(),
//                         prefixIcon: Icon(Icons.person, size: 30,)
//                     ),
//                   ),
//                   SizedBox(height: 20,),
//                   TextFormField(
//                     controller: _emailController,
//                     validator: emailValidator.call,
//                     keyboardType: TextInputType.emailAddress,
//                     decoration: InputDecoration(
//                         border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(12)
//                         ),
//                         labelText: "Email",
//                         labelStyle: GoogleFonts.roboto(),
//                         hintText: "user@domain.com",
//                         hintStyle: GoogleFonts.roboto(),
//                         prefixIcon: Icon(Icons.email_outlined, size: 30,)
//                     ),
//                   ),
//                   SizedBox(height: 20,),
//                   TextFormField(
//                     controller: _passwordController,
//                     validator: passwordValidator.call,
//                     keyboardType: TextInputType.text,
//                     decoration: InputDecoration(
//                         border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(12)
//                         ),
//                         labelText: "Password",
//                         labelStyle: GoogleFonts.roboto(),
//                         hintText: "your password",
//                         hintStyle: GoogleFonts.roboto(),
//                         prefixIcon: Icon(Icons.lock_outline, size: 30,),
//                         )
//                     ),
//                   SizedBox(height: 10,),
//                   TextFormField(
//                     controller: _confirmPasswordController,
//                       validator: passwordValidator.call,
//                       keyboardType: TextInputType.text,
//                       decoration: InputDecoration(
//                         border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(12)
//                         ),
//                         labelText: "Confirm Password",
//                         labelStyle: GoogleFonts.roboto(),
//                         hintText: "your password",
//                         hintStyle: GoogleFonts.roboto(),
//                         prefixIcon: Icon(Icons.lock_outline, size: 30,),
//                       )
//                   ),
//                   SizedBox(height: 10,),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: [
//                       Text("Already have an account?"),
//                       SizedBox(width: 5,),
//                       InkWell(
//                         onTap: (){
//                           //ir a la pagina de registro
//                           Navigator.push(context, MaterialPageRoute(builder: (context) {
//                             return LoginScreen();
//                           },));
//                         },
//                         child: Text("login here", style: GoogleFonts.roboto(
//                             fontWeight: FontWeight.bold,
//                           color: Colors.black
//                         ),),
//                       ),
//                     ],
//                   ),
//                   SizedBox(
//                     height: 40,
//                   ),
//                   InkWell(
//                     onTap: () {
//                       //llamar al metodo para ejecutar el registro
//                       register();
//                     },
//                     child: Container(
//                       width: double.infinity,
//                       height: 65,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(12),
//                         border: Border.all(color: Colors.black),
//                         color: Colors.transparent,
//                       ),
//                       child: Center(
//                         child: Text("Register", style: GoogleFonts.roboto(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 25,
//                             color: Colors.black
//                         ),),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
