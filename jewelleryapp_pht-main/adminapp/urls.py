from django.urls import path
from . import views 
from adminapp.views import *
urlpatterns = [
    path('admin_index/', views.admin_index, name='admin_index'), 
    path('',views.admin_login,name='admin_login'),
    path("logout/", views.admin_logout, name="admin_logout"),
    path('add-category/', add_category, name='add_category'),
    path('category-list/', category_list, name='category_list'),
    path('add-product/', add_product, name='add_product'),
    # path('products/', product_list, name='product_list'),
    path('add_employee/', views.add_employee, name='add_employee'),
    path('view_employee/', views.view_employee, name='view_employee'),
    path('edit_employee/', views.edit_employee, name='edit_employee'),
    path('delete_employee/', views.delete_employee, name='delete_employee'),
    path('delete_product/', views.delete_product, name='delete_product'),
    path('edit_products/', views.edit_product, name='edit_products'),
    path("assign-orders/", views.admin_assign_orders, name="assign_orders"),
    path("view_users/", views.view_users, name="view_users"),
    path("approve_user/", views.approve_user, name="approve_user"),
    path("block_user/", views.block_user, name="block_user"),
    path("admin/bookings/", admin_booking_list, name="admin_booking_list"),
    path("admin/update-payment/<str:booking_type>/<int:booking_id>/",admin_update_payment_status,name="admin_update_payment_status"),
    path("admin/full-paid-bookings/", admin_full_paid_bookings, name="admin_full_paid_bookings"),
    path("view-feedback/", view_feedback, name="view_feedback"),
    path('view_products/',views.products,name='view_products'),
]
