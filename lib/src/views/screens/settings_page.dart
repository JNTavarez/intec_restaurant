import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../themes/theme_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Text('Settings'),
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(left: 25, top: 10, right: 25),
            padding: EdgeInsets.all(25),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Theme.of(context).colorScheme.secondary,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Dark Mode',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.inversePrimary
                ),
                ),
                CupertinoSwitch(
                  value: Provider.of<ThemeProvider>(context, listen: false).isDarkMode,
                  onChanged: (value) {
                    Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
                },),
              ],
            ),
          )
        ],
      ),
    );
  }
}
