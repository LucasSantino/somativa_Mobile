import 'package:flutter/material.dart';

class CartProvider extends ChangeNotifier {
  final List<Map<String, dynamic>> _items = [];

  String _endereco = "";
  double _taxaEntrega = 0;

  List<Map<String, dynamic>> get items => _items;
  String get endereco => _endereco;
  double get taxaEntrega => _taxaEntrega;

  double get subtotal {
    double soma = 0;
    for (var item in _items) {
      soma += item["preco"] * item["quantidade"];
    }
    return soma;
  }

  double get totalFinal => subtotal + _taxaEntrega;

  void addItem(Map<String, dynamic> item) {
    _items.add(item);
    notifyListeners();
  }

  void increaseQuantity(int index) {
    _items[index]["quantidade"]++;
    notifyListeners();
  }

  void decreaseQuantity(int index) {
    if (_items[index]["quantidade"] > 1) {
      _items[index]["quantidade"]--;
    }
    notifyListeners();
  }

  void removeItem(int index) {
    _items.removeAt(index);
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

  void clearCart() {
    _items.clear();
    _endereco = "";
    _taxaEntrega = 0;
    notifyListeners();
  }
}
