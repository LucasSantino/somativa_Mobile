from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status, generics, permissions
from django.contrib.auth import authenticate
from rest_framework_simplejwt.tokens import RefreshToken

from .models import *
from .serializers import *


#   AUTENTICAÇÃO
class LoginView(APIView):
    def post(self, request):
        email = request.data.get("email")
        senha = request.data.get("senha")

        user = authenticate(request, email=email, password=senha)
        if user is None:
            return Response({"erro": "Credenciais inválidas"}, status=400)

        refresh = RefreshToken.for_user(user)

        return Response({
            "token": str(refresh.access_token),
            "refresh": str(refresh),
            "user_id": user.user_id,
            "nome": user.nome
        })


class RegistroView(generics.CreateAPIView):
    queryset = Usuario.objects.all()
    serializer_class = UsuarioCreateSerializer


#   CARDÁPIO
class ListarItensCardapio(APIView):
    def get(self, request):
        itens = ItemCardapio.objects.all()
        serializer = ItemCardapioSerializer(itens, many=True)
        return Response(serializer.data)


#   PEDIDO
class CriarPedido(APIView):
    def post(self, request):
        pedido_serializer = PedidoSerializer(data=request.data)
        if pedido_serializer.is_valid():
            pedido = pedido_serializer.save()
            return Response(PedidoSerializer(pedido).data, status=201)
        return Response(pedido_serializer.errors, status=400)


class InserirItemPedido(APIView):
    def post(self, request):
        serializer = ItemPedidoSerializer(data=request.data)
        if serializer.is_valid():
            item = serializer.save()
            return Response(ItemPedidoSerializer(item).data, status=201)
        return Response(serializer.errors, status=400)
