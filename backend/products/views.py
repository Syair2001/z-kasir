from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from django.shortcuts import get_object_or_404

from .models import Product
from .serializers import ProductSerializer
from .permissions import IsOwnerStoreProduct
from stores.models import Store


# 🔍 GET ALL + POST
class ProductListCreateView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        store = Store.objects.get(user=request.user)
        products = Product.objects.filter(store=store).order_by('-created_at')
        serializer = ProductSerializer(products, many=True)
        return Response(serializer.data)

    def post(self, request):
        store = Store.objects.get(user=request.user)

        serializer = ProductSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save(store=store)
            return Response(serializer.data, status=201)

        return Response(serializer.errors, status=400)


# ✏️ UPDATE + DELETE
class ProductDetailView(APIView):
    permission_classes = [IsAuthenticated, IsOwnerStoreProduct]

    def get_object(self, request, pk):
        product = get_object_or_404(Product, pk=pk)
        self.check_object_permissions(request, product)
        return product

    def get(self, request, pk):
        product = self.get_object(request, pk)
        serializer = ProductSerializer(product)
        return Response(serializer.data)

    def put(self, request, pk):
        product = self.get_object(request, pk)

        serializer = ProductSerializer(product, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)

        return Response(serializer.errors, status=400)

    def delete(self, request, pk):
        product = self.get_object(request, pk)
        product.delete()
        return Response({"message": "deleted"}, status=204)