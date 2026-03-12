from rest_framework import serializers
from .models import *

class RegisterSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True)
    profile = serializers.SerializerMethodField()

    class Meta:
        model = TblRegister
        fields = ["id", "name", "email", "password", "phone_number", "address", "profile", "status"]  # Use profile_url

    def get_profile(self, obj):
        """Return the correct media path without the full domain"""
        if obj.profile:
            return f"media/{obj.profile}"
        return None

    def create(self, validated_data):
        return TblRegister.objects.create(**validated_data)


from rest_framework import serializers
from adminapp.models import Category
from rest_framework import serializers
from adminapp.models import Category
from rest_framework import serializers
from adminapp.models import Category
from rest_framework import serializers
from adminapp.models import *

class CategorySerializer(serializers.ModelSerializer):
    icon_url = serializers.SerializerMethodField()

    class Meta:
        model = Category
        fields = ['id', 'name', 'icon_url']

    def get_icon_url(self, obj):
        if obj.icon:
            # Return the relative URL for the icon
            return obj.icon.url  # This will return something like '/media/category_icons/icon.png'
        return None
    

class ProductSerializer(serializers.ModelSerializer):
    category_name = serializers.CharField(source='category.name', read_only=True)
    main_image = serializers.SerializerMethodField()
    images = serializers.SerializerMethodField()  # Override images to add `media/`

    class Meta:
        model = Product
        fields = [
            'id',
            'category',
            'category_name',
            'subcategory',
            'name',
            'description',
            'price',
            'stock',
            'main_image',
            'images',   # List of images with 'media/' prefix
            'sizes',
            'weights',
        ]

    def get_main_image(self, obj):
        if obj.main_image:
            return f"media/{obj.main_image.name}"
        return None

    def get_images(self, obj):
        # Add `media/` prefix to each image in the list
        return [f"media/{image}" for image in obj.images]



class ProductBookingSerializer(serializers.ModelSerializer):
    user_id = serializers.IntegerField()  # Explicitly add user field
    product_id = serializers.IntegerField()
    size = serializers.CharField(max_length=50)
    weight = serializers.CharField(max_length=50)
    quantity = serializers.IntegerField(min_value=1)

    class Meta:
        model = ProductBookings
        fields = ['user_id', 'product_id', 'size', 'weight', 'quantity','total_price','advance_fee']

    def validate(self, data):
        try:
            product = Product.objects.get(id=data['product_id'])
            if data['size'] not in product.sizes:
                raise serializers.ValidationError({'size': 'Invalid size selected'})
            if data['quantity'] > product.stock:
                raise serializers.ValidationError({'quantity': 'Insufficient stock available'})
        except Product.DoesNotExist:
            raise serializers.ValidationError({'product_id': 'Product not found'})
        return data 
    
class CartSerializer(serializers.ModelSerializer):
    user_id = serializers.IntegerField()  # Explicitly add user field
    product_id = serializers.IntegerField()
    size = serializers.CharField(max_length=50)
    weight = serializers.CharField(max_length=50)
    quantity = serializers.IntegerField(min_value=1)

    class Meta:
        model = Cart
        fields = ['user_id', 'product_id', 'size', 'weight', 'quantity','total_price','advance_fee','status']

    def validate(self, data):
        try:
            product = Product.objects.get(id=data['product_id'])
            if data['size'] not in product.sizes:
                raise serializers.ValidationError({'size': 'Invalid size selected'})
            if data['quantity'] > product.stock:
                raise serializers.ValidationError({'quantity': 'Insufficient stock available'})
        except Product.DoesNotExist:
            raise serializers.ValidationError({'product_id': 'Product not found'})
        return data 
    
    
class FeedbackSerializer(serializers.ModelSerializer):
    class Meta:
        model = Feedback
        fields = ['id', 'user', 'rating', 'feedback_text', 'created_at']
        
class CheckoutSerializer(serializers.ModelSerializer):
    class Meta:
        model = Checkout
        fields = ['id', 'user', 'booking', 'advance_fee', 'visit_date', 'visit_time', 'created_at']
        
class CartCheckoutSerializer(serializers.ModelSerializer):
    class Meta:
        model = CartCheckout
        fields = ['id', 'user', 'visit_date'    , 'visit_time', 'created_at']
        
class PaymentDetailsSerializer(serializers.ModelSerializer):
    user_name = serializers.CharField(source='user.name', read_only=True)
    user_email = serializers.CharField(source='user.email', read_only=True)
    user_phone_number = serializers.CharField(source='user.phone_number', read_only=True)


    class Meta:
        model =  ProductBookings
        fields = [
            'id', 'user', 'user_name', 'user_email', 'user_phone_number',
             'total_price','advance_fee'
        ]
        def user_name(self,obj):
            return obj.user.name if obj.user else None
        def user_email(self,obj):
            return obj.user.email if obj.user else None
        def user_phone_number(self,obj):
            return obj.user.phone_number if obj.user else None
        
        
class CartPaymentDetailsSerializer(serializers.ModelSerializer):
    user_name = serializers.CharField(source='user.name', read_only=True)
    user_email = serializers.CharField(source='user.email', read_only=True)
    user_phone_number = serializers.CharField(source='user.phone_number', read_only=True)


    class Meta:
        model =  Cart
        fields = [
            'id', 'user', 'user_name', 'user_email', 'user_phone_number',
             'total_price','advance_fee'
        ]
        def user_name(self,obj):
            return obj.user.name if obj.user else None
        def user_email(self,obj):
            return obj.user.email if obj.user else None
        def user_phone_number(self,obj):
            return obj.user.phone_number if obj.user else None
        


class WishlistSerializer(serializers.ModelSerializer):
    class Meta:
        model = Wishlist
        fields = ['id', 'user', 'product', 'size', 'weight', 'quantity', 'created_at']
        
class ViewWishlistSerializer(serializers.ModelSerializer):
    product_name = serializers.CharField(source='product.name', read_only=True)
    product_price = serializers.DecimalField(source='product.price', max_digits=10, decimal_places=2, read_only=True)
    product_main_image = serializers.SerializerMethodField()

    class Meta:
        model = Wishlist
        fields = ['id', 'user', 'product', 'product_name', 'product_price', 'product_main_image', 'created_at']

    def get_product_main_image(self, obj):
        if obj.product.main_image:
            return obj.product.main_image.url  # This returns "/media/..."
        return None

        
class UpiPaymentSerializer(serializers.ModelSerializer):
    class Meta:
        model = Upi
        fields = '__all__'
        
class CardSerializer(serializers.ModelSerializer):
    class Meta:
        model = Card
        fields = '__all__'
        
class CartUpiSerializer(serializers.ModelSerializer):
    class Meta:
        model = CartUpi
        fields = '__all__'
        
class CartCardSerializer(serializers.ModelSerializer):
    class Meta:
        model = CartCard
        fields = '__all__'
        
class WishlistSerializer(serializers.ModelSerializer):
    class Meta:
        model = Wishlist
        fields = ['id', 'user', 'product', 'size', 'weight', 'quantity']
        
        
class BookingHistorySerializer(serializers.ModelSerializer):
    product_name = serializers.CharField(source="product.name", read_only=True)
    product_image = serializers.ImageField(source="product.main_image", read_only=True)
    visit_date = serializers.SerializerMethodField()
    visit_time = serializers.SerializerMethodField()
    assigned_employee_name = serializers.CharField(source="assigned_employee.name", read_only=True, default="Not Assigned")

    class Meta:
        model = ProductBookings
        fields = [
            "id",
            "product_name",
            "product_image",
            "size",
            "weight",
            "quantity",
            "total_price",
            "advance_fee",
            "status",
            "booking_date",
            "assigned_employee_name",
            "visit_date",
            "visit_time",  
        ]
    def get_visit_date(self, obj):
        """Get visit_date from Checkout model if available."""
        checkout = Checkout.objects.filter(booking=obj).first()
        return checkout.visit_date if checkout else None

    def get_visit_time(self, obj):
        """Get visit_time from Checkout model if available."""
        checkout = Checkout.objects.filter(booking=obj).first()
        return checkout.visit_time if checkout else None
    
    
class CartHistorySerializer(serializers.ModelSerializer):
    product_name = serializers.CharField(source="product.name", read_only=True)
    product_image = serializers.ImageField(source="product.main_image", read_only=True)
    assigned_employee_name = serializers.CharField(source="assigned_employee.name", read_only=True, default="Not Assigned")
    visit_date = serializers.SerializerMethodField()
    visit_time = serializers.SerializerMethodField()

    class Meta:
        model = Cart
        fields = [
            "id",
            "product_name",
            "product_image",
            "size",
            "weight",
            "quantity",
            "total_price",
            "advance_fee",
            "status",
            "created_at",
            "assigned_employee_name",
            "visit_date",  # ✅ Include visit_date
            "visit_time",  # ✅ Include visit_time
        ]
    def get_visit_date(self, obj):
        """Get visit_date from CartCheckout model if available."""
        checkout = CartCheckout.objects.filter(booking=obj).first()
        return checkout.visit_date if checkout else None

    def get_visit_time(self, obj):
        """Get visit_time from CartCheckout model if available."""
        checkout = CartCheckout.objects.filter(booking=obj).first()
        return checkout.visit_time if checkout else None