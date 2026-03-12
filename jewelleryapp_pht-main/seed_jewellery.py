import os
import django

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'jewellery.settings')
django.setup()

from adminapp.models import Category, Product

def seed_data():
    # Clear existing data
    print("Clearing existing products and categories...")
    Product.objects.all().delete()
    Category.objects.all().delete()

    # 1. Necklaces Category & Product
    cat_neck, _ = Category.objects.get_or_create(
        name="Necklaces",
        defaults={
            "subcategories": ["Gold", "Diamond"],
            "icon": "category_icons/neck.png"
        }
    )
    
    Product.objects.create(
        category=cat_neck,
        subcategory="Diamond",
        name="Luxurious Diamond Necklace",
        description="A stunning handcrafted diamond necklace featuring premium 24k gold and brilliant-cut diamonds. Perfect for weddings and grand occasions.",
        price=250000.00,
        stock=10,
        main_image="product_images/neck.png",
        images=["product_images/neck.png"],
        sizes=["Small", "Medium", "Large"],
        weights=["10g", "15g", "20g"]
    )

    # 2. Rings Category & Product
    cat_ring, _ = Category.objects.get_or_create(
        name="Rings",
        defaults={
            "subcategories": ["Engagement", "Wedding"],
            "icon": "category_icons/daimond.png"
        }
    )
    
    Product.objects.create(
        category=cat_ring,
        subcategory="Diamond",
        name="Elegant Diamond Engagement Ring",
        description="This elegant diamond ring is designed to symbolize eternal love. It features a centerpiece diamond with smaller accents on a polished gold band.",
        price=120000.00,
        stock=15,
        main_image="product_images/daimond.png",
        images=["product_images/daimond.png"],
        sizes=["5", "6", "7", "8"],
        weights=["3g", "5g"]
    )

    # 3. Earrings Category & Product
    cat_ear, _ = Category.objects.get_or_create(
        name="Earrings",
        defaults={
            "subcategories": ["Studs", "Hoops"],
            "icon": "category_icons/ears.png"
        }
    )
    
    Product.objects.create(
        category=cat_ear,
        subcategory="Diamond",
        name="Stunning Diamond Earrings",
        description="Sparkle with elegance wearing these stunning diamond earrings. Handcrafted for maximum brilliance and light reflection.",
        price=85000.00,
        stock=20,
        main_image="product_images/ears.png",
        images=["product_images/ears.png"],
        sizes=["Standard"],
        weights=["4g", "6g"]
    )

    print("Successfully seeded Necklaces, Rings, and Earrings!")

if __name__ == "__main__":
    seed_data()
