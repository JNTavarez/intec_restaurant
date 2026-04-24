import 'package:flutter/material.dart';
import 'package:intec_restaurant/src/views/screens/delivery_progress_screen.dart';
import 'package:provider/provider.dart';

import '../../../models/restaurant.dart';
import '../components/my_quantity_selector.dart';
import '../payment_methods_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<Restaurant>(
      builder: (context, restaurant, child) {
        final userCart = restaurant.cart;

        return Scaffold(
          appBar: AppBar(
            title: const Text("Carrito"),
            backgroundColor: Colors.transparent,
            foregroundColor: Theme.of(context).colorScheme.inversePrimary,
          ),
          body: Column(
            children: [
              // Lista de artículos del carrito
              Expanded(
                child: userCart.isEmpty
                    ? const Center(child: Text("Tu carrito está vacío..."))
                    : ListView.builder(
                        itemCount: userCart.length,
                        itemBuilder: (context, index) {
                          final cartItem = userCart[index];

                          return Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.secondary,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            margin: const EdgeInsets.symmetric(
                              horizontal: 25,
                              vertical: 10,
                            ),
                            child: ListTile(
                              title: Text(cartItem.food.name),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("\$${cartItem.food.price}"),
                                  // Mostrar los addons seleccionados
                                  Wrap(
                                    children: cartItem.selectedAddons
                                        .map(
                                          (addon) => Padding(
                                            padding: const EdgeInsets.only(
                                              right: 8.0,
                                            ),
                                            child: FilterChip(
                                              label: Text(
                                                "${addon.name} (\$${addon.price})",
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                ),
                                              ),
                                              onSelected: (value) {},
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  ),
                                ],
                              ),
                              trailing: MyQuantitySelector(
                                quantity: cartItem.quantity,
                                food: cartItem.food,
                                onIncrement: () => restaurant.addToCart(
                                  cartItem.food,
                                  cartItem.selectedAddons,
                                ),
                                onDecrement: () =>
                                    restaurant.removeFromCart(cartItem),
                              ),
                            ),
                          );
                        },
                      ),
              ),

              // Resumen del pago (Ticket)
              Container(
                padding: const EdgeInsets.all(25),
                child: Column(
                  children: [
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Total pedido:",
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          "\$${restaurant.getTotalPrice().toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    Consumer<Restaurant>(
                      builder: (context, restaurant, child) {
                        final selectedBadge = restaurant.selectedPaymentMethod;

                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 25,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.secondary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          margin: const EdgeInsets.symmetric(horizontal: 25),
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: const Icon(Icons.credit_card),
                            title: Text(
                              selectedBadge != null
                                  ? "**** **** **** ${selectedBadge.lastFour}"
                                  : "Seleccionar pago",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              selectedBadge?.brand ??
                                  "No hay tarjeta seleccionada",
                            ),
                            trailing: const Icon(Icons.edit, size: 20),
                            onTap: () {
                              // Navegamos a la pantalla que creamos antes
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (c) => const PaymentMethodsScreen(),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),

                    SizedBox(height: 20),
                    MaterialButton(
                      onPressed: restaurant.selectedPaymentMethod == null
                          ? null // Botón deshabilitado si no hay tarjeta
                          : () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return DeliveryProgressScreen();
                                  },
                                ),
                              );
                              restaurant.clearCart();
                            },
                      color: restaurant.selectedPaymentMethod == null
                          ? Colors.grey
                          : Colors.orange,
                      child: Text(
                        restaurant.selectedPaymentMethod == null
                            ? "FALTA MÉTODO DE PAGO"
                            : "PAGAR AHORA",
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// class DeliveryProgressPage {
//   const DeliveryProgressPage();
// }
