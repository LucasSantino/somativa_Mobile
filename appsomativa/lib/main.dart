import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '_core/theme/app_theme.dart';
import '_core/providers/cart_provider.dart';

import 'ux/login.dart';
import 'ux/cadastro.dart';
import 'ux/home.dart';
import 'ux/confirmacao.dart';
import 'ux/carrinho.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: const MangeEatsApp(),
    ),
  );
}

class MangeEatsApp extends StatelessWidget {
  const MangeEatsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mange Eats',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,

      initialRoute: '/login',

      routes: {
        '/login': (_) => const Login(),
        '/cadastro': (_) => const Cadastro(),
        '/home': (_) => const Home(),
        '/carrinho': (_) => const Carrinho(),
        '/confirmacao': (_)=>  const Confirmacao(),
      },
    );
  }
}
