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
  bool _isProcessing = false;

  Future<void> buscarCep(BuildContext context) async {
    String cep = cepController.text.trim().replaceAll("-", "");

    if (cep.length != 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("CEP inválido!")),
      );
      return;
    }

    setState(() => _isProcessing = true);

    final url = Uri.parse("https://viacep.com.br/ws/$cep/json/");

    try {
      print('📡 Buscando CEP: $cep');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data.containsKey("erro")) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("CEP não encontrado")),
          );
          return;
        }

        String endereco =
            "${data["logradouro"]}, ${data["bairro"]} - ${data["localidade"]}/${data["uf"]}";

        final cart = Provider.of<CartProvider>(context, listen: false);
        cart.setEndereco(endereco);
        cart.calcularTaxaEntrega();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ Endereço encontrado com sucesso!")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erro ao buscar o CEP")),
      );
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  Future<void> _confirmarPedido(BuildContext context) async {
    final cart = Provider.of<CartProvider>(context, listen: false);

    // Validar carrinho
    if (cart.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Carrinho vazio!")),
      );
      return;
    }

    // Validar endereço
    if (cart.endereco.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Por favor, informe o CEP")),
      );
      return;
    }

    setState(() => _isProcessing = true);

    try {
      print('🔄 INICIANDO CONFIRMAÇÃO DE PEDIDO');
      print('📝 User ID: ${cart.userId}');
      print('📝 Total de itens: ${cart.items.length}');
      
      // 1. Criar pedido no backend
      print('1️⃣ Criando pedido no backend...');
      final criarResult = await cart.criarPedidoNoBackend();
      
      if (criarResult.containsKey('error')) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(criarResult['error'])),
        );
        return;
      }

      // 2. Adicionar itens ao pedido
      print('2️⃣ Adicionando itens ao pedido...');
      final adicionarResult = await cart.adicionarItensAoPedido();
      
      if (adicionarResult.containsKey('error')) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(adicionarResult['error'])),
        );
        return;
      }

      // 3. Navegar para tela de confirmação
      print('✅ Pedido criado e itens adicionados com sucesso!');
      print('📝 Pedido ID: ${cart.currentOrderId}');
      
      Navigator.pushNamed(context, '/confirmacao');
      
    } catch (e) {
      print('🔴 ERRO: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao processar pedido: $e")),
      );
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: const CustomAppBar(title: "Carrinho"),
      body: _isProcessing
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: AppColors.primary,
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Processando...",
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Expanded(
                    child: cart.isEmpty
                        ? const Center(
                            child: Text(
                              "🛒 Carrinho vazio",
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: 20,
                              ),
                            ),
                          )
                        : ListView.builder(
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
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item["nome"] as String,
                                            style: const TextStyle(
                                              color: AppColors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            "R\$ ${(item["preco"] as num).toStringAsFixed(2)} un.",
                                            style: TextStyle(
                                              color: AppColors.white.withOpacity(0.7),
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
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
                                        // Preço total do item
                                        Text(
                                          "R\$ ${((item["preco"] as num) * (item["quantidade"] as num)).toStringAsFixed(2)}",
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
                      "📍 Endereço: ${cart.endereco}",
                      style: const TextStyle(color: AppColors.white, fontSize: 16),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      cart.taxaEntrega == 0
                          ? "🚚 Entrega gratuita!"
                          : "🚚 Taxa de entrega: R\$ ${cart.taxaEntrega.toStringAsFixed(2)}",
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
                      onPressed: cart.isEmpty || cart.endereco.isEmpty
                          ? null
                          : () => _confirmarPedido(context),
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
      bottomNavigationBar: const CustomBottomNav(currentIndex: 1),
    );
  }
}