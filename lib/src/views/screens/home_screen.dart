import 'package:flutter/material.dart';
import 'package:intec_restaurant/src/views/screens/tab_screens/cart_screen.dart';
import 'package:intec_restaurant/src/views/screens/tab_screens/explore_screen.dart';
import 'package:intec_restaurant/src/views/screens/tab_screens/favorite_screen.dart';
import 'package:intec_restaurant/src/views/screens/tab_screens/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //vamos a crear una lista con las pantallas que queremos
  //para navegar
  final List<Widget> _pages = [
    ExploreScreen(),
    CartScreen(),
    FavoriteScreen(),
    ProfileScreen(),
  ];

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        elevation: 0,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "EXPLORE"),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: "CART",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: "FAVORITES",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "PROFILE"),
        ],
        onTap: (value) {
          setState(() {
            _currentIndex = value;
          });
        },
      ),
      body: _pages[_currentIndex],
    );
  }
}
