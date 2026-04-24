import 'dart:convert';
import 'package:flutter/services.dart';

//food categories
enum FoodCategory { burgers, salads, sides, desserts, drinks }

class Addon {
  final String name;
  final double price;

  Addon({required this.name, required this.price});

  // Convierte un JSON en un objeto Addon
  factory Addon.fromJson(Map<String, dynamic> json) {
    return Addon(name: json['name'], price: json['price'].toDouble());
  }

  // Convertir a Mapa
  Map<String, dynamic> toMap() {
    return {'name': name, 'price': price};
  }

  // Convierte un objeto Addon a JSON
  Map<String, dynamic> toJson() => {'name': name, 'price': price};
}

class Food {
  final String name;
  final String description;
  final String imagePath;
  final double price;
  final FoodCategory category;
  final List<Addon> availableAddons;

  Food({
    required this.name,
    required this.description,
    required this.imagePath,
    required this.price,
    required this.category,
    required this.availableAddons,
  });

  // Método ToMap
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'imagePath': imagePath,
      'price': price,
      // Convertimos la lista de objetos Addon en una lista de Mapas
      'availableAddons': availableAddons.map((addon) => addon.toMap()).toList(),
    };
  }

  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      name: json['name'],
      description: json['description'],
      imagePath: json['imagePath'],
      price: json['price'].toDouble(),
      category: FoodCategory.values.firstWhere(
        (e) => e.name == json['category'],
      ),
      availableAddons: (json['availableAddons'] as List)
          .map((addon) => Addon.fromJson(addon))
          .toList(),
    );
  }
}

class FoodRepository {
  Future<List<Food>> loadMenu() async {
    // 1. Cargar el archivo como String
    final String response = await rootBundle.loadString(
      'assets/data/menu.json',
    );

    // 2. Decodificar a una lista dinámica
    final List<dynamic> data = json.decode(response);

    // 3. Mapear a objetos Food usando el factory que creamos
    return data.map((json) => Food.fromJson(json)).toList();
  }
}
