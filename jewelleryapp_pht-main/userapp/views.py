from collections import defaultdict
from django.shortcuts import get_object_or_404, render

# Create your views here.
from rest_framework import status, viewsets
from rest_framework.response import Response
from rest_framework.permissions import AllowAny
from .models import TblRegister
from .serializers import RegisterSerializer
from rest_framework import status, viewsets
from rest_framework.response import Response
from rest_framework.permissions import AllowAny
from .models import *
from .serializers import *
from django.conf import settings

class RegisterViewSet(viewsets.ModelViewSet):
    queryset = TblRegister.objects.all()
    serializer_class = RegisterSerializer
    permission_classes = [AllowAny]
    http_method_names = ["post"]  # Corrected from 'http_method' to 'http_method_names'

    def create(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        if serializer.is_valid():
            user = serializer.save()
            return Response({"message": "User registered successfully", "user_id": user.id, "role": "user"}, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


from rest_framework import status
from rest_framework.response import Response
from rest_framework.permissions import AllowAny
from rest_framework.views import APIView
from .models import TblRegister
from .serializers import RegisterSerializer

# class LoginView(APIView):
#     permission_classes = [AllowAny]

#     def post(self, request):
#         email = request.data.get("email")
#         password = request.data.get("password")

#         if not email or not password:
#             return Response({"error": "Email and password are required"}, status=status.HTTP_400_BAD_REQUEST)

#         try:
#             user = TblRegister.objects.get(email=email, password=password)
#             return Response({
#                 "message": "Login successful",
#                 "user_id": user.id,
#                 "name": user.name,
#                 "status": user.status
#             }, status=status.HTTP_200_OK)
#         except TblRegister.DoesNotExist:
#             return Response({"error": "Invalid email or password"}, status=status.HTTP_401_UNAUTHORIZED)


class LoginView(APIView):
    permission_classes = [AllowAny]

    def post(self, request):
        email = request.data.get("email")
        password = request.data.get("password")

        # ✅ Validate email and password
        if not email or not password:
            return Response(
                {"error": "Email and password are required"},
                status=status.HTTP_400_BAD_REQUEST,
            )

        try:
            # ✅ Check if user exists with given email and password
            user = TblRegister.objects.get(email=email, password=password)

            # ✅ Check if user is approved
            if user.status == "blocked":
                return Response(
                    {"error": "Your account is blocked. Please contact support."},
                    status=status.HTTP_403_FORBIDDEN,
                )

            # ✅ Allow login if user is approved
            return Response(
                {
                    "message": "Login successful",
                    "user_id": user.id,
                    "name": user.name,
                    "status": user.status,
                },
                status=status.HTTP_200_OK,
            )

        except TblRegister.DoesNotExist:
            # ❌ Invalid credentials
            return Response(
                {"error": "Invalid email or password"},
                status=status.HTTP_401_UNAUTHORIZED,
            )

from rest_framework.decorators import api_view
from rest_framework.response import Response
from adminapp.models import Category
from .serializers import CategorySerializer
from rest_framework.decorators import api_view
from rest_framework.response import Response
from adminapp.models import *
from .serializers import CategorySerializer


@api_view(['GET'])
def user_category_list(request):
    categories = Category.objects.all()
    serializer = CategorySerializer(categories, many=True, context={'request': request})
    return Response(serializer.data)

class ViewProductsView(viewsets.ReadOnlyModelViewSet):
    queryset = Product.objects.all()
    serializer_class = ProductSerializer

    def list(self, request, *args, **kwargs):
        product_id = request.query_params.get("product_id")  # Fetch service_id from query params
        category_id = request.query_params.get("category")  # Fetch category_id if provided

        if product_id:
            try:
                product = self.queryset.get(id=product_id)
                serializer = self.get_serializer(product)  # No `many=True` for single object
                return Response(serializer.data, status=status.HTTP_200_OK)
            except Product.DoesNotExist:
                return Response({"detail": "Product not found."}, status=status.HTTP_404_NOT_FOUND)

        elif category_id:
            products = self.queryset.filter(category_id=category_id)
            serializer = self.get_serializer(products, many=True)
            return Response(serializer.data, status=status.HTTP_200_OK)

        else:
            # No filtering, return all services
            return super().list(request, *args, **kwargs)
        
        
class ViewUserProfileView(viewsets.ReadOnlyModelViewSet):
    queryset = TblRegister.objects.all()
    serializer_class = RegisterSerializer

    def list(self, request, *args, **kwargs):
        user_id = request.query_params.get("id")  # Get user id from query parameters

        if user_id:
            try:
                user = self.queryset.get(id=user_id)
                serializer = self.get_serializer(user)
                return Response(serializer.data, status=status.HTTP_200_OK)
            except TblRegister.DoesNotExist:
                return Response({"detail": "User not found."}, status=status.HTTP_404_NOT_FOUND)
        else:
            # No user_id provided, return all users (if required)
            return super().list(request, *args, **kwargs)
        
from rest_framework import generics 
        
class ProductBySubcategoryView(generics.ListAPIView):
    serializer_class = ProductSerializer

    def get_queryset(self):
        subcategory = self.request.query_params.get('subcategory')
        category_id = self.request.query_params.get('category_id')
        return Product.objects.filter(subcategory=subcategory, category_id=category_id)
    
class ProductBookingView(viewsets.ModelViewSet):
    serializer_class = ProductBookingSerializer
    http_method_names = ['post']

    def create(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        if serializer.is_valid():
            user_id = request.data.get('user_id')
            product = Product.objects.get(id=serializer.validated_data['product_id'])
            size = serializer.validated_data['size']
            weight = serializer.validated_data['weight']
            quantity = serializer.validated_data['quantity']

            # Assume authenticated user
            user = TblRegister.objects.get(id=user_id)

            # ✅ Calculate total price
            total_price = product.price * quantity
            advance_fee = total_price * Decimal('0.10')

            # Create booking with total price
            booking = ProductBookings.objects.create(
                user=user,
                product=product,
                size=size,
                weight=weight,
                quantity=quantity,
                total_price=total_price,  # Add this field to your model if not already present
                advance_fee=advance_fee
            )

            # Update product stock
            product.stock -= quantity
            product.save()

            return Response({
                'status': 'success',
                'message': 'Product booked successfully',
                'booking_id': booking.id,
                'total_price': total_price,
                'advance_fee': advance_fee
            }, status=status.HTTP_201_CREATED)

        return Response({
            'status': 'error',
            'errors': serializer.errors
        }, status=status.HTTP_400_BAD_REQUEST)
        
class CheckoutView(viewsets.ModelViewSet):
    serializer_class = CheckoutSerializer  
    http_method_names=['post']

    def create(self, request, *args, **kwargs):
        serializer = self.serializer_class(data=request.data)
        serializer.is_valid(raise_exception=True)

        user_id = serializer.validated_data['user'].id
        booking_id = serializer.validated_data['booking'].id
        visit_date = serializer.validated_data['visit_date']
        visit_time = serializer.validated_data['visit_time']

        try:
            # Fetch user and booking
            user = TblRegister.objects.get(id=user_id)
            booking = ProductBookings.objects.get(id=booking_id, user=user)

            # Calculate 10% platform fee from total price
            advance_fee = booking.total_price * Decimal('0.10')

            # Create payment record
            payment = Checkout.objects.create(
                user=user,
                booking=booking,
                advance_fee=advance_fee,
                visit_date=visit_date,
                visit_time=visit_time
            )

            response_serializer = self.serializer_class(payment)

            return Response({
                'status': 'success',
                'message': 'Payment recorded successfully.',
                'data': response_serializer.data,
                'advance_fee':advance_fee,
                'booking_id':booking.id
            }, status=status.HTTP_201_CREATED)

        except TblRegister.DoesNotExist:
            return Response({'status': 'error', 'message': 'User not found.'}, status=status.HTTP_404_NOT_FOUND)

        except ProductBookings.DoesNotExist:
            return Response({'status': 'error', 'message': 'Booking not found for this user.'}, status=status.HTTP_404_NOT_FOUND)

        except Exception as e:
            return Response({'status': 'error', 'message': str(e)}, status=status.HTTP_400_BAD_REQUEST)


        
class FeedbackView(viewsets.ModelViewSet):
    queryset = Feedback.objects.all()
    serializer_class = FeedbackSerializer
    http_method_names = ['post']

    def create(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            response_data={
                'data':serializer.data,
                'status': 'success',
                'message': 'Feedback submitted successfully',
                
            }
            return Response(response_data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
class PaymentListViewSet(viewsets.ViewSet):
    def list(self, request):
        booking_id = request.query_params.get('id')

        if not booking_id:
            return Response({'error': 'booking_id is required'}, status=status.HTTP_400_BAD_REQUEST)

        bookings = ProductBookings.objects.get(id=booking_id)
        serializer = PaymentDetailsSerializer(bookings)
        return Response(serializer.data, status=status.HTTP_200_OK)



# class CartView(viewsets.ModelViewSet):
#     queryset = Cart.objects.all()
#     serializer_class = CartSerializer
#     http_method_names = ['post']

#     def create(self, request, *args, **kwargs):
#         user_id = request.data.get('user_id')
#         product_id = request.data.get('product_id')
#         size = request.data.get('size')
#         weight = request.data.get('weight')
#         quantity = int(request.data.get('quantity', 1))
#         status_value = request.data.get('status', 'pending')  # Default to 'pending'

#         # Ensure required fields are provided and not null/empty
#         if not user_id or not product_id or not size or not weight:
#             return Response(
#                 {"status": "failed", "message": "User, Product, Size, and Weight are required"},
#                 status=status.HTTP_400_BAD_REQUEST
#             )

#         # Prevent adding product if size or weight is explicitly null or empty
#         if size.strip() == "" or weight.strip() == "":
#             return Response(
#                 {"status": "failed", "message": "Size and Weight cannot be empty"},
#                 status=status.HTTP_400_BAD_REQUEST
#             )

#         if quantity <= 0:
#             return Response(
#                 {"status": "failed", "message": "Quantity must be greater than 0"},
#                 status=status.HTTP_400_BAD_REQUEST
#             )

#         try:
#             product = Product.objects.get(id=product_id)

#             # Check stock
#             if quantity > product.stock:
#                 return Response(
#                     {"status": "failed", "message": "Insufficient stock available"},
#                     status=status.HTTP_400_BAD_REQUEST
#                 )

#             # Calculate total price
#             total_price = product.price * quantity

#             # Calculate advance fee (10% of total price)
#             advance_fee = total_price * Decimal('0.10')

#             # Check if product already exists in cart
#             cart_item, created = Cart.objects.get_or_create(
#                 user_id=user_id,
#                 product_id=product_id,
#                 defaults={
#                     'size': size,
#                     'weight': weight,
#                     'quantity': quantity,
#                     'total_price': total_price,
#                     'advance_fee': advance_fee,
#                     'status': status_value,  # Add status here
#                 }
#             )

#             if not created:
#                 # Update existing cart item (increase quantity and recalculate price/fee)
#                 cart_item.quantity += quantity
#                 cart_item.total_price = product.price * cart_item.quantity
#                 cart_item.advance_fee = cart_item.total_price * Decimal('0.10')
#                 cart_item.status = status_value  # Update status if needed
#                 cart_item.save()

#             # Serialize cart item to return in response
#             serializer = CartSerializer(cart_item)

#             return Response(
#                 {
#                     "status": "success",
#                     "message": "Product added to cart successfully",
#                     "cart_item": serializer.data  # Include cart data in response
#                 },
#                 status=status.HTTP_201_CREATED
#             )

#         except Product.DoesNotExist:
#             return Response(
#                 {"status": "failed", "message": "Product not found"},
#                 status=status.HTTP_404_NOT_FOUND
#             )
#         except Exception as e:
#             return Response(
#                 {"status": "failed", "message": "An error occurred", "error": str(e)},
#                 status=status.HTTP_500_INTERNAL_SERVER_ERROR
#             )

class CartView(viewsets.ModelViewSet):
    queryset = Cart.objects.all()
    serializer_class = CartSerializer
    http_method_names = ['post']

    def create(self, request, *args, **kwargs):
        user_id = request.data.get('user_id')
        product_id = request.data.get('product_id')
        size = request.data.get('size')
        weight = request.data.get('weight')
        quantity = int(request.data.get('quantity', 1))
        status_value = request.data.get('status', 'pending')  # Default to 'pending'

        # ✅ Ensure required fields are provided and not null/empty
        if not user_id or not product_id or not size or not weight:
            return Response(
                {"status": "failed", "message": "User, Product, Size, and Weight are required"},
                status=status.HTTP_400_BAD_REQUEST
            )

        # ✅ Prevent adding product if size or weight is explicitly null or empty
        if size.strip() == "" or weight.strip() == "":
            return Response(
                {"status": "failed", "message": "Size and Weight cannot be empty"},
                status=status.HTTP_400_BAD_REQUEST
            )

        if quantity <= 0:
            return Response(
                {"status": "failed", "message": "Quantity must be greater than 0"},
                status=status.HTTP_400_BAD_REQUEST
            )

        try:
            # ✅ Fetch the product and check stock
            product = Product.objects.get(id=product_id)

            if quantity > product.stock:
                return Response(
                    {"status": "failed", "message": "Insufficient stock available"},
                    status=status.HTTP_400_BAD_REQUEST
                )

            # ✅ Calculate total price and advance fee
            total_price = product.price * quantity
            advance_fee = total_price * Decimal('0.10')  # 10% advance fee

            # ✅ Create a new cart entry for each addition, regardless of existing products
            cart_item = Cart.objects.create(
                user_id=user_id,
                product_id=product_id,
                size=size,
                weight=weight,
                quantity=quantity,
                total_price=total_price,
                advance_fee=advance_fee,
                status=status_value,
            )

            # ✅ Serialize and return the created cart item
            serializer = CartSerializer(cart_item)

            return Response(
                {
                    "status": "success",
                    "message": "Product added to cart successfully.",
                    "cart_item": serializer.data
                },
                status=status.HTTP_201_CREATED
            )

        except Product.DoesNotExist:
            return Response(
                {"status": "failed", "message": "Product not found"},
                status=status.HTTP_404_NOT_FOUND
            )
        except Exception as e:
            return Response(
                {"status": "failed", "message": "An error occurred", "error": str(e)},
                status=status.HTTP_500_INTERNAL_SERVER_ERROR
            )

class  CartCheckoutView(viewsets.ModelViewSet):
    serializer_class = CartCheckoutSerializer
    http_method_names = ['post']

    def create(self, request, *args, **kwargs):
        user_id = request.data.get('user')
        visit_date = request.data.get('visit_date')
        visit_time = request.data.get('visit_time')

        if not user_id or not visit_date or not visit_time:
            return Response(
                {"status": "failed", "message": "User, Visit Date, and Visit Time are required"},
                status=status.HTTP_400_BAD_REQUEST
            )

        try:
            user = TblRegister.objects.get(id=user_id)
        except TblRegister.DoesNotExist:
            return Response(
                {"status": "failed", "message": "User not found"},
                status=status.HTTP_404_NOT_FOUND
            )

        cart_items = Cart.objects.filter(user=user)
        if not cart_items.exists():
            return Response(
                {"status": "failed", "message": "Cart is empty"},
                status=status.HTTP_400_BAD_REQUEST
            )

        total_advance_fee = Decimal('0.00')
        payments = []

        # Create CartCheckout records for each cart item
        for item in cart_items:
            payment = CartCheckout.objects.create(
                user=user,
                booking=item,
                advance_fee=item.advance_fee,
                visit_date=visit_date,
                visit_time=visit_time
            )
            payments.append(payment)
            total_advance_fee += item.advance_fee

            # Update cart item status instead of deleting
            # item.status = "Checked Out"
            item.save()

        # Serialize the created CartCheckout records
        serializer = CartCheckoutSerializer(payments, many=True)

        return Response(
            {
                "status": "success",
                "message": "Checkout completed successfully",
                "total_advance_fee": str(total_advance_fee),
                "visit_date": visit_date,
                "visit_time": visit_time,
                "payments": serializer.data
            },
            status=status.HTTP_201_CREATED
        )

  
class CartSummaryView(viewsets.ViewSet):
    def list(self, request):
        user_id = request.query_params.get('user_id')

        if not user_id:
            return Response(
                {"status": "failed", "message": "User ID is required"},
                status=status.HTTP_400_BAD_REQUEST
            )

        try:
            # Fetch user details
            user = TblRegister.objects.filter(id=user_id).first()
            if not user:
                return Response(
                    {"status": "failed", "message": "User not found"},
                    status=status.HTTP_404_NOT_FOUND
                )

            # Fetch all cart items for the given user
            cart_items = Cart.objects.filter(user_id=user_id)

            if not cart_items.exists():
                return Response(
                    {"status": "failed", "message": "No items in the cart"},
                    status=status.HTTP_404_NOT_FOUND
                )

            # Calculate total amount
            total_amount = sum(Decimal(item.total_price) for item in cart_items)

            # **Calculate advance fee (10% of total amount)**
            advance_fee = total_amount * Decimal('0.10')

            return Response(
                {   
                    'status':'success',
                    "id": cart_items.first().id,  # Use the first cart item's ID
                    "user": user.id,
                    "user_name": user.name,  # Assuming `name` is the field for user's name
                    "user_email": user.email,
                    "user_phone_number": user.phone_number,  # Assuming `phone` is the field for user's phone
                    "total_price": f"{total_amount:.2f}",
                    "advance_fee": f"{advance_fee:.2f}"  # Ensure advance fee is 10%
                },
                status=status.HTTP_200_OK
            )

        except Exception as e:
            return Response(
                {"status": "failed", "message": "An error occurred", "error": str(e)},
                status=status.HTTP_500_INTERNAL_SERVER_ERROR
            )
    

class ViewCartItems(APIView):
    def get(self, request, *args, **kwargs):
        user_id = request.query_params.get('user_id')

        if not user_id:
            return Response(
                {"status": "failed", "message": "User ID is required to view cart items"},
                status=status.HTTP_400_BAD_REQUEST
            )

        # Filter cart items by user and status 'pending'
        cart_items = Cart.objects.filter(user_id=user_id, status="pending").select_related('product')

        if not cart_items.exists():
            return Response(
                {"status": "success", "message": "No pending items in cart", "cart_items": [], "total_price": 0},
                status=status.HTTP_200_OK
            )

        cart_data = []
        total_price = 0  # Initialize total price

        for item in cart_items:
            product_price = item.product.price  # Get the product price
            item_total_price = product_price * item.quantity  # Calculate total price for this item
            total_price += item_total_price  # Add to overall total price
            
            product_image_url = f"{settings.MEDIA_URL}{item.product.main_image}" if item.product.main_image else None
            
            cart_data.append({
                "id": item.id,
                "product_name": item.product.name,
                "quantity": item.quantity,
                "size": item.size,
                "weight": item.weight,
                "single_item_price": product_price, # Single product price
                "item_total_price": item_total_price,  # Updated total price per item
                "stock": item.product.stock,
                "product_image": product_image_url
            })

        return Response(
            {
                "status": "success",
                "cart_items": cart_data,
                "total_price": total_price  # Send updated total price
            },
            status=status.HTTP_200_OK
        )

        
class RemoveCartView(generics.DestroyAPIView):
    queryset = Cart.objects.all()
    serializer_class = CartSerializer

    def destroy(self, request, *args, **kwargs):
        cart_item_id = request.query_params.get('id')
        try:
            cart_item = Cart.objects.get(id=cart_item_id)
            cart_item.delete()
            return Response(
                {"status": "success", "message": "Product removed from cart successfully"},
                status=status.HTTP_200_OK
            )
        except Cart.DoesNotExist:
            return Response(
                {"status": "failed", "message": "Cart item not found"},
                status=status.HTTP_404_NOT_FOUND
            )
        except Exception as e:
            return Response(
                {"status": "failed", "message": "An error occurred", "error": str(e)},
                status=status.HTTP_500_INTERNAL_SERVER_ERROR
)


# class AddToWishlistView(viewsets.ModelViewSet):
#     queryset = Wishlist.objects.all()
#     serializer_class = WishlistSerializer
#     http_method_names = ['post']

#     def create(self, request, *args, **kwargs):
#         user_id = request.data.get('user_id')
#         product_id = request.data.get('product_id')
#         size = request.data.get('size', '')
#         weight = request.data.get('weight', '')
#         quantity = int(request.data.get('quantity', 1))  # Default quantity is 1

#         if not user_id or not product_id:
#             return Response({'error': 'User ID and Product ID are required'}, status=status.HTTP_400_BAD_REQUEST)

#         # Fetch user and product instances
#         user = TblRegister.objects.filter(id=user_id).first()
#         product = Product.objects.filter(id=product_id).first()

#         if not user:
#             return Response({'error': 'User not found'}, status=status.HTTP_404_NOT_FOUND)

#         if not product:
#             return Response({'error': 'Product not found'}, status=status.HTTP_404_NOT_FOUND)

#         # Check if the product is already in the wishlist
#         if Wishlist.objects.filter(user=user, product=product, size=size, weight=weight).exists():
#             return Response({'message': 'Product with selected options is already in the wishlist'}, status=status.HTTP_200_OK)

#         # Add product to wishlist with size, weight, and quantity
#         wishlist_item = Wishlist.objects.create(user=user, product=product, size=size, weight=weight, quantity=quantity)
#         serializer = self.get_serializer(wishlist_item)

#         return Response({
#             'status':'success',
#             'message': 'Product successfully added to wishlist',
#             'wishlist_item': serializer.data
#         }, status=status.HTTP_201_CREATED)

class AddToWishlistView(viewsets.ModelViewSet):
    queryset = Wishlist.objects.all()
    serializer_class = WishlistSerializer
    http_method_names = ['post']

    def create(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)

        if serializer.is_valid():
            user_id = serializer.validated_data['user'].id
            product_id = serializer.validated_data['product'].id
            size = serializer.validated_data.get('size', '')
            weight = serializer.validated_data.get('weight', '')
            
            # Check if the product is already in the wishlist
            if Wishlist.objects.filter(user_id=user_id, product_id=product_id, size=size, weight=weight).exists():
                return Response({'message': 'Product with selected options is already in the wishlist'}, status=status.HTTP_200_OK)

            # Save the wishlist entry
            wishlist_item = serializer.save()
            return Response({
                'status': 'success',
                'message': 'Product successfully added to wishlist',
                'wishlist_item': WishlistSerializer(wishlist_item).data
            }, status=status.HTTP_201_CREATED)
        
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class WishlistView(viewsets.ModelViewSet):
    queryset = Wishlist.objects.all()
    serializer_class = ViewWishlistSerializer  # Use the updated serializer
    http_method_names = ['get']

    def user_wishlist(self, request):
        """Retrieve wishlist items that the authenticated user has added along with product details."""
        user_id = request.query_params.get('user_id')

        if not user_id:
            return Response({'error': 'User ID is required'}, status=status.HTTP_400_BAD_REQUEST)

        user = TblRegister.objects.filter(id=user_id).first()
        if not user:
            return Response({'error': 'User not found'}, status=status.HTTP_404_NOT_FOUND)

        # Fetch wishlist items with related product details
        wishlist_items = Wishlist.objects.filter(user=user).select_related('product')
        serializer = ViewWishlistSerializer(wishlist_items, many=True)

        return Response({'wishlist': serializer.data}, status=status.HTTP_200_OK)

    
class RemoveWishlistView(generics.DestroyAPIView):
    queryset = Wishlist.objects.all()
    serializer_class = WishlistSerializer

    def destroy(self, request, *args, **kwargs):
        wishlist_id = request.query_params.get('id')
        try:
            wishlist_item = Wishlist.objects.get(id=wishlist_id)
            wishlist_item.delete()
            return Response(
                {"status": "success", "message": "Product removed from Wishlist successfully"},
                status=status.HTTP_200_OK
            )
        except Wishlist.DoesNotExist:
            return Response(
                {"status": "failed", "message": "Wishlist item not found"},
                status=status.HTTP_404_NOT_FOUND
            )
        except Exception as e:
            return Response(
                {"status": "failed", "message": "An error occurred", "error": str(e)},
                status=status.HTTP_500_INTERNAL_SERVER_ERROR
)
            
class AddWishlistToCartView(viewsets.ModelViewSet):
    http_method_names = ['post']
    serializer_class = WishlistSerializer

    def create(self, request):
        user_id = request.data.get('user_id')
        product_id = request.data.get('product_id')

        if not user_id or not product_id:
            return Response({'error': 'User ID and Product ID are required'}, status=status.HTTP_400_BAD_REQUEST)

        # Fetch the wishlist item
        wishlist_item = Wishlist.objects.filter(user_id=user_id, product_id=product_id).first()
        if not wishlist_item:
            return Response({'error': 'Product not found in wishlist'}, status=status.HTTP_404_NOT_FOUND)

        # Fetch product details
        product = get_object_or_404(Product, id=product_id)

        # Get size, weight, and quantity from wishlist
        size = wishlist_item.size
        weight = wishlist_item.weight
        quantity = wishlist_item.quantity

        # Convert price to Decimal
        total_price = Decimal(product.price) * quantity
        advance_fee = total_price * Decimal('0.10')  # Fixed: Use Decimal instead of float

        # Add to cart or update existing item
        cart_item, created = Cart.objects.get_or_create(
            user_id=user_id,
            product=product,
            size=size,
            weight=weight,
            defaults={
                'quantity': quantity,
                'total_price': total_price,
                'advance_fee': advance_fee,
                'status': 'pending'
            }
        )

        # If cart item already exists, update quantity and price
        if not created:
            cart_item.quantity += quantity
            cart_item.total_price = cart_item.quantity * Decimal(product.price)
            cart_item.advance_fee = cart_item.total_price * Decimal('0.10')
            cart_item.save()

        # Remove from wishlist after adding to cart
        wishlist_item.delete()

        return Response({
            'status':'success',
            'message': 'Product moved from wishlist to cart successfully',
            'cart_item': {
                'product_id': cart_item.product.id,
                'size': cart_item.size,
                'weight': cart_item.weight,
                'quantity': cart_item.quantity,
                'total_price': str(cart_item.total_price),  # Convert Decimal to string for JSON response
                'advance_fee': str(cart_item.advance_fee)
            }
        }, status=status.HTTP_201_CREATED)
            
class UpiPaymentView(viewsets.ModelViewSet):
    serializer_class = UpiPaymentSerializer
    http_method_names = ['post']

    def create(self, request, *args, **kwargs):
        """Create a UPI Payment Entry for a Booking and Update Status"""
        booking_id = request.data.get("booking_id")
        upi_id = request.data.get("upi_id")

        if not booking_id or not upi_id:
            return Response(
                {"message": "Booking ID and UPI ID are required"},
                status=status.HTTP_400_BAD_REQUEST
            )

        # Check if the booking exists
        booking = get_object_or_404(ProductBookings, id=booking_id)

        # Check if a payment already exists for this booking
        if Upi.objects.filter(booking=booking).exists():
            return Response(
                {"message": "Payment already exists for this booking"},
                status=status.HTTP_400_BAD_REQUEST
            )

        try:
            # Create a new UPI Payment entry
            upi_payment = Upi.objects.create(
                booking=booking,
                upi_id=upi_id,
                status="success"  # Initially, mark payment as successful
            )

            # Update booking status to "paid" after payment creation
            booking.status = "paid"
            booking.save()

            serializer = UpiPaymentSerializer(upi_payment)
            return Response(
                {"status": "Success", "data": serializer.data},
                status=status.HTTP_201_CREATED
            )

        except Exception as e:
            return Response(
                {"message": "An error occurred", "error": str(e)},
                status=status.HTTP_500_INTERNAL_SERVER_ERROR
            )

class CardPaymentView(viewsets.ModelViewSet):
    serializer_class = CardSerializer
    http_method_names = ['post']

    def create(self, request, *args, **kwargs):
        """Create a Card Payment Entry for a Booking and Update Status"""
        booking_id = request.data.get("booking")
        card_holder_name = request.data.get("card_holder_name")
        card_number = request.data.get("card_number")
        expiry_date = request.data.get("expiry_date")
        cvv = request.data.get("cvv")

        # Validate required fields
        if not all([booking_id, card_holder_name, card_number, expiry_date, cvv]):
            return Response(
                {"message": "All fields (Booking ID, Card Holder Name, Card Number, Expiry Date, CVV) are required"},
                status=status.HTTP_400_BAD_REQUEST
            )

        try:
            booking = ProductBookings.objects.get(id=booking_id)

            # Check if a payment already exists for this booking
            if Card.objects.filter(booking=booking).exists():
                return Response(
                    {"message": "Payment already exists for this booking"},
                    status=status.HTTP_400_BAD_REQUEST
                )

            # Create a new Card Payment entry
            card_payment = Card.objects.create(
                booking=booking,
                card_holder_name=card_holder_name,
                card_number=card_number,
                expiry_date=expiry_date,
                cvv=cvv,
                status="success"  # Assuming success for now
            )

            # Update booking status to "paid"
            booking.status = "paid"
            booking.save()

            serializer = CardSerializer(card_payment)
            return Response(
                {"message": "Success", "data": serializer.data},
                status=status.HTTP_201_CREATED
            )

        except ProductBookings.DoesNotExist:
            return Response(
                {"message": "Booking not found"},
                status=status.HTTP_404_NOT_FOUND
            )


class CartUpiPaymentView(viewsets.ModelViewSet):
    serializer_class = CartUpiSerializer
    http_method_names = ['post']

    def create(self, request, *args, **kwargs):
        """Create a UPI Payment Entry for All Items in User's Cart"""
        user_id = request.data.get("user_id")
        upi_id = request.data.get("upi_id")

        # ✅ Validate required fields
        if not user_id or not upi_id:
            return Response(
                {"message": "User ID and UPI ID are required"},
                status=status.HTTP_400_BAD_REQUEST
            )

        try:
            # ✅ Fetch the user
            user = TblRegister.objects.get(id=user_id)

            # ✅ Get all unpaid cart items for this user
            cart_items = Cart.objects.filter(user=user, status="pending")

            if not cart_items.exists():
                return Response(
                    {"message": "No pending cart items for this user"},
                    status=status.HTTP_400_BAD_REQUEST
                )

            # ✅ Calculate total amount for all items in the cart
            total_amount = sum(cart.total_price for cart in cart_items)

            # ✅ Check if pending items exist after previous payments
            if not Cart.objects.filter(user=user, status="pending").exists():
                return Response(
                    {"message": "No pending cart items for this user"},
                    status=status.HTTP_400_BAD_REQUEST
                )

            # ✅ Create a new UPI payment entry
            upi_payment = CartUpi.objects.create(
                user=user,
                upi_id=upi_id,
                status="success"  # Assuming payment is successful
            )

            # ✅ Mark all cart items as paid
            cart_items.update(status="paid")

            # ✅ Serialize the created payment
            serializer = CartUpiSerializer(upi_payment)
            return Response(
                {
                    "message": "UPI Payment Successful, All Cart Items Updated",
                    # "total_amount": total_amount,
                    "data": serializer.data
                },
                status=status.HTTP_201_CREATED
            )

        except TblRegister.DoesNotExist:
            return Response(
                {"message": "User not found"},
                status=status.HTTP_404_NOT_FOUND
            )
        except Exception as e:
            return Response(
                {"message": "An error occurred", "error": str(e)},
                status=status.HTTP_500_INTERNAL_SERVER_ERROR
            )
            
class CartCardPaymentView(viewsets.ModelViewSet):
    serializer_class = CartCardSerializer
    http_method_names = ['post']

    def create(self, request, *args, **kwargs):
        """Create a Card Payment Entry for All Items in User's Cart"""
        user_id = request.data.get("user_id")
        card_holder_name = request.data.get("card_holder_name")
        card_number = request.data.get("card_number")
        expiry_date = request.data.get("expiry_date")
        cvv = request.data.get("cvv")

        # ✅ Validate required fields
        if not all([user_id, card_holder_name, card_number, expiry_date, cvv]):
            return Response(
                {"message": "All fields (User ID, Card Holder Name, Card Number, Expiry Date, CVV) are required"},
                status=status.HTTP_400_BAD_REQUEST
            )

        try:
            # ✅ Fetch the user
            user = TblRegister.objects.get(id=user_id)

            # ✅ Get all unpaid (pending) cart items for this user
            cart_items = Cart.objects.filter(user=user, status="pending")

            if not cart_items.exists():
                return Response(
                    {"message": "No pending cart items for this user"},
                    status=status.HTTP_400_BAD_REQUEST
                )

            # ✅ Calculate total amount for all items in the cart
            total_amount = sum(cart.total_price for cart in cart_items)

            # ✅ Check if there are still pending items
            if not Cart.objects.filter(user=user, status="pending").exists():
                return Response(
                    {"message": "No pending cart items for this user"},
                    status=status.HTTP_400_BAD_REQUEST
                )

            # ✅ Create a new Card Payment entry
            card_payment = CartCard.objects.create(
                user=user,
                card_holder_name=card_holder_name,
                card_number=card_number[-4:],  # Store only last 4 digits for security
                expiry_date=expiry_date,
                cvv=cvv,
                status="success"  # ✅ Mark as success for now
            )

            # ✅ Mark all cart items as paid
            cart_items.update(status="paid")

            # ✅ Serialize the created payment
            serializer = CartCardSerializer(card_payment)
            return Response(
                {
                    "message": "Card Payment Successful, All Cart Items Updated",
                    # "total_amount": total_amount,
                    "data": serializer.data
                },
                status=status.HTTP_201_CREATED
            )

        except TblRegister.DoesNotExist:
            return Response(
                {"message": "User not found"},
                status=status.HTTP_404_NOT_FOUND
            )
        except Exception as e:
            return Response(
                {"message": "An error occurred", "error": str(e)},
                status=status.HTTP_500_INTERNAL_SERVER_ERROR
            )

    
class CombinedBookingHistoryView(APIView):
    def get(self, request, *args, **kwargs):
        user_id = request.query_params.get("user_id")

        # ✅ Validate user_id
        if not user_id:
            return Response(
                {"status": "failed", "message": "User ID is required."},
                status=status.HTTP_400_BAD_REQUEST,
            )

        try:
            # ✅ Fetch product bookings with "paid", "assigned", and "completed" statuses
            product_bookings = ProductBookings.objects.filter(
                user_id=user_id, status__in=["paid", "assigned", "completed"]
            ).order_by("-booking_date")

            # ✅ Fetch all cart bookings with "paid", "assigned", and "completed" statuses
            cart_bookings = Cart.objects.filter(
                user_id=user_id, status__in=["paid", "assigned", "completed"]
            ).order_by("-created_at")

            # ✅ Serialize product bookings as a list
            product_data = BookingHistorySerializer(product_bookings, many=True).data

            # ✅ Serialize all cart bookings as a list
            cart_data = CartHistorySerializer(cart_bookings, many=True).data

            # ✅ Return combined response
            return Response(
                {
                    "status": "success",
                    "product_bookings": product_data,  # List of product bookings
                    "cart_bookings": cart_data,  # List of all cart bookings
                },
                status=status.HTTP_200_OK,
            )

        except Exception as e:
            return Response(
                {"status": "failed", "message": "An error occurred.", "error": str(e)},
                status=status.HTTP_500_INTERNAL_SERVER_ERROR,
            )

class EmployeeBookingHistoryView(APIView):
    def get(self, request, *args, **kwargs):
        employee_id = request.query_params.get("employee_id")

        # ✅ Validate employee_id
        if not employee_id:
            return Response(
                {"error": "Employee ID is required"},
                status=status.HTTP_400_BAD_REQUEST,
            )

        # ✅ Fetch assigned Cart Bookings for the employee (completed and full paid only)
        cart_bookings = Cart.objects.filter(
            assigned_employee_id=employee_id,
            status__in=["completed", "full paid"],  # ✅ Only fetch completed & full paid
        ).select_related("user", "product").order_by("-created_at")

        # ✅ Fetch assigned ProductBookings for the employee (completed and full paid only)
        product_bookings = ProductBookings.objects.filter(
            assigned_employee_id=employee_id,
            status__in=["completed", "full paid"],  # ✅ Only fetch completed & full paid
        ).select_related("user", "product").order_by("-booking_date")

        # ✅ Group data by user
        grouped_data = defaultdict(lambda: {"user_details": {}, "booking_history": []})

        # ✅ Serialize Cart Bookings
        for cart in cart_bookings:
            cart_checkout = CartCheckout.objects.filter(booking=cart).first()
            user_id = cart.user.id

            # ✅ Add user details if not already added
            if not grouped_data[user_id]["user_details"]:
                grouped_data[user_id]["user_details"] = {
                    "user_id": user_id,
                    "name": cart.user.name,
                    "phone_number": cart.user.phone_number,
                    "email": cart.user.email,
                    "address": cart.user.address,
                }

            # ✅ Add Cart Booking to booking_history
            grouped_data[user_id]["booking_history"].append({
                "id": cart.id,
                "product_name": cart.product.name,
                "product_image": self.get_image_url(cart.product.main_image),
                "size": cart.size,
                "weight": cart.weight,
                "quantity": cart.quantity,
                "total_price": cart.total_price,
                "advance_fee": cart.advance_fee,
                "status": cart.status,
                "booking_date": cart.created_at,
                "visit_date": cart_checkout.visit_date if cart_checkout else None,
                "source": "Cart",
            })

        # ✅ Serialize Product Bookings
        for booking in product_bookings:
            checkout_info = Checkout.objects.filter(booking=booking).first()
            user_id = booking.user.id

            # ✅ Add user details if not already added
            if not grouped_data[user_id]["user_details"]:
                grouped_data[user_id]["user_details"] = {
                    "user_id": user_id,
                    "name": booking.user.name,
                    "phone_number": booking.user.phone_number,
                    "email": booking.user.email,
                    "address": booking.user.address,
                }

            # ✅ Add Product Booking to booking_history
            grouped_data[user_id]["booking_history"].append({
                "id": booking.id,
                "product_name": booking.product.name,
                "product_image": self.get_image_url(booking.product.main_image),
                "size": booking.size,
                "weight": booking.weight,
                "quantity": booking.quantity,
                "total_price": booking.total_price,
                "advance_fee": booking.advance_fee,
                "status": booking.status,
                "booking_date": booking.booking_date,
                "visit_date": checkout_info.visit_date if checkout_info else None,
                "source": "ProductBookings",
            })

        # ✅ Prepare final response
        final_data = []
        for user_id, data in grouped_data.items():
            # ✅ Sort booking history by booking date (most recent first)
            data["booking_history"] = sorted(
                data["booking_history"], key=lambda x: x["booking_date"], reverse=True
            )
            final_data.append(data)

        # ✅ If no data, return empty response
        if not final_data:
            return Response(
                {"message": "No booking history found for this employee."},
                status=status.HTTP_200_OK,
            )

        # ✅ Return response with booking history
        return Response(final_data, status=status.HTTP_200_OK)

    def get_image_url(self, image):
        """Return relative media path starting with 'media/...'."""
        if image:
            return f"media/{image.name}"
        return None