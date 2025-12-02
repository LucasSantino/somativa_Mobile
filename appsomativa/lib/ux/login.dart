import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../_core/constants/app_colors.dart';
import '../services/api_service.dart';
import '../_core/providers/cart_provider.dart';  // Adicione este import

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;
  final double fieldWidth = 0.85;

  void loginUser() async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Preencha todos os campos"))
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await ApiService.login(email, password);

      if (response.containsKey('user_id')) {
        // Login bem-sucedido
        final userId = response['user_id'];
        
        // Salvar o user_id no CartProvider
        final cartProvider = Provider.of<CartProvider>(context, listen: false);
        cartProvider.setUserId(userId);
        
        // Navegar para home
        Navigator.pushReplacementNamed(context, '/home');
        
        // Feedback
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Login realizado com sucesso!"),
            backgroundColor: Colors.green,
          ),
        );
      } else if (response.containsKey('error')) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['error'].toString()))
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao conectar ao servidor: $e")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

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
                  Image.asset(
                    "assets/images/MangeEats_logo.png",
                    width: 280,
                    height: 280,
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: width,
                    child: TextField(
                      controller: emailController,
                      style: const TextStyle(color: AppColors.white),
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.email, color: AppColors.white),
                        labelText: "E-mail",
                        labelStyle: TextStyle(color: AppColors.white),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.white),
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.primary),
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: width,
                    child: TextField(
                      controller: passwordController,
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
                  SizedBox(
                    width: width,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : loginUser,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child:
                          _isLoading
                              ? const CircularProgressIndicator(
                                color: Colors.black,
                              )
                              : const Text(
                                "Entrar",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                    ),
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
          ),
        ),
      ),
    );
  }
}