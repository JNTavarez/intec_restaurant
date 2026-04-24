import 'package:flutter/material.dart';
import 'package:intec_restaurant/src/controllers/auth_controller.dart';
import 'package:intec_restaurant/src/views/screens/payment_methods_screen.dart';
import '../settings_page.dart';
import 'my_drawer_tile.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          //app logo
          Padding(
            padding: const EdgeInsets.all(100.0),
            child: Icon(
              Icons.lock_open_rounded,
              size: 80,
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Divider(
              thickness: 2,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          //home list tile
          MyDrawerTile(
            text: 'H O M E',
            icon: Icons.home_outlined,
            ontap: () {
              Navigator.pop(context);
            },
          ),
          //setting list tile
          MyDrawerTile(
            text: 'S E T T I N G S',
            icon: Icons.settings_outlined,
            ontap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return SettingsPage();
                  },
                ),
              );
            },
          ),
          //payment mode list tile
          MyDrawerTile(
            text: 'M Y  C A R D S',
            icon: Icons.credit_card,
            ontap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (c) => const PaymentMethodsScreen()),
              );
            },
          ),
          // Spacer(),
          // //logout list tile
          // MyDrawerTile(
          //   text: 'L O G O U T',
          //   icon: Icons.logout_rounded,
          //   ontap: () {
          //     final authController = AuthController();
          //     authController.signOut();
          //   },
          // ),
          SizedBox(height: 25),
        ],
      ),
    );
  }
}
