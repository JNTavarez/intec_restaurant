import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/parse_food_model.dart';
import '../../models/restaurant.dart';

class FoodDetailScreen extends StatefulWidget {
  final Food food;

  const FoodDetailScreen({super.key, required this.food});

  @override
  State<FoodDetailScreen> createState() => _FoodDetailScreenState();
}

class _FoodDetailScreenState extends State<FoodDetailScreen> {
  // Mapa para controlar qué addons están seleccionados
  final Map<Addon, bool> selectedAddons = {};

  @override
  void initState() {
    super.initState();
    // Inicializamos todos los addons como no seleccionados
    for (var addon in widget.food.availableAddons) {
      selectedAddons[addon] = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final restaurant = Provider.of<Restaurant>(context);
    final isFavorite = restaurant.isFavorite(widget.food);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.food.name),
        actions: [
          IconButton(
            onPressed: () {
              final wasFavorite = isFavorite;
              restaurant.toggleFavorite(widget.food);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    wasFavorite
                        ? "${widget.food.name} eliminado de favoritos"
                        : "${widget.food.name} añadido a favoritos",
                  ),
                ),
              );
            },
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : null,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Imagen del producto
          Image.asset(
            widget.food.imagePath,
            //height: 200,
            fit: BoxFit.cover,
          ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.food.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "\$${widget.food.price}",
                  style: TextStyle(fontSize: 20, color: Colors.grey[700]),
                ),
                const SizedBox(height: 10),
                Text(widget.food.description),
                const SizedBox(height: 20),
                const Text(
                  "Add-ons",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          // Lista de Addons
          Expanded(
            child: ListView.builder(
              itemCount: widget.food.availableAddons.length,
              itemBuilder: (context, index) {
                Addon addon = widget.food.availableAddons[index];
                return CheckboxListTile(
                  title: Text(addon.name),
                  subtitle: Text("+\$${addon.price}"),
                  value: selectedAddons[addon],
                  onChanged: (bool? value) {
                    setState(() {
                      selectedAddons[addon] = value!;
                    });
                  },
                );
              },
            ),
          ),

          // Botón de añadir al carrito
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              ),
              onPressed: () {
                // Aquí iría la lógica para guardar en el carrito
                // Obtener los addons seleccionados del mapa
                List<Addon> currentlySelectedAddons = [];
                selectedAddons.forEach((addon, isSelected) {
                  if (isSelected) {
                    currentlySelectedAddons.add(addon);
                  }
                });

                // Acceder al provider y añadir
                context.read<Restaurant>().addToCart(
                  widget.food,
                  currentlySelectedAddons,
                );

                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("${widget.food.name} añadido al carrito"),
                  ),
                );
              },
              child: Text(
                "Añadir al carrito",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
