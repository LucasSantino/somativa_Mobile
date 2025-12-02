import 'package:flutter/material.dart';
import '../../services/api_service.dart';

class CartProvider extends ChangeNotifier {
  final List<Map<String, dynamic>> _items = [];
  String _endereco = "";
  double _taxaEntrega = 0;
  int? _userId;
  int? _currentOrderId;

  List<Map<String, dynamic>> get items => _items;
  String get endereco => _endereco;
  double get taxaEntrega => _taxaEntrega;
  int? get userId => _userId;
  int? get currentOrderId => _currentOrderId;

  void setUserId(int userId) {
    _userId = userId;
    print('🟢 User ID salvo no CartProvider: $_userId');
    notifyListeners();
  }

  double get subtotal {
    double soma = 0;
    for (var item in _items) {
      final preco = (item["preco"] as num).toDouble();
      final quantidade = (item["quantidade"] as num).toInt();
      soma += preco * quantidade;
    }
    return soma;
  }

  double get totalFinal => subtotal + _taxaEntrega;

  void addItem(Map<String, dynamic> item) {
    final itemId = (item["id"] as num).toInt();
    
    int index = _items.indexWhere((cartItem) {
      final cartItemId = (cartItem["id"] as num).toInt();
      return cartItemId == itemId;
    });
    
    if (index != -1) {
      _items[index]["quantidade"] = (_items[index]["quantidade"] as int) + 1;
    } else {
      _items.add({
        "id": itemId,
        "nome": item["nome"] as String,
        "preco": (item["preco"] as num).toDouble(),
        "quantidade": 1,
      });
    }
    print('📦 Item adicionado: ${item["nome"]}. Total: ${_items.length} itens');
    notifyListeners();
  }

  void increaseQuantity(int index) {
    _items[index]["quantidade"] = (_items[index]["quantidade"] as int) + 1;
    notifyListeners();
  }

  void decreaseQuantity(int index) {
    final quantidade = _items[index]["quantidade"] as int;
    if (quantidade > 1) {
      _items[index]["quantidade"] = quantidade - 1;
    }
    notifyListeners();
  }

  void removeItem(int index) {
    final itemNome = _items[index]["nome"];
    _items.removeAt(index);
    print('🗑️ Item removido: $itemNome');
    notifyListeners();
  }

  void setEndereco(String enderecoCompleto) {
    _endereco = enderecoCompleto;
    notifyListeners();
  }

  void calcularTaxaEntrega() {
    if (subtotal >= 100) {
      _taxaEntrega = 0;
    } else {
      _taxaEntrega = 7.50;
    }
    notifyListeners();
  }

  Future<Map<String, dynamic>> criarPedidoNoBackend() async {
    print('🟡 CRIANDO PEDIDO NO BACKEND');
    print('🟡 User ID: $_userId');
    
    if (_userId == null) {
      print('🔴 ERRO: Usuário não autenticado');
      return {'error': 'Usuário não autenticado'};
    }

    try {
      final response = await ApiService.criarPedido(_userId!);
      print('🟡 RESPOSTA CRIAR PEDIDO: $response');
      
      if (response.containsKey('id')) {
        _currentOrderId = (response['id'] as num).toInt();
        print('🟢 PEDIDO CRIADO COM SUCESSO. ID: $_currentOrderId');
        return {'success': true, 'pedido_id': _currentOrderId};
      } else if (response.containsKey('error')) {
        print('🔴 ERRO AO CRIAR PEDIDO: ${response['error']}');
        return {'error': response['error'].toString()};
      }
      
      print('🔴 RESPOSTA NÃO RECONHECIDA: $response');
      return {'error': 'Resposta não reconhecida: $response'};
    } catch (e) {
      print('🔴 EXCEÇÃO: $e');
      return {'error': 'Erro de conexão: $e'};
    }
  }

  Future<Map<String, dynamic>> adicionarItensAoPedido() async {
    print('🟡 ADICIONANDO ITENS AO PEDIDO');
    print('🟡 Pedido ID: $_currentOrderId');
    print('🟡 Total de itens: ${_items.length}');
    
    if (_currentOrderId == null) {
      print('🔴 ERRO: Pedido não criado');
      return {'error': 'Pedido não criado'};
    }

    try {
      bool allSuccess = true;
      String errorMessage = '';
      
      for (var item in _items) {
        final produtoId = (item["id"] as num).toInt();
        final quantidade = (item["quantidade"] as num).toInt();
        final nome = item["nome"] as String;
        
        print('🟡 Adicionando item: $nome (ID: $produtoId, Qtd: $quantidade)');
        
        final response = await ApiService.adicionarItem(
          _currentOrderId!, 
          produtoId, 
          quantidade
        );
        
        print('🟡 Resposta adicionar item: $response');
        
        if (response.containsKey('error')) {
          allSuccess = false;
          errorMessage = 'Erro ao adicionar $nome: ${response['error']}';
          print('🔴 ERRO: $errorMessage');
          break;
        }
      }
      
      if (allSuccess) {
        print('🟢 TODOS OS ITENS ADICIONADOS COM SUCESSO');
        return {'success': true};
      } else {
        return {'error': errorMessage};
      }
    } catch (e) {
      print('🔴 EXCEÇÃO: $e');
      return {'error': 'Erro de conexão: $e'};
    }
  }

  Future<Map<String, dynamic>> finalizarPedidoNoBackend() async {
    print('🟡 INICIANDO FINALIZAÇÃO DO PEDIDO');
    print('🟡 Pedido ID: $_currentOrderId');
    print('🟡 User ID: $_userId');
    
    if (_currentOrderId == null) {
      print('🔴 ERRO: Pedido não criado');
      return {'error': 'Pedido não criado'};
    }

    try {
      final response = await ApiService.finalizarPedido(_currentOrderId!);
      print('🟡 RESPOSTA BRUTA DA API: $response');
      
      // Verifica várias possibilidades de resposta de sucesso
      if (response.containsKey('success') && response['success'] == true) {
        print('🟢 SUCESSO: Pedido finalizado com sucesso (success: true)');
        return {'success': true};
      } else if (response.containsKey('status')) {
        final status = response['status'].toString().toLowerCase();
        if (status == 'finalizado' || status == 'completed' || status == 'success' || status == 'concluído') {
          print('🟢 SUCESSO: Status do pedido: $status');
          return {'success': true};
        }
      } else if (response.containsKey('message')) {
        final message = response['message'].toString().toLowerCase();
        if (message.contains('sucesso') || 
            message.contains('finalizado') || 
            message.contains('concluído') || 
            message.contains('success')) {
          print('🟢 SUCESSO: $message');
          return {'success': true};
        }
      } else if (response.containsKey('id') || response.containsKey('pedido_id')) {
        print('🟢 SUCESSO: Pedido ID retornado: ${response['id'] ?? response['pedido_id']}');
        return {'success': true};
      } else if (response.isEmpty) {
        // Se a resposta for vazia, consideramos sucesso (status 200 sem corpo)
        print('🟢 SUCESSO: Resposta vazia (status 200)');
        return {'success': true};
      }
      
      // Se chegou aqui, não reconhecemos a resposta como sucesso
      if (response.containsKey('error')) {
        print('🔴 ERRO DA API: ${response['error']}');
        return {'error': response['error'].toString()};
      }
      
      print('🔴 ERRO DESCONHECIDO: Resposta não reconhecida: $response');
      return {'error': 'Resposta não reconhecida da API: $response'};
      
    } catch (e) {
      print('🔴 EXCEÇÃO: $e');
      return {'error': 'Erro de conexão: $e'};
    }
  }

  void clearCart() {
    _items.clear();
    _endereco = "";
    _taxaEntrega = 0;
    _currentOrderId = null;
    print('🔄 Carrinho limpo');
    notifyListeners();
  }

  void updateQuantity(int itemId, int quantidade) {
    int index = _items.indexWhere((item) {
      final id = (item["id"] as num).toInt();
      return id == itemId;
    });
    if (index != -1) {
      _items[index]["quantidade"] = quantidade;
      notifyListeners();
    }
  }

  int get totalItems {
    int total = 0;
    for (var item in _items) {
      total += (item["quantidade"] as num).toInt();
    }
    return total;
  }

  bool get isEmpty => _items.isEmpty;
}