import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../_core/widgets/custom_appbar.dart';
import '../_core/widgets/custom_bottom_nav.dart';
import '../_core/constants/app_colors.dart';
import '../_core/providers/cart_provider.dart';

class Carrinho extends StatefulWidget {
  const Carrinho({super.key});

  @override
  State<Carrinho> createState() => _CarrinhoState();
}

class _CarrinhoState extends State<Carrinho> {
  final TextEditingController cepController = TextEditingController();

  Future<void> buscarCep(BuildContext context) async {
    String cep = cepController.text.trim().replaceAll("-", "");

    if (cep.length != 8) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("CEP inválido!")));
      return;
    }

    final url = Uri.parse("https://viacep.com.br/ws/$cep/json/");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data.containsKey("erro")) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text("CEP não encontrado")));
          return;
        }

        String endereco =
            "${data["logradouro"]}, ${data["bairro"]} - ${data["localidade"]}/${data["uf"]}";

        final cart = Provider.of<CartProvider>(context, listen: false);
        cart.setEndereco(endereco);
        cart.calcularTaxaEntrega();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Endereço encontrado com sucesso!")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Erro ao buscar o CEP")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: const CustomAppBar(title: "Carrinho"),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: cart.items.length,
                itemBuilder: (context, index) {
                  final item = cart.items[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundDark,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.primary),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Nome do item
                        Expanded(
                          child: Text(
                            item["nome"],
                            style: const TextStyle(
                              color: AppColors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          children: [
                            // Controles de quantidade
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.remove_circle_outline,
                                    color: AppColors.primary,
                                  ),
                                  onPressed: () {
                                    cart.decreaseQuantity(index);
                                  },
                                ),
                                Text(
                                  "${item["quantidade"]}",
                                  style: const TextStyle(
                                    color: AppColors.white,
                                    fontSize: 16,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.add_circle_outline,
                                    color: AppColors.primary,
                                  ),
                                  onPressed: () {
                                    cart.increaseQuantity(index);
                                  },
                                ),
                              ],
                            ),
                            // Preço embaixo
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
                        const SizedBox(width: 10),
                        // Botão remover
                        IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.redAccent,
                          ),
                          onPressed: () {
                            cart.removeItem(index);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "${item["nome"]} removido do carrinho",
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            // Campo CEP
            TextField(
              controller: cepController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: AppColors.white),
              decoration: InputDecoration(
                labelText: "Digite seu CEP",
                labelStyle: const TextStyle(color: AppColors.white),
                suffixIcon: IconButton(
                  onPressed: () => buscarCep(context),
                  icon: const Icon(Icons.search, color: AppColors.primary),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.white),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.primary),
                ),
              ),
            ),
            if (cart.endereco.isNotEmpty) ...[
              const SizedBox(height: 20),
              Text(
                "Endereço: ${cart.endereco}",
                style: const TextStyle(color: AppColors.white, fontSize: 16),
              ),
              const SizedBox(height: 10),
              Text(
                cart.taxaEntrega == 0
                    ? "Entrega gratuita!"
                    : "Taxa de entrega: R\$ ${cart.taxaEntrega}",
                style: const TextStyle(color: AppColors.primary, fontSize: 16),
              ),
            ],
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Total:",
                  style: TextStyle(color: AppColors.white, fontSize: 20),
                ),
                Text(
                  "R\$ ${cart.totalFinal.toStringAsFixed(2)}",
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            // Botão confirmar pedido
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/confirmacao');
                },
                child: const Text(
                  "Confirmar Pedido",
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
}
