import 'package:flutter/material.dart';
import '../_core/constants/app_colors.dart';
import '../_core/widgets/custom_appbar.dart';

class Confirmacao extends StatelessWidget {
  const Confirmacao({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> itens = [
      {"nome": "Hambúrguer Artesanal", "quantidade": 1, "preco": 25.00},
      {"nome": "Pizza Calabresa", "quantidade": 2, "preco": 40.00},
    ];

    double subtotal = 0;
    for (var item in itens) {
      subtotal += item["preco"] * item["quantidade"];
    }

    double taxaEntrega = 7.50;
    double totalFinal = subtotal + taxaEntrega;

    return Scaffold(
      appBar: const CustomAppBar(title: "Confirmação"),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Itens do Pedido",
              style: TextStyle(
                color: AppColors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            Expanded(
              child: ListView.builder(
                itemCount: itens.length,
                itemBuilder: (context, index) {
                  final item = itens[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundDark,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.primary),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item["nome"],
                              style: const TextStyle(
                                color: AppColors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Quantidade: ${item["quantidade"]}",
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          "R\$ ${(item["preco"] * item["quantidade"]).toStringAsFixed(2)}",
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 15),

            const Text(
              "Endereço de Entrega",
              style: TextStyle(
                color: AppColors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: AppColors.backgroundDark,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.primary),
              ),
              child: const Text(
                "Rua Exemplo, 123\nBairro Centro - São Paulo/SP\nCEP: 00000-000",
                style: TextStyle(color: AppColors.white),
              ),
            ),

            const SizedBox(height: 20),

            Column(
              children: [
                resumoLinha("Subtotal:", subtotal),
                resumoLinha("Taxa de Entrega:", taxaEntrega),
                const SizedBox(height: 10),
                resumoLinha("Total Final:", totalFinal, destaque: true),
              ],
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {},
                child: const Text(
                  "Finalizar Pedido",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget resumoLinha(String titulo, double valor, {bool destaque = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            titulo,
            style: TextStyle(
              color: AppColors.white,
              fontSize: destaque ? 20 : 16,
              fontWeight: destaque ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            "R\$ ${valor.toStringAsFixed(2)}",
            style: TextStyle(
              color: destaque ? AppColors.primary : AppColors.white,
              fontSize: destaque ? 22 : 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
