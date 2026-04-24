import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intec_restaurant/src/themes/theme_provider.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Text("Settings"),
      ),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Text(
                  "Dark Mode", style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.inversePrimary
                ),
                ),
                CupertinoSwitch(
                  value: Provider.of<ThemeProvider>(context).isDarkMode,
                  onChanged: (value){
                    context.read<ThemeProvider>().toggleTheme();
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
