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
  

urlpatterns = [
    path("", include(router.urls)),
    path("swagger/", schema_view.with_ui("swagger", cache_timeout=0), name="schema-swagger-ui"),
    path("redoc/", schema_view.with_ui("redoc", cache_timeout=0), name="schema-redoc"),
    # path("view_product/", ViewProductsView.as_view({'get':'list'}), name="view_product"),
    path("login/", LoginView.as_view(), name="login"),
    path('view_employee_profile/',ViewEmployeeProfileView.as_view({'get':'list'}),name='view_employee_profile'),
    path("assigned_bookings/", EmployeeAssignedBookingsView.as_view(), name="assigned_bookings"),
    path("update_user_booking_status/", UpdateUserBookingStatusAPIView.as_view(), name="update_user_booking_status"),
    path("employee_booking_history/", EmployeeBookingHistoryView.as_view(), name="employee_booking_history"),
]
