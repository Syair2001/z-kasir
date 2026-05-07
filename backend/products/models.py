from django.db import models
from stores.models import Store

class Product(models.Model):
    store = models.ForeignKey(Store, on_delete=models.CASCADE,related_name='products')
    name = models.CharField(max_length=255)
    price = models.DecimalField(max_digits=12, decimal_places=2)
    stock = models.IntegerField(default=0)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.name