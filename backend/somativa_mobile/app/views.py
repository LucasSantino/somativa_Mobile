from rest_framework import generics, status
from rest_framework.response import Response
from rest_framework.views import APIView
from django.contrib.auth import authenticate
from .models import Produto, Pedido, ItemPedido, User
from .serializers import ProdutoSerializer, PedidoSerializer, UserSerializer

# Listar produtos
class ProdutoListView(generics.ListAPIView):
    queryset = Produto.objects.all()
    serializer_class = ProdutoSerializer

# Cadastro de usuário
class UserCreateView(generics.CreateAPIView):
    queryset = User.objects.all()
    serializer_class = UserSerializer

# Login simples
class LoginView(APIView):
    def post(self, request):
        username = request.data.get('username')
        password = request.data.get('password')
        user = authenticate(username=username, password=password)
        if user:
            return Response({"message": "Login successful", "user_id": user.id})
        return Response({"error": "Credenciais inválidas"}, status=status.HTTP_401_UNAUTHORIZED)

# Criar pedido
class PedidoCreateView(APIView):
    def post(self, request):
        user_id = request.data.get('user_id')
        user = User.objects.get(id=user_id)
        pedido = Pedido.objects.create(user=user)
        serializer = PedidoSerializer(pedido)
        return Response(serializer.data)

# Adicionar item ao pedido
class AdicionarItemView(APIView):
    def post(self, request):
        pedido_id = request.data.get('pedido_id')
        produto_id = request.data.get('produto_id')
        quantidade = request.data.get('quantidade', 1)

        pedido = Pedido.objects.get(id=pedido_id)
        produto = Produto.objects.get(id=produto_id)

        item, created = ItemPedido.objects.get_or_create(
            pedido=pedido,
            produto=produto,
            defaults={'quantidade': quantidade}
        )
        if not created:
            item.quantidade += quantidade
            item.save()

        serializer = PedidoSerializer(pedido)
        return Response(serializer.data)

# Finalizar pedido
class FinalizarPedidoView(APIView):
    def post(self, request, pk):
        pedido = Pedido.objects.get(id=pk)
        pedido.finalizado = True
        pedido.save()
        serializer = PedidoSerializer(pedido)
        return Response(serializer.data)
