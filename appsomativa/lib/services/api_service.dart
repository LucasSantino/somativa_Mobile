import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Use 10.0.2.2 no Android Emulator para acessar o localhost
  static const String baseUrl = 'http://10.0.2.2:8000/';

  // Cadastro de usuário
  static Future<Map<String, dynamic>> cadastro(String username, String email, String password) async {
    final response = await http.post(
      Uri.parse('${baseUrl}cadastro/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'email': email, 'password': password}),
    );
    return jsonDecode(response.body);
  }

  // Login por email
  static Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('${baseUrl}login/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    return jsonDecode(response.body);
  }

  // Listar produtos
  static Future<List<dynamic>> listarProdutos() async {
    final response = await http.get(Uri.parse('${baseUrl}produtos/'));
    return jsonDecode(response.body);
  }

  // Criar pedido
  static Future<Map<String, dynamic>> criarPedido(int userId) async {
    final response = await http.post(
      Uri.parse('${baseUrl}pedidos/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'user_id': userId}),
    );
    return jsonDecode(response.body);
  }

  // Adicionar item ao pedido
  static Future<Map<String, dynamic>> adicionarItem(int pedidoId, int produtoId, int quantidade) async {
    final response = await http.post(
      Uri.parse('${baseUrl}pedidos/adicionar-item/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'pedido_id': pedidoId, 'produto_id': produtoId, 'quantidade': quantidade}),
    );
    return jsonDecode(response.body);
  }

  // Finalizar pedido
  static Future<Map<String, dynamic>> finalizarPedido(int pedidoId) async {
    final response = await http.post(
      Uri.parse('${baseUrl}pedidos/$pedidoId/finalizar/'),
      headers: {'Content-Type': 'application/json'},
    );
    return jsonDecode(response.body);
  }

  // Listar pedidos de um usuário
  static Future<List<dynamic>> listarPedidos(int userId) async {
    final response = await http.get(Uri.parse('${baseUrl}pedidos/usuario/$userId/'));
    return jsonDecode(response.body);
  }
}
