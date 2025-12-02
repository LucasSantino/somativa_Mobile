import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../_core/widgets/custom_appbar.dart';
import '../_core/widgets/custom_bottom_nav.dart';
import '../_core/constants/app_colors.dart';
import '../_core/providers/cart_provider.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> cardapioItems = [
      {
        "nome": "Hambúrguer Artesanal",
        "descricao": "Pão brioche, carne 180g e queijo cheddar.",
        "preco": 24.90,
        "icone": Icons.lunch_dining,
      },
      {
        "nome": "Pizza Calabresa",
        "descricao": "Molho especial, queijo e calabresa premium.",
        "preco": 39.90,
        "icone": Icons.local_pizza,
      },
      {
        "nome": "Suco Natural",
        "descricao": "Laranja, limão ou abacaxi.",
        "preco": 8.00,
        "icone": Icons.local_drink,
      },
      {
        "nome": "Açaí 500ml",
        "descricao": "Acompanhado de granola e banana.",
        "preco": 17.00,
        "icone": Icons.icecream,
      },
    ];

    return WillPopScope(
      onWillPop: () async {
        // Impede que o usuário volte para a tela de login
        return false;
      },
      child: Scaffold(
        // AppBar sem botão de voltar
        appBar: const CustomAppBar(title: "Cardápio", canGoBack: false),

        // Bottom navigation
        bottomNavigationBar: const CustomBottomNav(currentIndex: 0),

        body: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView.builder(
            itemCount: cardapioItems.length,
            itemBuilder: (context, index) {
              final item = cardapioItems[index];

              return Card(
                color: const Color.fromARGB(75, 15, 15, 15),
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: AppColors.primary),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(item["icone"], color: AppColors.primary, size: 35),
                      const SizedBox(width: 20),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item["nome"],
                              style: const TextStyle(
                                fontSize: 18,
                                color: AppColors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 6),

                            Text(
                              item["descricao"],
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.white.withOpacity(0.7),
                              ),
                            ),

                            const SizedBox(height: 8),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "R\$ ${item["preco"].toStringAsFixed(2)}",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),

                                ElevatedButton.icon(
                                  onPressed: () {
                                    final cart = Provider.of<CartProvider>(
                                      context,
                                      listen: false,
                                    );

                                    cart.addItem({
                                      "nome": item["nome"],
                                      "preco": item["preco"],
                                      "quantidade": 1,
                                    });

                                    Navigator.pushNamed(context, "/carrinho");
                                  },
                                  icon: Icon(
                                    Icons.add,
                                    color: AppColors.backgroundDark,
                                  ),
                                  label: Text(
                                    "Pedir",
                                    style: TextStyle(
                                      color: AppColors.backgroundDark,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.yellow,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
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
            },
          ),
        ),
      ),
    );
  }
}
