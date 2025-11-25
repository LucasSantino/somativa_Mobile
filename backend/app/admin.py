from django.contrib import admin
from .models import (
    Usuario,
    Endereco,
    Categoria,
    ItemCardapio,
    Pedido,
    ItemPedido
)



#   CUSTOMIZAÇÃO DO USUÁRIO
@admin.register(Usuario)
class UsuarioAdmin(admin.ModelAdmin):
    list_display = ("user_id", "nome", "email", "dt_criacao")
    search_fields = ("nome", "email")
    ordering = ("user_id",)


#   ENDERECOS
@admin.register(Endereco)
class EnderecoAdmin(admin.ModelAdmin):
    list_display = ("id_endereco", "usuario", "cep", "cidade", "uf", "numero")
    search_fields = ("cep", "cidade", "bairro")
    list_filter = ("uf",)



#   CATEGORIAS
class CategoriaAdmin(admin.ModelAdmin):
    list_display = ("id_categoria", "nome_categoria")
    search_fields = ("nome_categoria",)



#   CARDÁPIO
@admin.register(ItemCardapio)
class ItemCardapioAdmin(admin.ModelAdmin):
    list_display = ("id_itemCardapio", "nome_itemCardapio", "categoria", "preco")
    search_fields = ("nome_itemCardapio", "descricao")
    list_filter = ("categoria",)


#   PEDIDOS
@admin.register(Pedido)
class PedidoAdmin(admin.ModelAdmin):
    list_display = ("id_pedido", "usuario", "valor_total", "taxa_entrega")
    list_filter = ("usuario",)


#   ITENS DO PEDIDO
@admin.register(ItemPedido)
class ItemPedidoAdmin(admin.ModelAdmin):
    list_display = ("id_itemPedido", "pedido", "item", "quantidade", "subtotal")
    list_filter = ("pedido",)
