from django.contrib.auth.models import AbstractUser
from django.db import models

class User(AbstractUser):
    ROLE_CHOICES = (
        ('admin', 'Admin'),
        ('mustahik', 'Mustahik'),
    )

    role = models.CharField(max_length=20, choices=ROLE_CHOICES, default='mustahik')
    is_approved = models.BooleanField(default=False)
    name = models.CharField(max_length=255, blank=True)
    phone_number = models.CharField(max_length=20, blank=True)

    def __str__(self):
        return self.username