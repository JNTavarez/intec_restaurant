import 'package:flutter/material.dart';

import '../../../models/card_model.dart';

class MyCreditCard extends StatelessWidget {
  final CardModel card;
  final bool isSelected;
  final VoidCallback onTap;

  const MyCreditCard({
    super.key,
    required this.card,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        width: double.infinity,
        height: 200,
        decoration: BoxDecoration(
          // Degradado premium (puedes cambiar los colores según la marca)
          gradient: LinearGradient(
            colors: isSelected
                ? [Colors.deepPurple.shade400, Colors.blue.shade700]
                : [Colors.grey.shade800, Colors.grey.shade900],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: isSelected ? Colors.blue.withOpacity(0.3) : Colors.black26,
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
          border: Border.all(
            color: Colors.white.withOpacity(0.2), // El toque de "cristal"
            width: 1,
          ),
        ),
        child: Stack(
          children: [
            // Círculos decorativos de fondo (opcional para estilo)
            Positioned(
              right: -20,
              bottom: -20,
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Colors.white.withAlpha(5),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Logo y Chip
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(Icons.credit_card, color: Colors.white70, size: 30),
                      Text(
                        card.brand.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),

                  // Número de Tarjeta
                  Text(
                    "**** **** **** ${card.lastFour}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      letterSpacing: 4,
                      fontFamily: 'monospace', // Estilo de fuente de tarjeta
                    ),
                  ),

                  // Nombre y Expiración
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("TITULAR", style: TextStyle(color: Colors.white54, fontSize: 10)),
                          Text(card.cardHolder.toUpperCase(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("EXP", style: TextStyle(color: Colors.white54, fontSize: 10)),
                          Text(card.expiryDate, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      // Check de selección
                      if (isSelected)
                        const CircleAvatar(
                          radius: 12,
                          backgroundColor: Colors.white,
                          child: Icon(Icons.check, size: 16, color: Colors.blue),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}