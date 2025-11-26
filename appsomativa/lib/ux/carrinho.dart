import 'package:flutter/material.dart';
import '../_core/widgets/custom_appbar.dart';
import '../_core/constants/app_colors.dart';

class Carrinho extends StatefulWidget {
  const Carrinho({super.key});

  @override
  State<Carrinho> createState() => _CarrinhoState();
}

class _CarrinhoState extends State<Carrinho> {
  final TextEditingController cepController = TextEditingController();

  // Dados mockados por enquanto
  List<Map<String, dynamic>> itens = [
    {"nome": "Hambúrguer Artesanal", "quantidade": 1, "preco": 25.00},
    {"nome": "Pizza Calabresa", "quantidade": 2, "preco": 40.00},
  ];

  double get total {
    double valor = 0;
    for (var item in itens) {
      valor += item["preco"] * item["quantidade"];
    }
    return valor;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Carrinho"),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: itens.length,
                itemBuilder: (context, index) {
                  final item = itens[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundDark,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.primary),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Nome
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

                        // Quantidade
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline,
                                  color: AppColors.primary),
                              onPressed: () {
                                setState(() {
                                  if (item["quantidade"] > 1) {
                                    item["quantidade"]--;
                                  }
                                });
                              },
                            ),
                            Text(
                              "${item["quantidade"]}",
                              style: const TextStyle(
                                  color: AppColors.white, fontSize: 16),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add_circle_outline,
                                  color: AppColors.primary),
                              onPressed: () {
                                setState(() {
                                  item["quantidade"]++;
                                });
                              },
                            ),
                          ],
                        ),

                        // Subtotal
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

            const SizedBox(height: 20),

            // Campo para CEP
            TextField(
              controller: cepController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: AppColors.white),
              decoration: InputDecoration(
                labelText: "Digite seu CEP",
                labelStyle: const TextStyle(color: AppColors.white),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: AppColors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: AppColors.primary),
                ),
              ),
            ),

            const SizedBox(height: 25),

            // Total
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Total:",
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 20,
                  ),
                ),
                Text(
                  "R\$ ${total.toStringAsFixed(2)}",
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // Botão confirmar
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, "/confirmacao");
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
            )
          ],
        ),
      ),
    );
  }
}
