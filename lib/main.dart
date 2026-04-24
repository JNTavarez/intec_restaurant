import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intec_restaurant/src/controllers/auth_controller.dart';
import 'package:intec_restaurant/src/models/restaurant.dart';
import 'package:intec_restaurant/src/themes/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'firebase_options.dart';
import 'src/themes/dark_mode.dart';
import 'src/themes/light_mode.dart';
import 'src/views/screens/auth_screens/login_screen.dart';
import 'src/views/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthController()),
        ChangeNotifierProvider(create: (_) => Restaurant()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: IntecRestaurant(),
    ),
  );
}

class IntecRestaurant extends StatelessWidget {
  const IntecRestaurant({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return ChangeNotifierProvider(
      create: (_) => AuthController(),
      child: MaterialApp(
        title: 'Intec Restaurant',
        themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
        theme: lightMode,
        darkTheme: darkMode,
        debugShowCheckedModeBanner: false,
        home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(body: Center(child: CircularProgressIndicator()));
            }
            if (snapshot.hasData && snapshot.data != null) {
              return const HomeScreen(); // Usuario logueado
            }
            return LoginScreen(); // Usuario NO logueado
          },
        ),
      ),
    );
  }
}
