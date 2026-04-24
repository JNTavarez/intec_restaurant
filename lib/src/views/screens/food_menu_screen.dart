import 'package:flutter/material.dart';
import 'package:intec_restaurant/src/models/parse_food_model.dart';
import 'package:intec_restaurant/src/views/screens/components/my_food_tile.dart';
import 'package:intec_restaurant/src/views/screens/tab_screens/cart_screen.dart';
import 'package:provider/provider.dart';

import '../../models/restaurant.dart';
import 'food_detail_screen.dart';

class FoodMenuScreen extends StatefulWidget {
  const FoodMenuScreen({super.key});

  @override
  State<FoodMenuScreen> createState() => _FoodMenuScreenState();
}

class _FoodMenuScreenState extends State<FoodMenuScreen> {
  // Guardamos el future en una variable para que no se reinicie
  late Future<List<Food>> _menuFuture;

  @override
  void initState() {
    super.initState();
    _menuFuture = FoodRepository().loadMenu();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: FoodCategory.values.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Restaurant Menu"),
          actions: [
            Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.shopping_cart),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (c) => const CartScreen()),
                  ),
                ),
                Positioned(
                  right: 8,
                  top: 8,
                  child: Consumer<Restaurant>(
                    builder: (context, restaurant, child) {
                      int totalItems = restaurant.cart.fold(
                        0,
                        (sum, item) => sum + item.quantity,
                      );
                      return totalItems > 0
                          ? CircleAvatar(
                              radius: 8,
                              backgroundColor: Colors.red,
                              child: Text(
                                totalItems.toString(),
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.white,
                                ),
                              ),
                            )
                          : const SizedBox();
                    },
                  ),
                ),
              ],
            ),
          ],
          bottom: TabBar(
            //isScrollable: true,
            tabs: FoodCategory.values.map((cat) {
              return Tab(
                // .name devuelve "burgers", luego lo ponemos en mayúscula
                text: cat.name[0].toUpperCase() + cat.name.substring(1),
              );
            }).toList(),
          ),
        ),
        body: FutureBuilder<List<Food>>(
          future: _menuFuture, // Cargamos el JSON
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              //return Center(child: Text("Error al cargar menú"));
              return Center(child: Text("Error real: ${snapshot.error}"));
            }

            final allFood = snapshot.data!;

            // Creamos una vista para cada categoría del Enum
            return TabBarView(
              children: FoodCategory.values.map((category) {
                // FILTRADO: Solo mostramos la comida que coincide con la categoría del Tab
                final filteredFood = allFood
                    .where((food) => food.category == category)
                    .toList();

                return ListView.builder(
                  itemCount: filteredFood.length,
                  itemBuilder: (context, index) {
                    final item = filteredFood[index];
                    return MyFoodTile(
                      food: item,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FoodDetailScreen(food: item),
                          ),
                        );
                      },
                    );
                  },
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}
