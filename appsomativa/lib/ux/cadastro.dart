import 'package:flutter/material.dart';
import '../_core/constants/app_colors.dart';

class Cadastro extends StatefulWidget {
  const Cadastro({super.key});

  @override
  State<Cadastro> createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  bool _obscurePassword = true;
  final double fieldWidth = 0.85;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width * fieldWidth;

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Center(
        child: SingleChildScrollView(
          child: Card(
            color: const Color(0xFF1C1C1C),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 8,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // LOGO DENTRO DO CARD
                  Image.asset(
                    "assets/images/MangeEats_logo.png",
                    width: 280,
                    height: 280,
                  ),

                  const SizedBox(height: 20),

                  // CAMPO NOME
                  SizedBox(
                    width: width,
                    child: TextField(
                      style: const TextStyle(color: AppColors.white),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.person,
                          color: AppColors.white,
                        ),
                        labelText: "Nome Completo",
                        labelStyle: const TextStyle(color: AppColors.white),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: AppColors.white),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: AppColors.primary,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // CAMPO EMAIL
                  SizedBox(
                    width: width,
                    child: TextField(
                      style: const TextStyle(color: AppColors.white),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.email,
                          color: AppColors.white,
                        ),
                        labelText: "E-mail",
                        labelStyle: const TextStyle(color: AppColors.white),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: AppColors.white),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: AppColors.primary,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // CAMPO SENHA
                  SizedBox(
                    width: width,
                    child: TextField(
                      obscureText: _obscurePassword,
                      style: const TextStyle(color: AppColors.white),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.lock,
                          color: AppColors.white,
                        ),
                        labelText: "Senha",
                        labelStyle: const TextStyle(color: AppColors.white),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: AppColors.white),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: AppColors.primary,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: AppColors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // BOTÃO CADASTRAR
                  SizedBox(
                    width: width,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        "Cadastrar",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  // BOTÃO JÁ TENHO CONTA
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/login');
                    },
                    child: const Text(
                      "Já tenho conta",
                      style: TextStyle(color: AppColors.primary),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
