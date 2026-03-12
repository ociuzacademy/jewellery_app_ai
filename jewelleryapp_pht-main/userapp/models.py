from django.db import models

# Create your models here.
from django.db import models

from django.db import models
from adminapp.models import *
from django.core.validators import MaxValueValidator, MinValueValidator

class TblRegister(models.Model):
    STATUS_CHOICES = [
        ("approved", "Approved"),
        ("blocked", "Blocked"),
    ]

    name = models.CharField(max_length=255)
    email = models.EmailField()
    password = models.CharField(max_length=255)
    phone_number = models.CharField(max_length=15, null=True, blank=True)
    address = models.TextField(null=True, blank=True)
    profile = models.ImageField(upload_to="profiles/", null=True, blank=True)
    status = models.CharField(max_length=10, choices=STATUS_CHOICES, default="approved")  # Added status field

    def __str__(self):
        return self.name

class Feedback(models.Model):
    user = models.ForeignKey(TblRegister, on_delete=models.CASCADE)
    feedback_text = models.TextField()
    rating = models.PositiveIntegerField(default=1, validators=[MaxValueValidator(5), MinValueValidator(1)])
    created_at = models.DateTimeField(auto_now_add=True)


class ProductBookings(models.Model):
    STATUS_CHOICES = [
        ("pending", "Pending"),
        ("paid", "Paid"),
        ("assigned", "Assigned"),
        ("completed", "Completed"),
        ("user_meet", "User Met"),
        ("make_payment", "Payment Made"),
        ("user_leave", "User Left from Shop"),
    ]

    user = models.ForeignKey(TblRegister, on_delete=models.CASCADE)
    product = models.ForeignKey(Product, on_delete=models.CASCADE)
    size = models.CharField(max_length=50)
    weight = models.CharField(max_length=50)
    quantity = models.PositiveIntegerField(default=1)
    total_price = models.DecimalField(max_digits=10, decimal_places=2,default=0.00)
    advance_fee = models.DecimalField(max_digits=10, decimal_places=2, default=0.00)
    status= models.CharField(max_length=100,default='pending')
    booking_date = models.DateTimeField(auto_now_add=True)
    assigned_employee = models.ForeignKey(Tblemployee,on_delete=models.SET_NULL,null=True,blank=True,related_name="assigned_bookings")

    def __str__(self):
        return f"Booking - {self.product.name} by {self.user.username}"


class Checkout(models.Model):
    user= models.ForeignKey(TblRegister,on_delete=models.CASCADE)
    booking = models.ForeignKey(ProductBookings, on_delete=models.CASCADE)
    advance_fee = models.DecimalField(max_digits=10, decimal_places=2, default=0.00)
    visit_date = models.DateField()
    visit_time = models.TimeField()
    created_at = models.DateTimeField(auto_now_add=True)
    
class Cart(models.Model):
    STATUS_CHOICES = [
        ("pending", "Pending"),
        ("paid", "Paid"),
        ("assigned", "Assigned"),
        ("completed", "Completed"),
        ("user_meet", "User Met"),
        ("full paid", "Full Paid"),
    ]

    user = models.ForeignKey(TblRegister,on_delete=models.CASCADE)
    product = models.ForeignKey(Product,on_delete=models.CASCADE)
    quantity = models.PositiveIntegerField(default=1)
    size = models.CharField(max_length=50)
    weight = models.CharField(max_length=50)
    total_price = models.DecimalField(max_digits=10, decimal_places=2,default=0.00)
    advance_fee = models.DecimalField(max_digits=10, decimal_places=2, default=0.00)
    status= models.CharField(max_length=100,default='pending')
    created_at = models.DateTimeField(auto_now_add=True)
    assigned_employee = models.ForeignKey(Tblemployee,on_delete=models.SET_NULL,null=True,blank=True,related_name="assigned_carts",
    )
    
    
class CartCheckout(models.Model):
    user= models.ForeignKey(TblRegister,on_delete=models.CASCADE)
    booking = models.ForeignKey(Cart, on_delete=models.CASCADE)
    advance_fee = models.DecimalField(max_digits=10, decimal_places=2, default=0.00)
    visit_date = models.DateField()
    visit_time = models.TimeField()
    created_at = models.DateTimeField(auto_now_add=True)
    

class Wishlist(models.Model):
    user = models.ForeignKey(TblRegister, on_delete=models.CASCADE)
    product = models.ForeignKey(Product, on_delete=models.CASCADE)
    quantity = models.PositiveIntegerField(default=1)
    size = models.CharField(max_length=50)
    weight = models.CharField(max_length=50)
    created_at = models.DateTimeField(auto_now_add=True)
    
class Upi(models.Model):
    booking = models.OneToOneField(ProductBookings, on_delete=models.CASCADE, related_name="upi")
    status = models.CharField(max_length=20, default="success")
    upi_id = models.CharField(max_length=100)

    def _str_(self):
        return f"UPI Payment for Booking {self.booking.id} - {self.status}"

class Card(models.Model):
    booking = models.OneToOneField(ProductBookings, on_delete=models.CASCADE, related_name="card")
    status = models.CharField(max_length=20, default="success")
    card_holder_name = models.CharField(max_length=100)
    card_number = models.CharField(max_length=16)
    expiry_date = models.CharField(max_length=7)  
    cvv = models.CharField(max_length=4)

    def _str_(self):
        return f"Card Payment for Booking {self.booking.id} - {self.status}"
    

class CartUpi(models.Model):
    user = models.ForeignKey(TblRegister, on_delete=models.CASCADE, related_name="upi_payments")
    status = models.CharField(max_length=20, default="success")
    upi_id = models.CharField(max_length=100)

    def _str_(self):
        return f"UPI Payment for Booking {self.booking.id} - {self.status}"

class CartCard(models.Model):
    user = models.ForeignKey(TblRegister, on_delete=models.CASCADE, related_name="card_payments")
    status = models.CharField(max_length=20, default="success")
    card_holder_name = models.CharField(max_length=100)
    card_number = models.CharField(max_length=16)
    expiry_date = models.CharField(max_length=7)  
    cvv = models.CharField(max_length=4)

    def _str_(self):
        return f"Card Payment for Booking {self.booking.id} - {self.status}"