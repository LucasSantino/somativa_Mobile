import 'package:flutter/material.dart';
import '../_core/widgets/custom_appbar.dart';
import '../_core/constants/app_colors.dart';

class Cardapio extends StatelessWidget {
  const Cardapio({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> cardapioItems = [
      {
        "nome": "Hambúrguer Artesanal",
        "descricao": "Pão brioche, carne 180g e queijo cheddar.",
        "preco": "R\$ 24,90",
        "icone": Icons.lunch_dining
      },
      {
        "nome": "Pizza Calabresa",
        "descricao": "Molho especial, queijo e calabresa premium.",
        "preco": "R\$ 39,90",
        "icone": Icons.local_pizza
      },
      {
        "nome": "Suco Natural",
        "descricao": "Laranja, limão ou abacaxi.",
        "preco": "R\$ 8,00",
        "icone": Icons.local_drink
      },
      {
        "nome": "Açaí 500ml",
        "descricao": "Acompanhado de granola e banana.",
        "preco": "R\$ 17,00",
        "icone": Icons.icecream
      },
    ];

    return Scaffold(
      appBar: const CustomAppBar(title: "Cardápio"),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView.builder(
          itemCount: cardapioItems.length,
          itemBuilder: (context, index) {
            final item = cardapioItems[index];

            return Card(
              color: AppColors.backgroundDark,
              margin: const EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(color: AppColors.primary),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(
                      item["icone"],
                      color: AppColors.primary,
                      size: 35,
                    ),
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
                          Text(
                            item["preco"],
                            style: const TextStyle(
                              fontSize: 16,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
