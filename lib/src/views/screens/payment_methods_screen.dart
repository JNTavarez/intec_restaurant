import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intec_restaurant/src/views/screens/tab_screens/cart_screen.dart';
import 'package:provider/provider.dart';

import '../../models/card_model.dart';
import '../../models/restaurant.dart';
import 'components/my_credit_card.dart';

class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  String? selectedCardId;

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    return Consumer<Restaurant>(
      builder: (BuildContext context, Restaurant restaurant, Widget? child) {
        return Scaffold(
          appBar: AppBar(title: const Text("Métodos de Pago")),
          body: Column(
            children: [
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(userId)
                      .collection('cards')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final cards = snapshot.data!.docs
                        .map(
                          (doc) => CardModel.fromFirestore(
                            doc.data() as Map<String, dynamic>,
                            doc.id,
                          ),
                        )
                        .toList();

                    if (cards.isEmpty) {
                      return const Center(
                        child: Text("No tienes tarjetas registradas."),
                      );
                    }

                    return ListView.builder(
                      itemCount: cards.length,
                      itemBuilder: (context, index) {
                        //final card = cards[index];
                        // return RadioListTile<String>(
                        //   value: card.id,
                        //   groupValue: restaurant.selectedPaymentMethod?.id,
                        //   // Leemos del provider
                        //   onChanged: (value) {
                        //     // Actualizamos el provider
                        //     restaurant.selectedPaymentMethod = card;
                        //
                        //     // Si venimos del carrito, quizás queramos cerrar al seleccionar
                        //     // Navigator.pop(context);
                        //   },
                        //   title: Text("**** **** **** ${card.lastFour}"),
                        //   // ... resto del diseño
                        // );
                        final card = cards[index];
                        final isSelected =
                            restaurant.selectedPaymentMethod?.id == card.id;

                        return MyCreditCard(
                          card: card,
                          isSelected: isSelected,
                          onTap: () {
                            restaurant.selectedPaymentMethod = card;
                          },
                        );
                      },
                    );
                  },
                ),
              ),

              // BOTÓN AÑADIR NUEVA TARJETA
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: ElevatedButton.icon(
                  onPressed: () => _showAddCardSheet(context),
                  icon: const Icon(Icons.add),
                  label: const Text("Añadir Nueva Tarjeta"),
                ),
              ),
            ],
          ),
          bottomNavigationBar: _buildPayButton(),
        );
      },
    );
  }

  Widget _buildPayButton() {
    final restaurant = context.read<Restaurant>();
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: MaterialButton(
        onPressed: restaurant.selectedPaymentMethod == null
            ? null // Botón deshabilitado si no hay tarjeta
            : () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CartScreen()),
                );
              },
        color: restaurant.selectedPaymentMethod == null
            ? Colors.grey
            : Colors.orange,
        child: Text(
          restaurant.selectedPaymentMethod == null
              ? "FALTA MÉTODO DE PAGO"
              : "SELECCIONAR TARJETA",
        ),
      ),
    );
  }

  void _showAddCardSheet(BuildContext context) {
    final cardController = TextEditingController();
    final nameController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 20,
          right: 20,
          top: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Nueva Tarjeta",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Nombre en la tarjeta",
              ),
            ),
            TextField(
              controller: cardController,
              decoration: const InputDecoration(
                labelText: "Número de tarjeta",
                hintText: "1234 5678 9876 5432",
              ),
              keyboardType: TextInputType.number,
              maxLength: 16,
            ),
            ElevatedButton(
              onPressed: () async {
                final userId = FirebaseAuth.instance.currentUser?.uid;
                final lastFour = cardController.text.substring(
                  cardController.text.length - 4,
                );

                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(userId)
                    .collection('cards')
                    .add({
                      'cardHolder': nameController.text,
                      'lastFour': lastFour,
                      'expiryDate': '12/28', // Simulado
                      'brand': 'Visa', // Simulado
                    });

                Navigator.pop(context);
              },
              child: const Text("Guardar Tarjeta"),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  //eliminar una tarjeta
  Future<void> deleteCard(String cardId) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('cards')
        .doc(cardId)
        .delete();
  }
}
