import 'package:flutter/material.dart';
import 'package:intec_restaurant/src/models/parse_food_model.dart';
import 'package:collection/collection.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'card_model.dart';

class Restaurant extends ChangeNotifier {
  // Lista de productos en el carrito
  List<CartItem> _cart = [];
  // Getter para acceder al carrito
  List<CartItem> get cart => _cart;

  // NUEVO: Lista de favoritos
  List<Food> _favorites = [];
  List<Food> get favorites => _favorites;

  // Constructor: Cargamos el carrito nada más iniciar la app
  Restaurant() {
    loadCartFromLocale();
    // Constructor: Cargamos favoritos al iniciar
    loadFavoritesFromLocale(); // Cargar favoritos guardados
  }

  // --- MÉTODOS DE PERSISTENCIA ---

  Future<void> saveCartToLocale() async {
    final prefs = await SharedPreferences.getInstance();
    // Convertimos la lista de items a un String JSON
    String jsonCart = jsonEncode(_cart.map((item) => item.toMap()).toList());
    await prefs.setString('user_cart', jsonCart);
  }

  Future<void> loadCartFromLocale() async {
    final prefs = await SharedPreferences.getInstance();
    String? jsonCart = prefs.getString('user_cart');

    if (jsonCart != null) {
      List<dynamic> decodedData = jsonDecode(jsonCart);
      _cart = decodedData.map((item) => CartItem.fromMap(item)).toList();
      notifyListeners();
    }
  }

  // Añadir al carrito
  void addToCart(Food food, List<Addon> selectedAddons) {
    // Buscamos si ya existe el mismo plato con los mismos addons
    CartItem? cartItem = _cart.firstWhereOrNull((item) {
      bool isSameFood = item.food == food;
      bool isSameAddons = const ListEquality().equals(item.selectedAddons, selectedAddons);
      return isSameFood && isSameAddons;
    });

    if (cartItem != null) {
      cartItem.quantity++;
    } else {
      _cart.add(CartItem(
        food: food,
        selectedAddons: selectedAddons,
      ));
    }
    // (Después de modificar la lista _cart, guardamos)
    saveCartToLocale(); // <--- Guardar cambio

    notifyListeners(); // Notifica a la UI para que se actualice
  }

  // Eliminar del carrito
  void removeFromCart(CartItem cartItem) {
    int cartIndex = _cart.indexOf(cartItem);

    if (cartIndex != -1) {
      if (_cart[cartIndex].quantity > 1) {
        _cart[cartIndex].quantity--;
      } else {
        _cart.removeAt(cartIndex);
      }
    }

    saveCartToLocale(); // <--- Guardar cambio
    notifyListeners();
  }

  // Calcular precio total
  double getTotalPrice() {
    double total = 0.0;
    for (CartItem item in _cart) {
      double itemTotal = item.food.price;
      for (Addon addon in item.selectedAddons) {
        itemTotal += addon.price;
      }
      total += itemTotal * item.quantity;
    }
    return total;
  }

  //limpiar el carrito
  void clearCart() async{
    _cart.clear();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_cart'); // Limpiar memoria local
    notifyListeners();
  }

  // En tu clase Restaurant
  String displayCartReceipt() {
    final receipt = StringBuffer();
    receipt.writeln("Aquí tienes tu recibo:");
    receipt.writeln();

    for (final item in _cart) {
      receipt.writeln("${item.quantity} x ${item.food.name} - \$${item.food.price}");
      if (item.selectedAddons.isNotEmpty) {
        receipt.writeln("   Add-ons: ${item.selectedAddons.map((a) => a.name).join(", ")}");
      }
    }
    receipt.writeln("----------");
    receipt.writeln("Total: \$${getTotalPrice().toStringAsFixed(2)}");

    return receipt.toString();
  }

  // NUEVO: Estado para la tarjeta seleccionada
  CardModel? _selectedPaymentMethod;

  CardModel? get selectedPaymentMethod => _selectedPaymentMethod;

  set selectedPaymentMethod(CardModel? card) {
    _selectedPaymentMethod = card;
    notifyListeners();
  }

  // Método opcional para inicializar con la tarjeta por defecto
  void initializeDefaultPayment(List<CardModel> cards) {
    if (_selectedPaymentMethod == null && cards.isNotEmpty) {
      _selectedPaymentMethod = cards.first;
      // No llamamos a notifyListeners aquí si se usa durante el build
    }
  }


  // Verificar si un plato es favorito
  bool isFavorite(Food food) {
    return _favorites.any((item) => item.name == food.name);
  }

  // Alternar favorito (Añadir/Quitar)
  void toggleFavorite(Food food) {
    if (isFavorite(food)) {
      _favorites.removeWhere((item) => item.name == food.name);
    } else {
      _favorites.add(food);
    }
    saveFavoritesToLocale(); // Persistencia
    notifyListeners();
  }

  // --- PERSISTENCIA PARA FAVORITOS ---
  Future<void> saveFavoritesToLocale() async {
    final prefs = await SharedPreferences.getInstance();
    String jsonFavs = jsonEncode(_favorites.map((food) => food.toMap()).toList());
    await prefs.setString('user_favorites', jsonFavs);
  }

  Future<void> loadFavoritesFromLocale() async {
    final prefs = await SharedPreferences.getInstance();
    String? jsonFavs = prefs.getString('user_favorites');
    if (jsonFavs != null) {
      List<dynamic> decodedData = jsonDecode(jsonFavs);
      _favorites = decodedData.map((item) => Food.fromJson(item)).toList();
      notifyListeners();
    }
  }


}

// Clase de apoyo para representar un elemento en el carrito
class CartItem {
  Food food;
  List<Addon> selectedAddons;
  int quantity;

  CartItem({
    required this.food,
    required this.selectedAddons,
    this.quantity = 1,
  });

  // Convertir objeto a Mapa para JSON
  Map<String, dynamic> toMap() {
    return {
      'food': food.toMap(), // Asume que tu clase Food también tiene toMap
      'selectedAddons': selectedAddons.map((x) => x.toJson()).toList(),
      'quantity': quantity,
    };
  }

  // Crear objeto desde un Mapa de JSON
  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      food: Food.fromJson(map['food']),
      selectedAddons: List<Addon>.from(map['selectedAddons']?.map((x) => Addon.fromJson(x))),
      quantity: map['quantity'],
    );
  }
}

