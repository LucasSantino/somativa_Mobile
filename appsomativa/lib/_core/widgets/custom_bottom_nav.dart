import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../providers/cart_provider.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;

  const CustomBottomNav({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    int cartCount = 0;

    try {
      cartCount = context.watch<CartProvider>().items.length;
    } catch (_) {
      cartCount = 0;
    }

    return BottomNavigationBar(
      currentIndex: currentIndex,
      backgroundColor: AppColors.backgroundDark,
      elevation: 10,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.white,
      type: BottomNavigationBarType.fixed,
      showUnselectedLabels: true,

      onTap: (index) {
        if (index == 0) {
          Navigator.pushNamed(context, "/home");
        } else if (index == 1) {
          Navigator.pushNamed(context, "/carrinho");
        }
      },

      items: [
        const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),

        BottomNavigationBarItem(
          icon: Stack(
            children: [
              const Icon(
                Icons.shopping_cart,
                color: Colors.amber, // ÍCONE DO CARRINHO AMARELO
              ),

              if (cartCount > 0)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.amber,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      cartCount.toString(),
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          label: 'Carrinho',
        ),
      ],
    );
  }
}
