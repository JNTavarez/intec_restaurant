import 'package:flutter/material.dart';
import '../../../models/parse_food_model.dart';

class FoodMenu extends StatefulWidget {
  const FoodMenu({super.key});

  @override
  State<FoodMenu> createState() => _FoodMenuState();
}

class _FoodMenuState extends State<FoodMenu> {
  late Future<List<Food>> futureMenu;

  @override
  void initState() {
    super.initState();
    futureMenu = FoodRepository().loadMenu();
  }

  List<Food> filterByCategory(List<Food> foods, FoodCategory category) {
    return foods.where((food) => food.category == category).toList();
  }

  Widget buildFoodList(List<Food> foods) {
    return ListView.builder(
      itemCount: foods.length,
      itemBuilder: (context, index) {
        final food = foods[index];

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 8,
                offset: const Offset(0, 4),
              )
            ],
          ),

          child: Row(
            children: [

              // IMAGEN GRANDE
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  food.imagePath,
                  width: 110,
                  height: 110,
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(width: 16),

              // TEXTO
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // NOMBRE
                    Text(
                      food.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(width: 6),

                    // PRECIO VERDE
                    Text(
                      "\$${food.price.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),

                    const SizedBox(width: 10),

                    // DESCRIPCIÓN
                    Text(
                      food.description,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Column(
        children: [
          const TabBar(
            tabs: [
              Tab(text: "Burgers"),
              Tab(text: "Salads"),
              Tab(text: "Sides"),
              Tab(text: "Desserts"),
              Tab(text: "Drinks"),
            ],
          ),

          Expanded(
            child: FutureBuilder<List<Food>>(
              future: futureMenu,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return const Center(child: Text("Error loading menu"));
                }

                final foods = snapshot.data!;

                return TabBarView(
                  children: [
                    buildFoodList(filterByCategory(foods, FoodCategory.burgers)),
                    buildFoodList(filterByCategory(foods, FoodCategory.salads)),
                    buildFoodList(filterByCategory(foods, FoodCategory.sides)),
                    buildFoodList(filterByCategory(foods, FoodCategory.desserts)),
                    buildFoodList(filterByCategory(foods, FoodCategory.drinks)),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}