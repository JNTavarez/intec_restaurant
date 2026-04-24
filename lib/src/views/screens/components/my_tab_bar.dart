import 'package:flutter/material.dart';

import '../../../models/parse_food_model.dart';

class MyTabBar extends StatelessWidget {
  const MyTabBar({super.key, required this.tabController});

  final TabController tabController;

  List<Tab> _buildCategoryTabs() {
    return FoodCategory.values.map((category) {
      return Tab(text: category.toString().split('.').last);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TabBar(
        //isScrollable: true, // Útil si los nombres son largos o hay muchos
        controller: tabController,
        tabs: _buildCategoryTabs(),
      ),
    );
  }
}
