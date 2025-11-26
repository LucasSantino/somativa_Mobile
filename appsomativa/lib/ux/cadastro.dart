import 'package:flutter/material.dart';
import '../_core/widgets/custom_appbar.dart';
import '../_core/constants/app_colors.dart';

class Cadastro extends StatelessWidget {
  const Cadastro({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Criar Conta"),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            TextField(
              style: const TextStyle(color: AppColors.white),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.person, color: AppColors.white),
                labelText: "Nome Completo",
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
              child: const Text("Cadastrar"),
            ),

            const SizedBox(height: 15),

            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              child: const Text(
                "Já tenho conta",
                style: TextStyle(color: AppColors.primary),
              ),
            )
          ],
        ),
      ),
    );
  }
}
