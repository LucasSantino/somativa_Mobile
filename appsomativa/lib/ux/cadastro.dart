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
        child: Column(
          children: [
            TextField(
              style: const TextStyle(color: AppColors.white),
              decoration: const InputDecoration(
                labelText: "Nome",
                labelStyle: TextStyle(color: AppColors.white),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.primary),
                ),
              ),
            ),
            const SizedBox(height: 20),

            TextField(
              style: const TextStyle(color: AppColors.white),
              decoration: const InputDecoration(
                labelText: "E-mail",
                labelStyle: TextStyle(color: AppColors.white),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.primary),
                ),
              ),
            ),
            const SizedBox(height: 20),

            TextField(
              obscureText: true,
              style: const TextStyle(color: AppColors.white),
              decoration: const InputDecoration(
                labelText: "Senha",
                labelStyle: TextStyle(color: AppColors.white),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.primary),
                ),
              ),
            ),
            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: () {},
              child: const Text("Cadastrar"),
            ),
          ],
        ),
      ),
    );
  }
}
