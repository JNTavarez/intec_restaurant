import 'package:flutter/material.dart';
import 'package:intec_restaurant/src/views/screens/food_menu_screen.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen>
    with SingleTickerProviderStateMixin {
  // //tab controller
  // late TabController _tabController;

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   // super.initState();
  //   // _tabController = TabController(
  //   //   length: FoodCategory.values.length,
  //   //   vsync: this,
  //   //);
  // }

  @override
  void dispose() {
    // TODO: implement dispose
    // _tabController.dispose();
    super.dispose();
  }

  // // Sorts out and returns a list of food items that belong to a
  // // specific category from a larger list of food items.
  // List<Food> _filterMenuByCategory(FoodCategory category, List<Food> fullMenu) {
  //   return fullMenu.where((food) => food.category == category).toList();
  // }

  // // return list of foods in given category
  // List<Widget> getFoodInThisCategory(List<Food> fullMenu) {
  //   return FoodCategory.values.map((category) {
  //
  //     //get category menu
  //     List<Food> categoryMenu = _filterMenuByCategory(category, fullMenu);
  //     return ListView.builder(
  //       itemCount: categoryMenu.length,
  //       physics: const NeverScrollableScrollPhysics(),
  //       padding: EdgeInsets.zero,
  //       itemBuilder: (context, index) {
  //
  //         //return de food tile UI
  //         return MyFoodTile(food: categoryMenu[index], onTap: (){});
  //       },
  //     );
  //   }).toList();
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: FoodMenuScreen()); //FoodMenuScreen();
  }
}
