from rest_framework import serializers
from django.contrib.auth.password_validation import validate_password
from .models import User
from stores.models import Store
from rest_framework_simplejwt.serializers import TokenObtainPairSerializer


class FullRegisterSerializer(serializers.ModelSerializer):
    store_name = serializers.CharField(write_only=True, required=True)
    address = serializers.CharField(write_only=True, required=True)
    phone_number = serializers.CharField(write_only=True, required=True)
    password = serializers.CharField(write_only=True, required=True)
    password_confirm = serializers.CharField(write_only=True, required=True)
    logo = serializers.ImageField(write_only=True, required=False, allow_null=True)

    class Meta:
        model = User
        fields = [
            'name', 'phone_number', 'email', 'username',
            'password', 'password_confirm', 'store_name', 'address', 'logo'
        ]

    def validate(self, data):
        if data['password'] != data['password_confirm']:
            raise serializers.ValidationError({"password": "Password tidak cocok"})
        
        validate_password(data['password'])
        return data

    def create(self, validated_data):
        logo = validated_data.pop('logo', None)
        store_name = validated_data.pop('store_name')
        address = validated_data.pop('address')
        password = validated_data.pop('password')
        validated_data.pop('password_confirm', None)

        # Buat User
        user = User.objects.create_user(
            username=validated_data['username'],
            email=validated_data.get('email'),
            password=password,
            name=validated_data.get('name', ''),
            phone_number=validated_data.get('phone_number', ''),
        )
        user.is_approved = False
        user.role = 'mustahik'
        user.save()

        # Buat Store
        store = Store.objects.create(
            user=user,
            name=store_name,
            address=address,
            phone=validated_data.get('phone_number'),
        )

        if logo:
            store.logo = logo
            store.save()

        return user

class CustomTokenObtainPairSerializer(TokenObtainPairSerializer):

    def validate(self, attrs):
        data = super().validate(attrs)

        user = self.user

        # Ambil data store
        store_data = None
        try:
            store = Store.objects.get(user=user)
            store_data = {
                "id": store.id,
                "name": store.name,
                "address": store.address,
                "phone": store.phone,
                "logo": self.context['request'].build_absolute_uri(store.get_logo_url),
                "has_custom_logo": store.has_custom_logo,
                "is_active": store.is_active,
            }
        except Store.DoesNotExist:
            store_data = None

        # Custom response
        data.update({
            "success": True,
            "message": "Login berhasil",
            "user": {
                "id": user.id,
                "name": user.name,
                "username": user.username,
                "phone_number": user.phone_number,
                "email": user.email,
                "role": user.role,
                "is_approved": user.is_approved,
            },
            "store": store_data,
            "status": "approved" if user.is_approved else "pending"
        })

        return data