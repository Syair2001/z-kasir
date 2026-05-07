from rest_framework.permissions import BasePermission

class IsOwnerStoreProduct(BasePermission):
    def has_object_permission(self, request, view, obj):
        return obj.store.user == request.user