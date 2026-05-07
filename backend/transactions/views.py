from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import IsAdminUser
from django.db.models import Sum
from django.db.models.functions import TruncDate

from .models import Transaction
from users.models import User


class AdminDashboardView(APIView):
    permission_classes = [IsAdminUser]

    def get(self, request):

        return Response({
            "total_transactions": Transaction.objects.count(),

            "total_revenue": Transaction.objects.aggregate(
                total=Sum('total_price')
            )['total'] or 0,

            "total_mustahik": User.objects.filter(role='mustahik').count(),

            "active_mustahik": User.objects.filter(
                role='mustahik',
                is_approved=True
            ).count(),

            "latest_transactions": [
                {
                    "id": t.id,
                    "total": t.total_price,
                    "date": t.created_at
                }
                for t in Transaction.objects.order_by('-created_at')[:10]
            ]
        })


class TransactionStatsView(APIView):
    permission_classes = [IsAdminUser]

    def get(self, request):

        data = (
            Transaction.objects
            .annotate(date=TruncDate('created_at'))
            .values('date')
            .annotate(total=Sum('total_price'))
            .order_by('date')
        )

        return Response(data)