import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../providers/cart_provider.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool canGoBack; // novo parâmetro

  const CustomAppBar({
    super.key,
    required this.title,
    this.canGoBack = true, // padrão é true
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      centerTitle: true,

      // BOTÃO DE VOLTAR (só aparece se houver página anterior e se canGoBack for true)
      leading:
          canGoBack && Navigator.canPop(context)
              ? IconButton(
                icon: const Icon(Icons.arrow_back, color: AppColors.primary),
                onPressed: () => Navigator.pop(context),
              )
              : null,

      // AÇÕES DO APPBAR
      actions: [
        /// 🔥 BOTÃO DE SAIR (LOGOUT)
        IconButton(
          icon: const Icon(Icons.logout, color: Colors.redAccent),
          onPressed: () {
            // limpa o carrinho também
            try {
              context.read<CartProvider>().clearCart();
            } catch (_) {}

            // remove todas as rotas e volta para login
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/login',
              (route) => false,
            );
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}
