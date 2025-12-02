import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../_core/constants/app_colors.dart';
import '../_core/widgets/custom_appbar.dart';
import '../_core/widgets/custom_bottom_nav.dart';
import '../_core/providers/cart_provider.dart';

class Confirmacao extends StatefulWidget {
  const Confirmacao({super.key});

  @override
  State<Confirmacao> createState() => _ConfirmacaoState();
}

class _ConfirmacaoState extends State<Confirmacao> {
  bool _isFinalizing = false;

  Future<void> _finalizarPedido(BuildContext context) async {
    final cart = Provider.of<CartProvider>(context, listen: false);
    
    // Log para debug
    print('📝 DETALHES ANTES DE FINALIZAR:');
    print('📝 User ID: ${cart.userId}');
    print('📝 Pedido ID: ${cart.currentOrderId}');
    print('📝 Total de itens: ${cart.items.length}');
    print('📝 Endereço: ${cart.endereco}');
    
    setState(() => _isFinalizing = true);

    try {
      // 1. Finalizar pedido no backend
      print('🔄 Iniciando finalização do pedido...');
      final finalizarResult = await cart.finalizarPedidoNoBackend();
      
      print('📊 RESULTADO FINALIZAR: $finalizarResult');
      
      if (finalizarResult.containsKey('error')) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Erro ao finalizar pedido:"),
                const SizedBox(height: 4),
                Text(
                  finalizarResult['error'].toString(),
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
            duration: const Duration(seconds: 5),
          ),
        );
        setState(() => _isFinalizing = false);
        return;
      }

      // 2. Mostrar mensagem de sucesso
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "✅ Pedido confirmado com sucesso!",
            style: TextStyle(fontSize: 16),
          ),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );

      // 3. Limpar carrinho e navegar para home
      await Future.delayed(const Duration(seconds: 2));
      
      print('🔄 Limpando carrinho e navegando para home...');
      cart.clearCart();
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/home',
        (route) => false,
      );
      
    } catch (e) {
      print('🔴 ERRO CAPTURADO: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Erro ao finalizar pedido:"),
              const SizedBox(height: 4),
              Text(
                e.toString(),
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
          duration: const Duration(seconds: 5),
        ),
      );
      setState(() => _isFinalizing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: const CustomAppBar(title: "Confirmação"),
      body: _isFinalizing
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(
                  color: AppColors.primary,
                ),
                const SizedBox(height: 20),
                Text(
                  "Finalizando pedido...",
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    "Pedido #${cart.currentOrderId ?? '?'}",
                    style: TextStyle(
                      color: AppColors.white.withOpacity(0.7),
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            )
          : Padding(
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
                    child: cart.isEmpty
                        ? const Center(
                            child: Text(
                              "Carrinho vazio",
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: 18,
                              ),
                            ),
                          )
                        : ListView.builder(
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
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          "R\$ ${(item["preco"] as num).toStringAsFixed(2)} un.",
                                          style: TextStyle(
                                            color: AppColors.white.withOpacity(0.7),
                                            fontSize: 14,
                                          ),
                                        ),
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
                                  ],
                                ),
                              );
                            },
                          ),
                  ),
                  
                  // Informações de depuração
                  if (cart.currentOrderId != null) ...[
                    const SizedBox(height: 15),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "📋 Informações do Pedido:",
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "Número do Pedido: ${cart.currentOrderId}",
                            style: const TextStyle(color: Colors.white70),
                          ),
                          Text(
                            "Usuário ID: ${cart.userId ?? 'Não definido'}",
                            style: const TextStyle(color: Colors.white70),
                          ),
                          Text(
                            "Total de Itens: ${cart.totalItems}",
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                  ],
                  
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
                          ? "⚠️ Endereço não informado"
                          : cart.endereco,
                      style: const TextStyle(color: AppColors.white),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Column(
                    children: [
                      _resumoLinha("Subtotal:", cart.subtotal),
                      _resumoLinha("Taxa de Entrega:", cart.taxaEntrega),
                      const SizedBox(height: 10),
                      _resumoLinha("Total Final:", cart.totalFinal, destaque: true),
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
                      onPressed: cart.isEmpty || cart.endereco.isEmpty
                          ? null
                          : () => _finalizarPedido(context),
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
      bottomNavigationBar: const CustomBottomNav(currentIndex: 1),
    );
  }

  Widget _resumoLinha(String titulo, double valor, {bool destaque = false}) {
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