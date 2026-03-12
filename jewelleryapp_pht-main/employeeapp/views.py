from collections import defaultdict
from django.shortcuts import render
from adminapp.models import *
from rest_framework import status
from rest_framework.response import Response
from rest_framework.permissions import AllowAny
from rest_framework.views import APIView
from rest_framework import status, viewsets
from rest_framework.response import Response
from rest_framework import status, viewsets
from rest_framework.response import Response
from .models import *
from userapp.models import *
from .serializers import *
# Create your views here.


class LoginView(APIView):
    permission_classes = [AllowAny]

    def post(self, request):
        email = request.data.get("email")
        password = request.data.get("password")

        if not email or not password:
            return Response({"error": "Email and password are required"}, status=status.HTTP_400_BAD_REQUEST)

        try:
            employee = Tblemployee.objects.get(email=email)

            if employee.password != password:
                return Response({"error": "Invalid email or password"}, status=status.HTTP_401_UNAUTHORIZED)

            response_data = {
                "message": "Login successful",
                "employee_id": employee.id,
                "name": employee.name,
                "email": employee.email,
                "phone": employee.phone,
            }
            return Response(response_data, status=status.HTTP_200_OK)

        except Tblemployee.DoesNotExist:
            return Response({"error": "Invalid email or password"}, status=status.HTTP_401_UNAUTHORIZED)
        
        
class ViewEmployeeProfileView(viewsets.ReadOnlyModelViewSet):
    queryset = Tblemployee.objects.all()
    serializer_class = EmployeeSerializer

    def list(self, request, *args, **kwargs):
        employee_id = request.query_params.get("id")  # Get user id from query parameters

        if employee_id:
            try:
                user = self.queryset.get(id=employee_id)
                serializer = self.get_serializer(user)
                return Response(serializer.data, status=status.HTTP_200_OK)
            except Tblemployee.DoesNotExist:
                return Response({"detail": "Employee not found."}, status=status.HTTP_404_NOT_FOUND)
        else:
            # No user_id provided, return all users (if required)
            return super().list(request, *args, **kwargs)

# class EmployeeAssignedBookingsView(APIView):
#     def get(self, request, *args, **kwargs):
#         employee_id = request.query_params.get("employee_id")

#         # ✅ Validate employee_id
#         if not employee_id:
#             return Response(
#                 {"error": "Employee ID is required"},
#                 status=status.HTTP_400_BAD_REQUEST,
#             )

#         # ✅ Fetch assigned Cart Bookings for the employee
#         cart_bookings = Cart.objects.filter(
#             assigned_employee_id=employee_id,
#             status__in=["paid", "assigned", "completed"],
#         ).select_related("user", "product").order_by("-created_at")

#         # ✅ Fetch assigned ProductBookings for the employee
#         product_bookings = ProductBookings.objects.filter(
#             assigned_employee_id=employee_id,
#             status__in=["paid", "assigned", "completed"],
#         ).select_related("user", "product").order_by("-booking_date")

#         # ✅ Group data by user
#         grouped_data = defaultdict(lambda: {"user_details": {}, "assigned_bookings": []})

#         # ✅ Serialize Cart Bookings
#         for cart in cart_bookings:
#             cart_checkout = CartCheckout.objects.filter(booking=cart).first()
#             user_id = cart.user.id

#             # ✅ Add user details if not already added
#             if not grouped_data[user_id]["user_details"]:
#                 grouped_data[user_id]["user_details"] = {
#                     "name": cart.user.name,
#                     "phone_number": cart.user.phone_number,
#                     "email": cart.user.email,
#                     "address": cart.user.address,
#                 }

#             # ✅ Add Cart Booking to assigned_bookings
#             grouped_data[user_id]["assigned_bookings"].append({
#                 "id": cart.id,
#                 "product_name": cart.product.name,
#                 "product_image":cart.product.main_image,
#                 "size": cart.size,
#                 "weight": cart.weight,
#                 "quantity": cart.quantity,
#                 "total_price": cart.total_price,
#                 "advance_fee": cart.advance_fee,
#                 "status": cart.status,
#                 "booking_date": cart.created_at,
#                 "visit_date": cart_checkout.visit_date if cart_checkout else None,
#                 "source": "Cart",
#             })

#         # ✅ Serialize Product Bookings
#         for booking in product_bookings:
#             checkout_info = Checkout.objects.filter(booking=booking).first()
#             user_id = booking.user.id

#             # ✅ Add user details if not already added
#             if not grouped_data[user_id]["user_details"]:
#                 grouped_data[user_id]["user_details"] = {
#                     "name": booking.user.name,
#                     "phone_number": booking.user.phone_number,
#                     "email": booking.user.email,
#                     "address": booking.user.address,
#                 }

#             # ✅ Add Product Booking to assigned_bookings
#             grouped_data[user_id]["assigned_bookings"].append({
#                 "id": booking.id,
#                 "product_name": booking.product.name,
#                 "product_image":booking.product.main_image,
#                 "size": booking.size,
#                 "weight": booking.weight,
#                 "quantity": booking.quantity,
#                 "total_price": booking.total_price,
#                 "advance_fee": booking.advance_fee,
#                 "status": booking.status,
#                 "booking_date": booking.booking_date,
#                 "visit_date": checkout_info.visit_date if checkout_info else None,
#                 "source": "ProductBookings",
#             })

#         # ✅ Prepare final response
#         final_data = []
#         for user_id, data in grouped_data.items():
#             # ✅ Sort assigned bookings by booking date (most recent first)
#             data["assigned_bookings"] = sorted(
#                 data["assigned_bookings"], key=lambda x: x["booking_date"], reverse=True
#             )
#             final_data.append(data)

#         # ✅ If no data, return empty response
#         if not final_data:
#             return Response(
#                 {"message": "No assigned bookings found for this employee."},
#                 status=status.HTTP_200_OK,
#             )

#         # ✅ Return response with grouped bookings
#         return Response(final_data, status=status.HTTP_200_OK)

class EmployeeAssignedBookingsView(APIView):
    def get(self, request, *args, **kwargs):
        employee_id = request.query_params.get("employee_id")

        # ✅ Validate employee_id
        if not employee_id:
            return Response(
                {"error": "Employee ID is required"},
                status=status.HTTP_400_BAD_REQUEST,
            )

        # ✅ Fetch assigned Cart Bookings for the employee
        cart_bookings = Cart.objects.filter(
            assigned_employee_id=employee_id,
            status__in=["paid", "assigned", "completed"],
        ).select_related("user", "product").order_by("-created_at")

        # ✅ Fetch assigned ProductBookings for the employee
        product_bookings = ProductBookings.objects.filter(
            assigned_employee_id=employee_id,
            status__in=["paid", "assigned", "completed"],
        ).select_related("user", "product").order_by("-booking_date")

        # ✅ Group data by user
        grouped_data = defaultdict(lambda: {"user_details": {}, "assigned_bookings": []})

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

            # ✅ Add Cart Booking to assigned_bookings
            grouped_data[user_id]["assigned_bookings"].append({
                "id": cart.id,
                "product_name": cart.product.name,
                "product_image": self.get_image_url(request, cart.product.main_image),
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

            # ✅ Add Product Booking to assigned_bookings
            grouped_data[user_id]["assigned_bookings"].append({
                "id": booking.id,
                "product_name": booking.product.name,
                "product_image": self.get_image_url(request, booking.product.main_image),
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
            # ✅ Sort assigned bookings by booking date (most recent first)
            data["assigned_bookings"] = sorted(
                data["assigned_bookings"], key=lambda x: x["booking_date"], reverse=True
            )
            final_data.append(data)

        # ✅ If no data, return empty response
        if not final_data:
            return Response(
                {"message": "No assigned bookings found for this employee."},
                status=status.HTTP_200_OK,
            )

        # ✅ Return response with grouped bookings
        return Response(final_data, status=status.HTTP_200_OK)

    def get_image_url(self, request, image):
        """Return relative media path starting with 'media/...'."""
        if image:
            return f"media/{image.name}"
        return None

        
class UpdateUserBookingStatusAPIView(APIView):
    def patch(self, request, *args, **kwargs):
        try:
            # ✅ Get user_id and employee_id from request data
            user_id = request.data.get("user_id")
            employee_id = request.data.get("employee_id")  # ✅ Employee checking the booking

            # ✅ Validate inputs
            if not user_id or not employee_id:
                return Response(
                    {"status": "failed", "message": "User ID and Employee ID are required."},
                    status=status.HTTP_400_BAD_REQUEST,
                )

            # ✅ Get ProductBookings and Cart bookings for the user and assigned employee
            product_bookings = ProductBookings.objects.filter(
                user_id=user_id,
                assigned_employee_id=employee_id,
                status__in=["assigned", "user_meet"],
            )

            cart_bookings = Cart.objects.filter(
                user_id=user_id,
                assigned_employee_id=employee_id,
                status__in=["assigned", "user_meet"],
            )

            # ✅ Check if any bookings exist
            if not product_bookings.exists() and not cart_bookings.exists():
                return Response(
                    {"status": "failed", "message": "No active bookings found to update for this employee."},
                    status=status.HTTP_404_NOT_FOUND,
                )

            # ✅ Determine the next status based on current status
            updated_status = None
            if product_bookings.filter(status="assigned").exists() or cart_bookings.filter(status="assigned").exists():
                updated_status = "user_meet"  # ✅ Move to 'user_meet' from 'assigned'
                product_bookings.filter(status="assigned").update(status=updated_status)
                cart_bookings.filter(status="assigned").update(status=updated_status)

            elif product_bookings.filter(status="user_meet").exists() or cart_bookings.filter(status="user_meet").exists():
                updated_status = "completed"  # ✅ Move to 'completed' from 'user_meet'
                product_bookings.filter(status="user_meet").update(status=updated_status)
                cart_bookings.filter(status="user_meet").update(status=updated_status)

            # ✅ If no valid transition found, return error
            if not updated_status:
                return Response(
                    {"status": "failed", "message": "Invalid status transition. No changes made."},
                    status=status.HTTP_400_BAD_REQUEST,
                )

            # ✅ Serialize updated data
            product_serializer = ViewProductBookingSerializer(product_bookings, many=True)
            cart_serializer = ViewCartSerializer(cart_bookings, many=True)

            return Response(
                {
                    "status": "success",
                    "message": f"Status updated to '{updated_status}' for all user bookings by the assigned employee.",
                    "product_bookings": product_serializer.data,
                    "cart_bookings": cart_serializer.data,
                },
                status=status.HTTP_200_OK,
            )

        except Exception as e:
            return Response(
                {
                    "status": "failed",
                    "message": "An error occurred while updating booking status.",
                    "error": str(e),
                },
                status=status.HTTP_500_INTERNAL_SERVER_ERROR,
            )
            

# class EmployeeBookingHistoryView(APIView):
#     def get(self, request, *args, **kwargs):
#         # Get employee_id from query params
#         employee_id = request.query_params.get("employee_id")

#         if not employee_id:
#             return Response({"error": "Employee ID is required"}, status=status.HTTP_400_BAD_REQUEST)

#         # ✅ Filter completed and full paid ProductBookings
#         product_bookings = ProductBookings.objects.filter(
#             assigned_employee_id=employee_id,
#             status__in=["completed", "full paid"]
#         ).order_by("-booking_date")

#         # ✅ Filter completed and full paid Cart Bookings
#         cart_bookings = Cart.objects.filter(
#             assigned_employee_id=employee_id,
#             status__in=["completed", "full paid"]
#         ).order_by("-created_at")

#         # ✅ Serialize the data
#         product_data = BookingHistorySerializer(product_bookings, many=True).data
#         cart_data = CartHistorySerializer(cart_bookings, many=True).data

#         # ✅ Return response with both sets of data
#         return Response(
#             {
#                 "status": "success",
#                 "product_bookings": product_data,
#                 "cart_bookings": cart_data,
#             },
#             status=status.HTTP_200_OK,
#         )
        


class EmployeeBookingHistoryView(APIView):
    def get(self, request, *args, **kwargs):
        # ✅ Get employee_id from query params
        employee_id = request.query_params.get("employee_id")

        if not employee_id:
            return Response({"error": "Employee ID is required"}, status=status.HTTP_400_BAD_REQUEST)

        # ✅ Filter completed and full paid ProductBookings
        product_bookings = ProductBookings.objects.filter(
            assigned_employee_id=employee_id,
            status__in=["completed", "full paid"]
        ).order_by("-booking_date")

        # ✅ Filter completed and full paid Cart Bookings
        cart_bookings = Cart.objects.filter(
            assigned_employee_id=employee_id,
            status__in=["completed", "full paid"]
        ).order_by("-created_at")

        # ✅ Serialize the data
        product_data = BookingHistorySerializer(product_bookings, many=True).data
        cart_data = CartHistorySerializer(cart_bookings, many=True).data

        # ✅ Add booking_type and flatten user details
        for item in product_data:
            item["booking_type"] = "product"  # Label for product bookings
            item["username"] = item["user"]["name"]
            item["phone_number"] = item["user"]["phone_number"]
            item["email"] = item["user"]["email"]
            item["address"] = item["user"]["address"]
            del item["user"]  # Remove the nested user object

        for item in cart_data:
            item["booking_type"] = "cart"  # Label for cart bookings
            item["username"] = item["user"]["name"]
            item["phone_number"] = item["user"]["phone_number"]
            item["email"] = item["user"]["email"]
            item["address"] = item["user"]["address"]
            del item["user"]  # Remove the nested user object

        # ✅ Combine and sort by date
        combined_data = sorted(
            product_data + cart_data,
            key=lambda x: x.get("booking_date") or x.get("created_at", ""),
            reverse=True,
        )

        # ✅ Return unified response
        return Response(combined_data, status=status.HTTP_200_OK)
