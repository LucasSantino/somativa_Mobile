import 'package:flutter/material.dart';
import '_core/theme/app_theme.dart';
import 'ux/login.dart';
import 'ux/cadastro.dart';

void main() {
  runApp(const MangeEatsApp());
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
      },
    );
  }
}
