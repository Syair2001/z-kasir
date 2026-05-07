import csv
from django.http import HttpResponse
from .models import Transaction


def export_transactions_csv(request):
    if not request.user.is_authenticated or request.user.role != 'admin':
        return HttpResponse("Unauthorized", status=401)

    response = HttpResponse(content_type='text/csv')
    response['Content-Disposition'] = 'attachment; filename="laporan_transaksi.csv"'

    writer = csv.writer(response)

    writer.writerow(['ID', 'Tanggal', 'Total'])

    for t in Transaction.objects.all():
        writer.writerow([t.id, t.created_at, t.total_price])

    return response