from django.http import JsonResponse
from django.utils.deprecation import MiddlewareMixin


class CheckApprovalMiddleware(MiddlewareMixin):
    """
    Middleware untuk membatasi akses Mustahik yang belum approved
    """

    def process_request(self, request):
        if not request.user.is_authenticated:
            return None

        if (request.user.role == 'mustahik' and 
            not request.user.is_approved and 
            request.path.startswith('/api/') and
            not request.path.startswith(('/api/token/', '/api/auth/register-full/'))):
            
            return JsonResponse({
                "detail": "Akun Anda belum diverifikasi oleh BAZNAS. Mohon tunggu persetujuan admin.",
                "status": "pending_approval",
                "user_id": request.user.id
            }, status=403)

        return None