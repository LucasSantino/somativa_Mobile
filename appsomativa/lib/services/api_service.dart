import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Use 10.0.2.2 no Android Emulator para acessar o localhost
  static const String baseUrl = 'http://10.0.2.2:8000/';

  // Cadastro de usuário
  static Future<Map<String, dynamic>> cadastro(String username, String email, String password) async {
    try {
      print('🟡 CADASTRO: Chamando API');
      final response = await http.post(
        Uri.parse('${baseUrl}cadastro/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'email': email, 'password': password}),
      );
      
      print('🟡 Status Code: ${response.statusCode}');
      print('🟡 Response Body: ${response.body}');
      
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final data = jsonDecode(response.body);
        print('🟢 CADASTRO SUCESSO: $data');
        return data;
      } else {
        print('🔴 ERRO CADASTRO: ${response.statusCode} - ${response.body}');
        return {'error': 'Erro ${response.statusCode}: ${response.body}'};
      }
    } catch (e) {
      print('🔴 EXCEÇÃO CADASTRO: $e');
      return {'error': 'Erro de conexão: $e'};
    }
  }

  // Login por email
  static Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      print('🟡 LOGIN: Chamando API para email: $email');
      final response = await http.post(
        Uri.parse('${baseUrl}login/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );
      
      print('🟡 Status Code: ${response.statusCode}');
      print('🟡 Response Body: ${response.body}');
      
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final data = jsonDecode(response.body);
        print('🟢 LOGIN SUCESSO: $data');
        return data;
      } else {
        print('🔴 ERRO LOGIN: ${response.statusCode} - ${response.body}');
        return {'error': 'Erro ${response.statusCode}: ${response.body}'};
      }
    } catch (e) {
      print('🔴 EXCEÇÃO LOGIN: $e');
      return {'error': 'Erro de conexão: $e'};
    }
  }

  // Listar produtos
  static Future<List<dynamic>> listarProdutos() async {
    try {
      print('🟡 LISTAR PRODUTOS: Chamando API');
      final response = await http.get(
        Uri.parse('${baseUrl}produtos/'),
        headers: {'Content-Type': 'application/json'},
      );
      
      print('🟡 Status Code: ${response.statusCode}');
      
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final List<dynamic> data = jsonDecode(response.body);
        print('🟢 PRODUTOS CARREGADOS: ${data.length} produtos');
        return data;
      } else {
        print('🔴 ERRO PRODUTOS: ${response.statusCode} - ${response.body}');
        throw Exception('Falha ao carregar produtos: ${response.statusCode}');
      }
    } catch (e) {
      print('🔴 EXCEÇÃO PRODUTOS: $e');
      throw Exception('Erro de conexão: $e');
    }
  }

  // Criar pedido
  static Future<Map<String, dynamic>> criarPedido(int userId) async {
    try {
      print('🟡 CRIAR PEDIDO: User ID: $userId');
      print('🟡 URL: ${baseUrl}pedidos/');
      
      final response = await http.post(
        Uri.parse('${baseUrl}pedidos/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'user_id': userId}),
      );
      
      print('🟡 Status Code: ${response.statusCode}');
      print('🟡 Response Body: ${response.body}');
      
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final data = jsonDecode(response.body);
        print('🟢 PEDIDO CRIADO: $data');
        return data;
      } else {
        print('🔴 ERRO CRIAR PEDIDO: ${response.statusCode} - ${response.body}');
        return {'error': 'Erro ${response.statusCode}: ${response.body}'};
      }
    } catch (e) {
      print('🔴 EXCEÇÃO CRIAR PEDIDO: $e');
      return {'error': 'Erro de conexão: $e'};
    }
  }

  // Adicionar item ao pedido
  static Future<Map<String, dynamic>> adicionarItem(int pedidoId, int produtoId, int quantidade) async {
    try {
      print('🟡 ADICIONAR ITEM: Pedido: $pedidoId, Produto: $produtoId, Qtd: $quantidade');
      
      final response = await http.post(
        Uri.parse('${baseUrl}pedidos/adicionar-item/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'pedido_id': pedidoId, 'produto_id': produtoId, 'quantidade': quantidade}),
      );
      
      print('🟡 Status Code: ${response.statusCode}');
      print('🟡 Response Body: ${response.body}');
      
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final data = jsonDecode(response.body);
        print('🟢 ITEM ADICIONADO: $data');
        return data;
      } else {
        print('🔴 ERRO ADICIONAR ITEM: ${response.statusCode} - ${response.body}');
        return {'error': 'Erro ${response.statusCode}: ${response.body}'};
      }
    } catch (e) {
      print('🔴 EXCEÇÃO ADICIONAR ITEM: $e');
      return {'error': 'Erro de conexão: $e'};
    }
  }

  // Finalizar pedido
  static Future<Map<String, dynamic>> finalizarPedido(int pedidoId) async {
    try {
      print('🔵 FINALIZANDO PEDIDO: Chamando API para pedido $pedidoId');
      print('🔵 URL: ${baseUrl}pedidos/$pedidoId/finalizar/');
      
      final response = await http.post(
        Uri.parse('${baseUrl}pedidos/$pedidoId/finalizar/'),
        headers: {'Content-Type': 'application/json'},
      );
      
      print('🔵 Status Code: ${response.statusCode}');
      print('🔵 Response Body: ${response.body}');
      
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final data = jsonDecode(response.body);
        print('🟢 RESPOSTA DA API: $data');
        return data;
      } else {
        print('🔴 ERRO DA API: ${response.statusCode} - ${response.body}');
        return {'error': 'Erro ${response.statusCode}: ${response.body}'};
      }
    } catch (e) {
      print('🔴 EXCEÇÃO: $e');
      return {'error': 'Erro de conexão: $e'};
    }
  }

  // Listar pedidos de um usuário
  static Future<List<dynamic>> listarPedidos(int userId) async {
    try {
      print('🟡 LISTAR PEDIDOS: User ID: $userId');
      final response = await http.get(
        Uri.parse('${baseUrl}pedidos/usuario/$userId/'),
        headers: {'Content-Type': 'application/json'},
      );
      
      print('🟡 Status Code: ${response.statusCode}');
      
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final List<dynamic> data = jsonDecode(response.body);
        print('🟢 PEDIDOS CARREGADOS: ${data.length} pedidos');
        return data;
      } else {
        print('🔴 ERRO LISTAR PEDIDOS: ${response.statusCode} - ${response.body}');
        throw Exception('Falha ao carregar pedidos: ${response.statusCode}');
      }
    } catch (e) {
      print('🔴 EXCEÇÃO LISTAR PEDIDOS: $e');
      throw Exception('Erro de conexão: $e');
    }
  }
}