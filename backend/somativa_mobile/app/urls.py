from django.urls import path
from .views import (
    ProdutoListView, UserCreateView, LoginView,
    PedidoCreateView, AdicionarItemView, FinalizarPedidoView
)

urlpatterns = [
    path('produtos/', ProdutoListView.as_view(), name='produtos'),
    path('cadastro/', UserCreateView.as_view(), name='cadastro'),
    path('login/', LoginView.as_view(), name='login'),
    path('pedidos/', PedidoCreateView.as_view(), name='criar-pedido'),
    path('pedidos/adicionar-item/', AdicionarItemView.as_view(), name='adicionar-item'),
    path('pedidos/<int:pk>/finalizar/', FinalizarPedidoView.as_view(), name='finalizar-pedido'),
]
