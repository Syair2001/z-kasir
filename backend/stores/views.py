from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from rest_framework import status

from .models import Store
from users.permissions import IsApprovedUser


class StoreMeView(APIView):
    """
    Endpoint untuk mendapatkan data toko + owner (dipakai setelah login)
    """
    permission_classes = [IsAuthenticated, IsApprovedUser]

    def get(self, request):
        try:
            store = Store.objects.select_related('user').get(user=request.user)

            data = {
                "success": True,
                "store": {
                    "id": store.id,
                    "name": store.name,
                    "address": store.address,
                    "phone": store.phone,
                    "logo": request.build_absolute_uri(store.get_logo_url),
                    "has_custom_logo": store.has_custom_logo,
                    "is_active": store.is_active,
                    "created_at": store.created_at.isoformat(),
                },
                "owner": {
                    "id": request.user.id,
                    "name": request.user.name,
                    "username": request.user.username,
                    "phone_number": request.user.phone_number,
                    "email": request.user.email,
                    "is_approved": request.user.is_approved,
                }
            }
            return Response(data)

        except Store.DoesNotExist:
            return Response({
                "success": False,
                "detail": "Data toko belum ditemukan."
            }, status=status.HTTP_404_NOT_FOUND)