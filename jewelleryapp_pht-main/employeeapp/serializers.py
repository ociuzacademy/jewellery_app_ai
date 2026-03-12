from rest_framework import serializers
from .models import *
from django.conf import settings
from adminapp.models import *
from userapp.models import *

class EmployeeSerializer(serializers.ModelSerializer):
    photo = serializers.SerializerMethodField()

    class Meta:
        model = Tblemployee
        fields = ['name', 'email', 'password', 'phone', 'photo', 'address', 'position']

    def get_photo(self, obj):
        """Return the correct media path without the full domain"""
        if obj.photo:
            return f"media/{obj.photo}"
        return None

class EmployeeBookingSerializer(serializers.Serializer):
    id = serializers.IntegerField()
    product_name = serializers.CharField()
    size = serializers.CharField()
    weight = serializers.CharField()
    quantity = serializers.IntegerField()
    total_price = serializers.DecimalField(max_digits=10, decimal_places=2)
    advance_fee = serializers.DecimalField(max_digits=10, decimal_places=2)
    status = serializers.CharField()
    booking_date = serializers.DateTimeField()
    source = serializers.CharField()
   
   
class CartSerializer(serializers.ModelSerializer):
    product_name = serializers.CharField(source="product.name", read_only=True)
    product_main_image = serializers.SerializerMethodField()
    employee_name = serializers.CharField(source="assigned_employee.name", read_only=True)
    visit_date = serializers.SerializerMethodField()
    user_id = serializers.IntegerField(source="user.id", read_only=True)  # ✅ Add user_id

    class Meta:
        model = ProductBookings
        fields = [
            "id",
            "user_id",  # ✅ Add user_id here
            "product_name",
            "product_main_image",
            "size",
            "weight",
            "quantity",
            "total_price",
            "advance_fee",
            "status",
            "booking_date",
            "employee_name",
            "visit_date",
        ]

    def get_product_main_image(self, obj):
        """Return relative media path starting with 'media/...'."""
        if obj.product.main_image:
            return f"media/{obj.product.main_image.name}"
        return None

    def get_visit_date(self, obj):
        """Get visit_date from CartCheckout model if available."""
        checkout = CartCheckout.objects.filter(booking=obj).first()
        return checkout.visit_date if checkout else None
    

class ProductBookingSerializer(serializers.ModelSerializer):
    product_name = serializers.CharField(source="product.name", read_only=True)
    product_main_image = serializers.SerializerMethodField()
    employee_name = serializers.CharField(source="assigned_employee.name", read_only=True)
    visit_date = serializers.SerializerMethodField()
    user_id = serializers.IntegerField(source="user.id", read_only=True)  # ✅ Add user_id

    class Meta:
        model = ProductBookings
        fields = [
            "id",
            "user_id",  # ✅ Add user_id here
            "product_name",
            "product_main_image",
            "size",
            "weight",
            "quantity",
            "total_price",
            "advance_fee",
            "status",
            "booking_date",
            "employee_name",
            "visit_date",
        ]

    def get_product_main_image(self, obj):
        """Return relative media path starting with 'media/...'."""
        if obj.product.main_image:
            return f"media/{obj.product.main_image.name}"
        return None

    def get_visit_date(self, obj):
        """Get visit_date from CartCheckout model if available."""
        checkout = CartCheckout.objects.filter(booking=obj).first()
        return checkout.visit_date if checkout else None
    
    
class ViewCartSerializer(serializers.ModelSerializer):
    product_name = serializers.CharField(source="product.name", read_only=True)
    product_main_image = serializers.ImageField(source="product.main_image", read_only=True)
    user_name = serializers.CharField(source="user.name", read_only=True)
    employee_name = serializers.CharField(source="assigned_employee.name", read_only=True)

    class Meta:
        model = Cart
        fields = [
            "id",
            "product_name",
            "product_main_image",
            "size",
            "weight",
            "quantity",
            "total_price",
            "advance_fee",
            "status",
            "created_at",
            "user_name",
            "employee_name",
        ]
        
        
class ViewProductBookingSerializer(serializers.ModelSerializer):
    product_name = serializers.CharField(source="product.name", read_only=True)
    product_main_image = serializers.ImageField(source="product.main_image", read_only=True)
    user_name = serializers.CharField(source="user.name", read_only=True)
    employee_name = serializers.CharField(source="assigned_employee.name", read_only=True)

    class Meta:
        model = ProductBookings
        fields = [
            "id",
            "product_name",
            "product_main_image",
            "size",
            "weight",
            "quantity",
            "total_price",
            "advance_fee",
            "status",
            "booking_date",
            "user_name",
            "employee_name",
        ]
        
        
class BookingHistorySerializer(serializers.ModelSerializer):
    product_name = serializers.CharField(source="product.name", read_only=True)
    product_main_image = serializers.ImageField(source="product.main_image", read_only=True)
    # user_name = serializers.CharField(source="user.username", read_only=True)
    employee_name = serializers.CharField(source="assigned_employee.name", read_only=True)
    user = serializers.SerializerMethodField()

    class Meta:
        model = ProductBookings
        fields = [
            "id",
            "product_name",
            "product_main_image",
            "size",
            "weight",
            "quantity",
            "total_price",
            "advance_fee",
            "status",
            "booking_date",
            # "user_name",
            "employee_name",
            "user",
        ]
    def get_user(self, obj):
        return {
            "name": obj.user.name,
            "phone_number": obj.user.phone_number,
            "email": obj.user.email,
            "address": obj.user.address,
        }
        
class CartHistorySerializer(serializers.ModelSerializer):
    product_name = serializers.CharField(source="product.name", read_only=True)
    product_main_image = serializers.ImageField(source="product.main_image", read_only=True)
    # user_name = serializers.CharField(source="user.username", read_only=True)
    employee_name = serializers.CharField(source="assigned_employee.name", read_only=True)
    user = serializers.SerializerMethodField()
    
    class Meta:
        model = Cart
        fields = [
            "id",
            "product_name",
            "product_main_image",
            "size",
            "weight",
            "quantity",
            "total_price",
            "advance_fee",
            "status",
            "created_at",
            # "user_name",
            "employee_name",
            "user",
        ]
    def get_user(self, obj):
        return {
            "name": obj.user.name,
            "phone_number": obj.user.phone_number,
            "email": obj.user.email,
            "address": obj.user.address,
        }