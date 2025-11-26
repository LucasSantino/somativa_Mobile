import 'package:flutter/material.dart';
import '../_core/widgets/custom_appbar.dart';
import '../_core/constants/app_colors.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Bem-vindo ao Mange Eats"),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            // LOGO CENTRALIZADA
            Center(
              child: Image.asset(
                "assets/images/logo.png",
                width: 140, // pode ajustar
                height: 140,
              ),
            ),

            const SizedBox(height: 40),

            // CAMPO EMAIL
            TextField(
              style: const TextStyle(color: AppColors.white),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.email, color: AppColors.white),
                labelText: "E-mail",
                labelStyle: const TextStyle(color: AppColors.white),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: AppColors.white),
                  borderRadius: BorderRadius.circular(14),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: AppColors.primary),
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // CAMPO SENHA
            TextField(
              obscureText: true,
              style: const TextStyle(color: AppColors.white),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.lock, color: AppColors.white),
                labelText: "Senha",
                labelStyle: const TextStyle(color: AppColors.white),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: AppColors.white),
                  borderRadius: BorderRadius.circular(14),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: AppColors.primary),
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: () {},
              child: const Text("Entrar"),
            ),

            const SizedBox(height: 15),

            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/cadastro');
              },
              child: const Text(
                "Criar Conta",
                style: TextStyle(color: AppColors.primary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
