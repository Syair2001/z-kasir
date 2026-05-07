from rest_framework import generics, status
from rest_framework.response import Response
from rest_framework.permissions import AllowAny, IsAdminUser
from rest_framework_simplejwt.views import TokenObtainPairView
from .serializers import CustomTokenObtainPairSerializer
from django.shortcuts import get_object_or_404

from .models import User
from .serializers import FullRegisterSerializer
from stores.models import Store


class FullRegisterView(generics.CreateAPIView):
    queryset = User.objects.all()
    serializer_class = FullRegisterSerializer
    permission_classes = [AllowAny]

    def create(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        user = serializer.save()

        return Response({
            "message": "Pendaftaran berhasil. Mohon tunggu verifikasi dari admin BAZNAS.",
            "user_id": user.id,
            "username": user.username,
            "status": "pending"
        }, status=status.HTTP_201_CREATED)


class PendingUsersView(generics.ListAPIView):
    permission_classes = [IsAdminUser]
    serializer_class = FullRegisterSerializer  # atau buat serializer khusus

    def get_queryset(self):
        return User.objects.filter(is_approved=False, role='mustahik')


class ApproveUserView(generics.UpdateAPIView):
    permission_classes = [IsAdminUser]
    queryset = User.objects.filter(role='mustahik')
    lookup_field = 'id'

    def update(self, request, *args, **kwargs):
        user = self.get_object()
        user.is_approved = True
        user.save()

        # Aktifkan store juga
        Store.objects.filter(user=user).update(is_active=True)

        return Response({
            "message": f"User {user.username} telah disetujui",
            "status": "approved"
        })
    
class CustomTokenObtainPairView(TokenObtainPairView):
    serializer_class = CustomTokenObtainPairSerializer