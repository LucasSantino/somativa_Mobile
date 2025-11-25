from django.db import models
from django.contrib.auth.models import AbstractBaseUser, BaseUserManager


#   USER MANAGER
class UserManager(BaseUserManager):
    def create_user(self, email, nome, senha=None):
        if not email:
            raise ValueError("Usuário precisa de um email")

        email = self.normalize_email(email)
        user = self.model(email=email, nome=nome)

        user.set_password(senha)
        user.save(using=self._db)
        return user

    def create_superuser(self, email, nome, senha):
        user = self.create_user(email=email, nome=nome, senha=senha)
        user.is_admin = True
        user.save(using=self._db)
        return user



#   USER MODEL
class Usuario(AbstractBaseUser):
    user_id = models.AutoField(primary_key=True)
    nome = models.CharField(max_length=120)
    email = models.EmailField(unique=True)
    dt_criacao = models.DateTimeField(auto_now_add=True)

    is_active = True
    is_admin = False

    USERNAME_FIELD = "email"
    REQUIRED_FIELDS = ["nome"]

    objects = UserManager()

    def __str__(self):
        return self.nome

    @property
    def is_staff(self):
        return self.is_admin


#   ENDERECO
class Endereco(models.Model):
    id_endereco = models.AutoField(primary_key=True)
    usuario = models.ForeignKey(Usuario, on_delete=models.CASCADE)
    cep = models.CharField(max_length=9)
    bairro = models.CharField(max_length=120)
    cidade = models.CharField(max_length=120)
    uf = models.CharField(max_length=2)
    numero = models.CharField(max_length=20)

    def __str__(self):
        return f"{self.cep} - {self.cidade}"


#   CATEGORIA
class Categoria(models.Model):
    id_categoria = models.AutoField(primary_key=True)
    nome_categoria = models.CharField(max_length=120)

    def __str__(self):
        return self.nome_categoria


#   ITEM CARDAPIO
class ItemCardapio(models.Model):
    id_itemCardapio = models.AutoField(primary_key=True)
    nome_itemCardapio = models.CharField(max_length=200)
    descricao = models.TextField()
    preco = models.DecimalField(max_digits=10, decimal_places=2)
    categoria = models.ForeignKey(Categoria, on_delete=models.CASCADE)
    imagem = models.ImageField(upload_to="cardapio/", null=True, blank=True)

    def __str__(self):
        return self.nome_itemCardapio


#   PEDIDO
class Pedido(models.Model):
    id_pedido = models.AutoField(primary_key=True)
    usuario = models.ForeignKey(Usuario, on_delete=models.CASCADE)
    endereco = models.ForeignKey(Endereco, on_delete=models.CASCADE)
    valor_total = models.DecimalField(max_digits=10, decimal_places=2)
    taxa_entrega = models.DecimalField(max_digits=10, decimal_places=2)

    def __str__(self):
        return f"Pedido {self.id_pedido}"


#   ITEM PEDIDO
class ItemPedido(models.Model):
    id_itemPedido = models.AutoField(primary_key=True)
    pedido = models.ForeignKey(Pedido, on_delete=models.CASCADE)
    item = models.ForeignKey(ItemCardapio, on_delete=models.CASCADE)
    quantidade = models.IntegerField()
    subtotal = models.DecimalField(max_digits=10, decimal_places=2)

    def __str__(self):
        return f"Item {self.id_itemPedido}"
