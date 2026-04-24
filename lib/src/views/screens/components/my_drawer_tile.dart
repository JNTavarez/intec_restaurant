import 'package:flutter/material.dart';

class MyDrawerTile extends StatelessWidget {
  const MyDrawerTile({
    super.key,
    required this.text,
    required this.icon,
    required this.ontap,
  });

  final String text;
  final IconData? icon;
  final void Function()? ontap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25),
      child: ListTile(
        title: Text(
          text,
          style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
        ),
        leading: Icon(
          icon,
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
        onTap: ontap,
      ),
    );
  }
}
