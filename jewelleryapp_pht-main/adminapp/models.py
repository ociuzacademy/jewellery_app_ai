from django.db import models
from decimal import Decimal

# Create your models here.
class tbl_admin(models.Model):
    email = models.EmailField(max_length=100, unique=True)
    password = models.CharField(max_length=100)

    def __str__(self):
        return self.email

from django.db import models
from django.db import models
from django.db import models

class Category(models.Model):
    name = models.CharField(max_length=255)
    subcategories = models.JSONField(default=list)  # Store multiple subcategories as a list
    icon = models.ImageField(upload_to='category_icons/', null=True, blank=True)

    def __str__(self):
        return self.name

from django.db import models

class Product(models.Model):
    category = models.ForeignKey('Category', on_delete=models.CASCADE, related_name='products')
    subcategory = models.CharField(max_length=255)  # Store subcategory as text
    name = models.CharField(max_length=255)
    description = models.TextField()
    price = models.DecimalField(max_digits=10, decimal_places=2)
    stock = models.PositiveIntegerField()
    main_image = models.ImageField(upload_to='product_images/')  # Main image
    images = models.JSONField(default=list)  # Store multiple images as a list
    sizes = models.JSONField(default=list)  # Store multiple sizes as a list
    weights = models.JSONField(default=list)  # Store multiple weights as a list

    def __str__(self):
        return f"{self.name} ({self.category.name})"



class Tblemployee(models.Model):
    name = models.CharField(max_length=100)
    email = models.EmailField()  # Prevent duplicate emails
    password = models.CharField(max_length=128)  # Increased length for hashed passwords
    phone = models.CharField(max_length=15, null=True, blank=True)
    position = models.CharField(max_length=100, blank=True)  # Made optional
    address = models.CharField(max_length=200, blank=True)  # Increased length & made optional
    photo = models.ImageField(upload_to='employee_image/', null=True, blank=True)  # Optional photo
    date_joined = models.DateField(auto_now_add=True)