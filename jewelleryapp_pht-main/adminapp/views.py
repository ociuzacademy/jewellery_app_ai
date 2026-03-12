import os
from django.shortcuts import render,redirect,get_object_or_404
from userapp.models import *
from django.db.models import Sum, Count
from datetime import datetime, timedelta
# Create your views here.

def admin_index(request):
    if not request.session.get("admin_logged_in"):
        return redirect("admin_login")  # Redirect if not logged in
    
    return render(request, "admin_index.html")

from django.shortcuts import render, redirect
from django.contrib import messages

def admin_logout(request):
    request.session.flush()  # Clear session
    messages.success(request, "You have been logged out.")
    return redirect("admin_login")



from django.shortcuts import render, redirect
from django.contrib import messages
from adminapp.models import *

def admin_login(request):
    if request.method == "POST":
        email = request.POST.get("email")
        password = request.POST.get("password")

        # Check if the email and password match the admin credentials
        if email == "admin@gmail.com" and password == "admin":
            request.session["admin_logged_in"] = True  # Store login session
            messages.success(request, "Login successful!")
            return redirect("admin_index")  # Redirect to admin dashboard

        else:
            messages.error(request, "Invalid email or password. Please try again.")
    
    return render(request, "admin_login.html")  # Render login page




from django.shortcuts import render, redirect
from .models import Category
from django.shortcuts import render, redirect
from .models import Category

def add_category(request):
    if request.method == "POST":
        name = request.POST.get('name')
        subcategories = request.POST.get('subcategories', '').split(',')
        subcategories = [sub.strip() for sub in subcategories if sub.strip()]
        icon = request.FILES.get('icon')

        Category.objects.create(
            name=name,
            subcategories=subcategories,
            icon=icon
        )
        return redirect('category_list')

    return render(request, 'add_category.html')
from django.shortcuts import render
from .models import Category

def category_list(request):
    categories = Category.objects.all()
    return render(request, 'category_list.html', {'categories': categories})





from django.shortcuts import render
from .models import Product
from django.conf import settings

# def product_list(request):
#     products = Product.objects.all()
#     return render(request, 'product_list.html', {'products': products, 'MEDIA_URL': settings.MEDIA_URL})
from django.core.files.storage import default_storage

def add_product(request):
    categories = Category.objects.all()

    if request.method == "POST":
        category = Category.objects.get(id=request.POST['category'])
        subcategory = request.POST['subcategory']
        name = request.POST['name']
        description = request.POST['description']
        price = request.POST['price']
        stock = request.POST['stock']

        main_image = request.FILES.get('main_image')  # Get the main image

        # Handling multiple images
        images = []
        for img in request.FILES.getlist('product_images'):
            img_path = default_storage.save(f"product_images/{img.name}", img)
            images.append(img_path)  # Save actual storage path

        # Handling sizes and weights
        sizes = request.POST.get('sizes', '').split(',')
        sizes = [size.strip() for size in sizes if size.strip()]

        weights = request.POST.get('weights', '').split(',')
        weights = [str(weight.strip()) for weight in weights if weight.strip()]  # Convert all to string

        # Create product
        product = Product.objects.create(
            category=category, 
            subcategory=subcategory, 
            name=name,
            description=description, 
            price=price, 
            stock=stock,
            main_image=main_image,  # Save the main image
            images=images, 
            sizes=sizes, 
            weights=weights  # Ensuring all weights are stored as strings
        )

        return redirect('view_products')

    return render(request, 'add_product.html', {'categories': categories})


def add_employee(request):
    if request.method == "POST":
        name = request.POST.get("name")
        email = request.POST.get("email")
        password = request.POST.get("password")
        phone = request.POST.get("phone")
        position = request.POST.get("position", "")
        address = request.POST.get("address", "")

        # Check if email already exists
        if Tblemployee.objects.filter(email=email).exists():
            messages.error(request, "Email already exists!")
            return redirect("add_employee")

        # Handle Image Upload
        photo = request.FILES.get("photo")

        # Save Employee
        employee = Tblemployee.objects.create(
            name=name,
            email=email,
            password=password,  # Hash password
            phone=phone,
            position=position,
            address=address,
            photo=photo,
        )

        messages.success(request, "Employee added successfully!")
        return redirect("add_employee")

    return render(request, "add_employee.html")

def view_employee(request):
    employees = Tblemployee.objects.all()
    return render(request, 'view_employee.html', {'employees': employees})  


def edit_employee(request):
    employee_id=request.GET.get('id')
    employee = get_object_or_404(Tblemployee, id=employee_id)

    if request.method == 'POST':
        name = request.POST.get('name')
        email = request.POST.get('email')
        phone = request.POST.get('phone')
        password = request.POST.get('password')

        employee.name = name
        employee.email = email
        employee.phone = phone

        # Directly save password as plain text (⚠️ Not recommended for production)
        if password.strip():
            employee.password = password  

        employee.save()

        messages.success(request, 'Employee updated successfully!')
        return redirect('view_employee')

    return render(request, 'edit_employee.html', {'employee': employee})

def delete_employee(request):
    employee_id=request.GET.get('id')
    employee = get_object_or_404(Tblemployee, id=employee_id)
    employee.delete()
    messages.success(request, 'Employee deleted successfully!')
    return redirect('view_employee')


def edit_product(request):
    product_id=request.GET.get('id')
    product = get_object_or_404(Product, id=product_id)
    categories = Category.objects.all()

    if request.method == 'POST':
        product.category_id = request.POST['category']
        product.subcategory = request.POST['subcategory']
        product.name = request.POST['name']
        product.description = request.POST['description']
        product.price = request.POST['price']
        product.stock = request.POST['stock']

        # Handle main image
        if 'main_image' in request.FILES:
            product.main_image = request.FILES['main_image']

        # Handle additional images
        if 'images' in request.FILES:
            uploaded_images = request.FILES.getlist('images')  # Get multiple images
            image_paths = []

            for image in uploaded_images:
                # Save image to media directory
                image_path = os.path.join('product_images', image.name)
                full_path = os.path.join(settings.MEDIA_ROOT, image_path)

                # Write file to the storage
                with open(full_path, 'wb+') as destination:
                    for chunk in image.chunks():
                        destination.write(chunk)

                # Store only the relative path in JSONField
                image_paths.append(image_path)

            # Save paths in JSON field
            product.images = image_paths  # Save URLs in JSONField
        # Handle sizes and weights
        product.sizes = request.POST['sizes'].split(',')
        product.weights = request.POST['weights'].split(',')

        product.save()
        return redirect('product_list')  # Redirect back to the product list page

    return render(request, 'edit_products.html', {'product': product, 'categories': categories,'MEDIA_URL': settings.MEDIA_URL})

def delete_product(request):
    product_id=request.GET.get('id')
    product = get_object_or_404(Product, id=product_id)
    product.delete()
    messages.success(request, 'Employee deleted successfully!')
    return redirect('view_products')

def admin_assign_orders(request):
    # Get all "Paid" orders from Cart and ProductBookings
    paid_bookings = ProductBookings.objects.filter(status="paid")
    paid_carts = Cart.objects.filter(status="paid")

    # Get all employees
    employees = Tblemployee.objects.all()

    # Attach visit_date and visit_time for ProductBookings
    for booking in paid_bookings:
        checkout = Checkout.objects.filter(booking=booking).first()
        booking.visit_date = checkout.visit_date if checkout else None
        booking.visit_time = checkout.visit_time if checkout else None

    # Attach visit_date and visit_time for Cart
    for cart in paid_carts:
        cart_checkout = CartCheckout.objects.filter(booking=cart).first()
        cart.visit_date = cart_checkout.visit_date if cart_checkout else None
        cart.visit_time = cart_checkout.visit_time if cart_checkout else None

    if request.method == "POST":
        order_type = request.POST.get("order_type")  # cart or booking
        order_id = request.POST.get("order_id")
        employee_id = request.POST.get("employee_id")

        employee = get_object_or_404(Tblemployee, id=employee_id)

        if order_type == "cart":
            order = get_object_or_404(Cart, id=order_id)
        else:
            order = get_object_or_404(ProductBookings, id=order_id)

        # Assign employee and update status
        order.assigned_employee = employee
        order.status = "assigned"
        order.save()

        messages.success(
            request, f"Order {order.id} ({order_type}) assigned to {employee.name}"
        )
        return redirect("assign_orders")

    return render(
        request,
        "assign_orders.html",
        {"paid_bookings": paid_bookings, "paid_carts": paid_carts, "employees": employees},
    )

def view_users(request):
    users = TblRegister.objects.all()
    return render(request, "view_users.html", {"users": users})

def approve_user(request):
    user_id = request.GET.get('id')
    if user_id:
        user = TblRegister.objects.get(id=user_id)
        user.status = "approved"
        user.save()
        messages.success(request, f"TblRegister {user.name} has been successfully approved!")
    else:
        messages.error(request, "Invalid service provider ID.")
    return redirect('view_users')

def block_user(request):
    user_id = request.GET.get('id')
    if user_id:
        user = TblRegister.objects.get(id=user_id)
        user.status = "blocked"
        user.save()
        messages.success(request, f"TblRegister {user.name} has been successfully rejected.")
    else:
        messages.error(request, "Invalid service provider ID.")
    return redirect('view_users')


def admin_booking_list(request):
    product_bookings = ProductBookings.objects.filter(status__in=["completed"])
    cart_bookings = Cart.objects.filter(status__in=["completed"])

    # ✅ Pass data to the template
    return render(
        request,
        "admin_booking_list.html",
        {"product_bookings": product_bookings, "cart_bookings": cart_bookings},
    )
    
def admin_update_payment_status(request, booking_type, booking_id):
    # ✅ Check if the booking type is valid (either product or cart)
    if booking_type not in ["product", "cart"]:
        messages.error(request, "Invalid booking type provided.")
        return redirect("admin_booking_list")

    # ✅ Get the main booking based on booking_type
    if booking_type == "product":
        main_booking = get_object_or_404(ProductBookings, id=booking_id, status="completed")
    elif booking_type == "cart":
        main_booking = get_object_or_404(Cart, id=booking_id, status="completed")

    # ✅ Get user and employee from the selected booking
    user_id = main_booking.user_id
    employee_id = main_booking.assigned_employee_id

    # ✅ Get all related ProductBookings with same user and employee
    product_bookings = ProductBookings.objects.filter(
        user_id=user_id,
        assigned_employee_id=employee_id,
        status="completed",
    )

    # ✅ Get all related Cart bookings with same user and employee
    cart_bookings = Cart.objects.filter(
        user_id=user_id,
        assigned_employee_id=employee_id,
        status="completed",
    )

    # ✅ Check if bookings exist to update
    if not product_bookings.exists() and not cart_bookings.exists():
        messages.warning(request, "No completed bookings found for this user and employee.")
        return redirect("admin_booking_list")

    # ✅ Update status to 'full paid' for all related bookings
    product_bookings.update(status="full paid")
    cart_bookings.update(status="full paid")

    # ✅ Success message
    messages.success(
        request,
        f"All related bookings for User {main_booking.user.name} and Employee {main_booking.assigned_employee.name} are marked as Full Paid.",
    )
    return redirect("admin_booking_list")


def admin_full_paid_bookings(request):
    # ✅ Get all product and cart bookings with status = 'full paid'
    product_bookings = ProductBookings.objects.filter(status="full paid").select_related(
        "user", "product", "assigned_employee"
    )
    cart_bookings = Cart.objects.filter(status="full paid").select_related(
        "user", "product", "assigned_employee"
    )

    # ✅ Render full paid bookings page
    return render(
        request,
        "admin_full_paid_bookings.html",
        {"product_bookings": product_bookings, "cart_bookings": cart_bookings},
    )
    
def view_feedback(request):
    """View to display all user feedback to the admin"""
    feedbacks = Feedback.objects.all().order_by('-created_at')
    context = {"feedbacks": feedbacks}
    return render(request, "view_feedback.html", context)

def products(request):
    products = Product.objects.all()
    return render(request, 'view_products.html', {'products': products})


