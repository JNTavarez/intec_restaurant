import 'package:flutter/material.dart';

class MyDescriptionBox extends StatelessWidget {
  const MyDescriptionBox({super.key});

  @override
  Widget build(BuildContext context) {
    var myPrimaryTextStyle = TextStyle(
      color: Theme.of(context).colorScheme.inversePrimary,
    );

    var myScondaryTextStyle = TextStyle(
      color: Theme.of(context).colorScheme.primary,
    );

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Theme.of(context).colorScheme.secondary),
      ),
      padding: EdgeInsets.all(25),
      margin: EdgeInsets.only(left: 25, right: 25, bottom: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //delivery fee
          Column(
            children: [
              Text('\$0.99', style: myPrimaryTextStyle),
              Text('Delivery fee', style: myScondaryTextStyle),
            ],
          ),
          //delivery time
          Column(
            children: [
              Text('15-30 minutes', style: myPrimaryTextStyle),
              Text('Delivery time', style: myScondaryTextStyle),
            ],
          ),
        ],
      ),
    );
  }
}
