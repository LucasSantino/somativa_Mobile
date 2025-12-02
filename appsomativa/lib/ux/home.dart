import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../_core/widgets/custom_appbar.dart';
import '../_core/widgets/custom_bottom_nav.dart';
import '../_core/constants/app_colors.dart';
import '../_core/providers/cart_provider.dart';
import '../services/api_service.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Map<String, dynamic>> produtos = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadProdutos();
  }

  Future<void> _loadProdutos() async {
    try {
      final produtosData = await ApiService.listarProdutos();
      
      // Converter os produtos para garantir tipos corretos
      final convertedProdutos = produtosData.map((produto) {
        return {
          'id': (produto['id'] is num) ? (produto['id'] as num).toInt() : 0,
          'nome': produto['nome']?.toString() ?? 'Produto',
          'descricao': produto['descricao']?.toString() ?? 'Descrição não disponível',
          'preco': (produto['preco'] is num) ? (produto['preco'] as num).toDouble() : 0.0,
        };
      }).toList();
      
      setState(() {
        produtos = convertedProdutos;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Erro ao carregar produtos: $e';
        _isLoading = false;
      });
    }
  }

  // Função para obter ícone baseado no nome do produto
  IconData _getIconForProduct(String nome) {
    final nomeLower = nome.toLowerCase();
    if (nomeLower.contains('hambúrguer') || nomeLower.contains('burger')) {
      return Icons.lunch_dining;
    } else if (nomeLower.contains('pizza')) {
      return Icons.local_pizza;
    } else if (nomeLower.contains('suco') || nomeLower.contains('bebida')) {
      return Icons.local_drink;
    } else if (nomeLower.contains('açaí') || nomeLower.contains('sobremesa')) {
      return Icons.icecream;
    } else if (nomeLower.contains('frango') || nomeLower.contains('carne')) {
      return Icons.restaurant;
    } else {
      return Icons.fastfood;
    }
  }

  void _adicionarAoCarrinho(BuildContext context, Map<String, dynamic> produto) {
    final cart = Provider.of<CartProvider>(context, listen: false);
    
    // Garantir tipos corretos
    final produtoConvertido = {
      'id': produto['id'],
      'nome': produto['nome'] as String,
      'preco': produto['preco'] as double,
    };
    
    cart.addItem(produtoConvertido);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${produto['nome']} adicionado ao carrinho!'),
        duration: const Duration(seconds: 2),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: const CustomAppBar(title: "Cardápio", canGoBack: false),
        bottomNavigationBar: const CustomBottomNav(currentIndex: 0),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                )
              : _errorMessage.isNotEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _errorMessage,
                            style: const TextStyle(
                              color: AppColors.white,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: _loadProdutos,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                            ),
                            child: const Text(
                              "Tentar novamente",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    )
                  : produtos.isEmpty
                      ? const Center(
                          child: Text(
                            "Nenhum produto disponível",
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 18,
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: produtos.length + 1,
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 20),
                                child: Text(
                                  "Bem-vindo(a) ao MangeEats!",
                                  style: const TextStyle(
                                    color: AppColors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              );
                            }

                            final produto = produtos[index - 1];
                            final nome = produto['nome'] as String;
                            final descricao = produto['descricao'] as String;
                            final preco = produto['preco'] as double;

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
                                    Icon(
                                      _getIconForProduct(nome),
                                      color: AppColors.primary,
                                      size: 35,
                                    ),
                                    const SizedBox(width: 20),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            nome,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              color: AppColors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            descricao,
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: AppColors.white.withOpacity(0.7),
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "R\$ ${preco.toStringAsFixed(2)}",
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  color: AppColors.primary,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              ElevatedButton.icon(
                                                onPressed: () =>
                                                    _adicionarAoCarrinho(context, produto),
                                                icon: Icon(
                                                  Icons.add,
                                                  color: AppColors.backgroundDark,
                                                ),
                                                label: const Text(
                                                  "Pedir",
                                                  style: TextStyle(
                                                    color: AppColors.backgroundDark,
                                                  ),
                                                ),
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: AppColors.yellow,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(12),
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