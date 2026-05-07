from django.urls import path
from .views import StoreMeView

urlpatterns = [
    path('me/', StoreMeView.as_view(), name='store-me'),
]