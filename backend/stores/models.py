from django.db import models
from users.models import User
from django.conf import settings


class Store(models.Model):
    user = models.OneToOneField(
        User, 
        on_delete=models.CASCADE, 
        related_name='store'
    )

    name = models.CharField(max_length=255)
    address = models.TextField()
    phone = models.CharField(max_length=20, null=True, blank=True)

    # Logo Custom (Opsional)
    logo = models.ImageField(
        upload_to='logos/', 
        null=True, 
        blank=True,
        max_length=255,
        help_text="Logo kedai sendiri (maksimal 400KB). Kosongkan jika ingin pakai logo BAZNAS."
    )

    is_active = models.BooleanField(default=False)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.name

    # ================== LOGIKA LOGO ==================
    @property
    def get_logo_url(self):
        """Mengembalikan URL logo yang harus digunakan (Custom atau Default)"""
        if self.logo:
            return self.logo.url
        # Logo Default BAZNAS
        return f"{settings.STATIC_URL}images/logo-baznas-default.png"

    @property
    def has_custom_logo(self):
        """True jika user upload logo sendiri"""
        return bool(self.logo)

    @property
    def logo_display(self):
        return "Custom Logo" if self.has_custom_logo else "Logo Default BAZNAS"