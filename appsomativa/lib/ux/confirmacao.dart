import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../_core/constants/app_colors.dart';
import '../_core/widgets/custom_appbar.dart';
import '../_core/widgets/custom_bottom_nav.dart';
import '../_core/providers/cart_provider.dart';

class Confirmacao extends StatelessWidget {
  const Confirmacao({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

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
                itemCount: cart.items.length,
                itemBuilder: (context, index) {
                  final item = cart.items[index];
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
                        ),
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
              child: Text(
                cart.endereco.isEmpty
                    ? "Endereço não informado"
                    : cart.endereco,
                style: const TextStyle(color: AppColors.white),
              ),
            ),
            const SizedBox(height: 20),
            Column(
              children: [
                resumoLinha("Subtotal:", cart.subtotal),
                resumoLinha("Taxa de Entrega:", cart.taxaEntrega),
                const SizedBox(height: 10),
                resumoLinha("Total Final:", cart.totalFinal, destaque: true),
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
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Pedido confirmado com sucesso!",
                        style: TextStyle(fontSize: 16),
                      ),
                      backgroundColor: Colors.green,
                      duration: Duration(seconds: 2),
                    ),
                  );

                  Future.delayed(const Duration(seconds: 2), () {
                    cart.clearCart();
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/home',
                      (route) => false,
                    );
                  });
                },
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
      bottomNavigationBar: const CustomBottomNav(
        currentIndex: 1,
      ), // ← ADICIONADO
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
