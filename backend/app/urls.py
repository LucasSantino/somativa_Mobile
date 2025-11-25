from django.urls import path
from .views import *

urlpatterns = [
    # Autenticação
    path("login/", LoginView.as_view()),
    path("registrar/", RegistroView.as_view()),

    # Cardápio
    path("cardapio/", ListarItensCardapio.as_view()),

    # Pedido
    path("pedido/criar/", CriarPedido.as_view()),
    path("pedido/item/", InserirItemPedido.as_view()),
]
