from rest_framework import serializers
from .models import Usuario, Endereco, Categoria, ItemCardapio, Pedido, ItemPedido


class UsuarioSerializer(serializers.ModelSerializer):
    class Meta:
        model = Usuario
        fields = "__all__"


class UsuarioCreateSerializer(serializers.ModelSerializer):
    senha = serializers.CharField(write_only=True)

    class Meta:
        model = Usuario
        fields = ["user_id", "nome", "email", "senha"]

    def create(self, validated_data):
        senha = validated_data.pop("senha")
        user = Usuario(**validated_data)
        user.set_password(senha)
        user.save()
        return user


class EnderecoSerializer(serializers.ModelSerializer):
    class Meta:
        model = Endereco
        fields = "__all__"


class CategoriaSerializer(serializers.ModelSerializer):
    class Meta:
        model = Categoria
        fields = "__all__"


class ItemCardapioSerializer(serializers.ModelSerializer):
    categoria = CategoriaSerializer(read_only=True)

    class Meta:
        model = ItemCardapio
        fields = "__all__"


class PedidoSerializer(serializers.ModelSerializer):
    class Meta:
        model = Pedido
        fields = "__all__"


class ItemPedidoSerializer(serializers.ModelSerializer):
    class Meta:
        model = ItemPedido
        fields = "__all__"
