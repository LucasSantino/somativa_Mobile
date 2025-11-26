import 'package:flutter/material.dart';
import '../_core/widgets/custom_appbar.dart';
import '../_core/constants/app_colors.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Login"),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              style: const TextStyle(color: AppColors.white),
              decoration: InputDecoration(
                labelText: "E-mail",
                labelStyle: const TextStyle(color: AppColors.white),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.white),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.primary),
                ),
              ),
            ),
            const SizedBox(height: 20),

            TextField(
              obscureText: true,
              style: const TextStyle(color: AppColors.white),
              decoration: InputDecoration(
                labelText: "Senha",
                labelStyle: const TextStyle(color: AppColors.white),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.white),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.primary),
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
              onPressed: () {},
              child: const Text(
                "Criar Conta",
                style: TextStyle(color: AppColors.primary),
              ),
            )
          ],
        ),
      ),
    );
  }
}
