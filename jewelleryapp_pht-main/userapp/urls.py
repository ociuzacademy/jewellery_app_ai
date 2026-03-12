from rest_framework import permissions
from drf_yasg.views import get_schema_view
from drf_yasg import openapi
from django.urls import path, include
# from .views import RegisterViewSet,LoginView,CategoryViewSet
from rest_framework.routers import SimpleRouter
from .views import*

schema_view = get_schema_view(
    openapi.Info(
        title="User Registration API",
        default_version="v1",
        description="API for user registration",
        contact=openapi.Contact(email="contact@example.com"),
    ),
    public=True,
    permission_classes=(permissions.AllowAny,),
)

router = SimpleRouter()
router.register(r"register", RegisterViewSet, basename="register"),
router.register(r'products', ViewProductsView, basename='products')
router.register(r'book_products', ProductBookingView, basename='book_products')
router.register(r'cart_products', CartView, basename='cart_products')
router.register(r'checkout', CheckoutView, basename='checkout')
router.register(r'cart_checkout', CartCheckoutView, basename='cart_checkout')
router.register(r'submit_feedback', FeedbackView, basename='submit_feedback')
router.register(r'payments', PaymentListViewSet, basename='payments')     
router.register(r'add_wishlist',AddToWishlistView, basename='add_wishlist')
router.register(r'wishlist_to_cart', AddWishlistToCartView, basename='wishlist_to_cart')     
# router.register(r'view_wishlist',ViewWishlistView, basename='view_wishlist')     
router.register(r'cart_booking_summary', CartSummaryView, basename='cart_booking_summary') 
router.register(r'upi_payment', UpiPaymentView, basename='upi_payment') 
router.register(r'card_payment', CardPaymentView, basename='card_payment') 
router.register(r'cart_upi_payment',CartUpiPaymentView,basename='cart_upi_payment')
router.register(r'cart_card_payment',CartCardPaymentView,basename='cart_card_payment')

urlpatterns = [
    path("", include(router.urls)),
    path("swagger/", schema_view.with_ui("swagger", cache_timeout=0), name="schema-swagger-ui"),
    path("redoc/", schema_view.with_ui("redoc", cache_timeout=0), name="schema-redoc"),
    path("login/", LoginView.as_view(), name="login"),
    # path("view_product/", ViewProductsView.as_view({'get':'list'}), name="view_product"),
    path('user_category_list/', user_category_list, name='user_category_list'),
    path('products/subcategory/', ProductBySubcategoryView.as_view(), name='products-by-subcategory'),
    path('view_user_profile/',ViewUserProfileView.as_view({'get':'list'}),name='view_user_profile'),
    path('view_cart/', ViewCartItems.as_view(), name='view_cart'),
    path('view_wishlist/', WishlistView.as_view({'get':'list'}), name='view_wishlist'),
    path('remove_cart_items/', RemoveCartView.as_view(), name='remove_cart_items'),
    path('remove_wishlist_items/',RemoveWishlistView.as_view(),name='remove_wishlist_items'),
    path("booking_history/", CombinedBookingHistoryView.as_view(), name="booking_history"),
]
