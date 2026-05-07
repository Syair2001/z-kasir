from django.contrib import admin
from django.urls import path, include
from django.http import JsonResponse
from django.conf import settings
from django.conf.urls.static import static

from users.views import (
    FullRegisterView,
    PendingUsersView,
    ApproveUserView,
    CustomTokenObtainPairView
)
from transactions.views import (
    AdminDashboardView,
    TransactionStatsView
)
from transactions.export import export_transactions_csv
from rest_framework_simplejwt.views import (
    TokenObtainPairView,
    TokenRefreshView
)


def home(request):
    return JsonResponse({
        "status": "Z-Kasir Backend Running",
        "version": "1.0.0",
        "message": "Sistem Kasir Mustahik BAZNAS Barru"
    })


urlpatterns = [
    path('', home, name='home'),

    # Admin Django
    path('admin/', admin.site.urls),

    # ===================== AUTH =====================
    path('api/auth/register-full/', FullRegisterView.as_view(), name='register-full'),
    path('api/token/', CustomTokenObtainPairView.as_view(), name='token_obtain_pair'),
    path('api/token/refresh/', TokenRefreshView.as_view(), name='token_refresh'),

    # ===================== ADMIN ONLY =====================
    path('api/admin/pending-users/', PendingUsersView.as_view(), name='pending-users'),
    path('api/admin/approve/<int:id>/', ApproveUserView.as_view(), name='approve-user'),

    path('api/admin/dashboard/', AdminDashboardView.as_view(), name='admin-dashboard'),
    path('api/admin/stats/', TransactionStatsView.as_view(), name='transaction-stats'),
    path('api/admin/export/transactions/', export_transactions_csv, name='export-transactions'),

    # ===================== MUSTAHIK =====================
    path('api/products/', include('products.urls')),
    path('api/store/', include('stores.urls')),        # ← Pastikan ini ada

    # Store endpoints (akan dibuat nanti)
    # path('api/store/', include('stores.urls')),
]

# ===================== MEDIA FILES (Development) =====================
if settings.DEBUG:
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)


# Optional: Custom 404
handler404 = lambda request, exception: JsonResponse({
    "error": "Endpoint tidak ditemukan"
}, status=404)