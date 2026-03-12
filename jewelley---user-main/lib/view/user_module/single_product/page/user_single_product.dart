import 'package:flutter/material.dart';
import 'package:jewellery_app/view/constants/urls.dart';
import 'package:jewellery_app/view/user_module/single_product/service/wishlist_service.dart';
import 'package:jewellery_app/view/user_module/view_cart/page/user_cart_screen.dart';
import 'package:jewellery_app/view/user_module/checkout_screen/page/user_checkout_page.dart';
import 'package:jewellery_app/view/user_module/single_product/service/cart_service.dart';
import 'package:jewellery_app/view/user_module/single_product/service/respones_single_service.dart';
import 'package:jewellery_app/view/user_module/single_product/service/single_product_service.dart';
import 'package:jewellery_app/view/user_module/wishlist/page/whislist_page.dart';
import 'package:camera/camera.dart';
import 'package:jewellery_app/view/user_module/single_product/page/native_try_on_screen.dart';
import 'package:jewellery_app/view/user_module/single_product/model/single_product_model.dart';

class JewelryProductPage extends StatefulWidget {
  final String productId;
  const JewelryProductPage({
    super.key,
    required this.productId,
  });

  @override
  _JewelryProductPageState createState() => _JewelryProductPageState();
}

class _JewelryProductPageState extends State<JewelryProductPage>
    with AutomaticKeepAliveClientMixin {
  String? selectedSize;
  String? selectedWeight;
  int quantity = 1;
  final TextEditingController _quantityController = TextEditingController();
  Future<dynamic>? _future;
  bool isWishlisted = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _quantityController.text = quantity.toString();
    _future = singleProductService(product_id: widget.productId);
  }

  bool _validateSelection() {
    if (selectedSize == null || selectedWeight == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Please select size and weight before proceeding.")),
      );
      return false;
    }
    return true;
  }

  void validateAndBook(int stock) {
    if (!_validateSelection() || quantity <= 0 || quantity > stock) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Please select valid options before booking.")),
      );
      return;
    }
    _buyProduct();
  }

  Future<void> _buyProduct() async {
    try {
      final responseMessage = await buyProductService(
        product_id: widget.productId,
        quantity: quantity.toString(),
        size: selectedSize.toString(),
        weight: selectedWeight.toString(),
      );

      if (responseMessage.status == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product Booked')),
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CheckoutScreen(
              booking_id: responseMessage.bookingId.toString(),
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseMessage.message ?? "Unknown error")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Product purchase failed: $e')),
      );
    }
  }

  Future<void> _addToCart() async {
    if (!_validateSelection()) {
      return;
    }

    try {
      final responseMessage = await cartService(
        product_id: widget.productId,
        quantity: quantity.toString(),
        size: selectedSize.toString(),
        weight: selectedWeight.toString(),
      );

      if (responseMessage.status == 'success') {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          builder: (context) {
            return Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Product added to cart',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.04,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const UserCartScreen(),
                        ),
                      );
                    },
                    child: Text(
                      'View Cart',
                      style: TextStyle(
                        color: const Color.fromARGB(255, 93, 7, 87),
                        fontWeight: FontWeight.bold,
                        fontSize: MediaQuery.of(context).size.width * 0.04,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseMessage.message ?? "Unknown error")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Product purchase failed: $e')),
      );
    }
  }

  Future<void> _addToWishlist() async {
    if (!_validateSelection()) {
      return;
    }

    try {
      final responseMessage = await wishlistService(
        product_id: widget.productId,
        size: selectedSize.toString(),
        weight: selectedWeight.toString(),
      );

      if (responseMessage.message == 'Product successfully added to wishlist') {
        setState(() {
          isWishlisted = true;
        });
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          builder: (context) {
            return Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Product added to Wishlist',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.04,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const WishlistPage(),
                        ),
                      );
                    },
                    child: Text(
                      'View Wishlist',
                      style: TextStyle(
                        color: const Color.fromARGB(255, 93, 7, 87),
                        fontWeight: FontWeight.bold,
                        fontSize: MediaQuery.of(context).size.width * 0.04,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseMessage.message ?? "Unknown error")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Wishlist adding process failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final Size screenSize = MediaQuery.of(context).size;
    final bool isPortrait = screenSize.height > screenSize.width;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Jewellery Details",
          style: TextStyle(
            color: Colors.white,
            fontSize: screenSize.width * 0.05,
          ),
        ),
        backgroundColor: Colors.deepPurple,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/noResponse.jpg',
                    width: screenSize.width * 0.6,
                  ),
                  SizedBox(height: screenSize.height * 0.02),
                  Text(
                    "Error: ${snapshot.error}",
                    style: TextStyle(
                      fontSize: screenSize.width * 0.045,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ],
              ),
            );
          }

          if (!snapshot.hasData) {
            return Center(
              child: Text(
                "No service found",
                style: TextStyle(fontSize: screenSize.width * 0.045),
              ),
            );
          }

          final singleitem = snapshot.data;

          return SingleChildScrollView(
            padding: EdgeInsets.all(screenSize.width * 0.04),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: isPortrait ? screenSize.height * 0.35 : screenSize.height * 0.5,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: singleitem!.images!.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: screenSize.width * 0.02
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.network(
                            '${UserUrl.baseUrl}/${singleitem.images![index]}',
                            width: isPortrait ? screenSize.width * 0.8 : screenSize.width * 0.4,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: screenSize.height * 0.02),
                Text(
                  singleitem.name!,
                  style: TextStyle(
                    fontSize: screenSize.width * 0.07,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
                SizedBox(height: screenSize.height * 0.01),
                Text(
                  singleitem.description!,
                  style: TextStyle(
                    fontSize: screenSize.width * 0.04,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: screenSize.height * 0.02),
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    icon: Icon(
                      isWishlisted ? Icons.favorite : Icons.favorite_border,
                      color: isWishlisted ? Colors.red : Colors.grey,
                      size: screenSize.width * 0.08,
                    ),
                    onPressed: _addToWishlist,
                  ),
                ),
                Text(
                  "Select Size",
                  style: TextStyle(
                    fontSize: screenSize.width * 0.05,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: screenSize.height * 0.01),
                Wrap(
                  spacing: screenSize.width * 0.02,
                  runSpacing: screenSize.height * 0.01,
                  children: singleitem.sizes!.map<Widget>((size) {
                    return GestureDetector(
                      onTap: () => setState(() => selectedSize = size),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: screenSize.width * 0.04,
                          vertical: screenSize.height * 0.01,
                        ),
                        decoration: BoxDecoration(
                          color: selectedSize == size
                              ? Colors.deepPurple
                              : Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          size,
                          style: TextStyle(
                            fontSize: screenSize.width * 0.04,
                            color: selectedSize == size
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: screenSize.height * 0.03),
                Text(
                  "Select Weight",
                  style: TextStyle(
                    fontSize: screenSize.width * 0.05,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: screenSize.height * 0.01),
                Wrap(
                  spacing: screenSize.width * 0.02,
                  runSpacing: screenSize.height * 0.01,
                  children: singleitem.weights!.map<Widget>((weight) {
                    return GestureDetector(
                      onTap: () =>
                          setState(() => selectedWeight = weight.toString()),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: screenSize.width * 0.04,
                          vertical: screenSize.height * 0.01,
                        ),
                        decoration: BoxDecoration(
                          color: selectedWeight == weight.toString()
                              ? Colors.deepPurple
                              : Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          weight.toString(),
                          style: TextStyle(
                            fontSize: screenSize.width * 0.04,
                            color: selectedWeight == weight.toString()
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: screenSize.height * 0.04),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Select Quantity",
                      style: TextStyle(
                        fontSize: screenSize.width * 0.05,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: screenSize.height * 0.01),
                    if (singleitem.stock! > 0)
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.remove,
                              size: screenSize.width * 0.06,
                            ),
                            onPressed: quantity > 1
                                ? () => setState(() => quantity--)
                                : null,
                          ),
                          Text(
                            quantity.toString(),
                            style: TextStyle(
                              fontSize: screenSize.width * 0.05,
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.add,
                              size: screenSize.width * 0.06,
                            ),
                            onPressed: quantity < singleitem.stock!
                                ? () => setState(() => quantity++)
                                : null,
                          ),
                          Text(
                            " / ${singleitem.stock!} available",
                            style: TextStyle(
                              fontSize: screenSize.width * 0.04,
                            ),
                          ),
                        ],
                      )
                    else
                      Text(
                        "Out of Stock",
                        style: TextStyle(
                          fontSize: screenSize.width * 0.05,
                          color: Colors.red,
                        ),
                      ),
                    SizedBox(height: screenSize.height * 0.03),
                    Text(
                      "Total Price: \u{20B9}${(double.parse(singleitem.price!) * quantity).toStringAsFixed(2)}",
                      style: TextStyle(
                        fontSize: screenSize.width * 0.06,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                    SizedBox(height: screenSize.height * 0.04),
                    isPortrait
                        ? Column(
                            children: [
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: singleitem.stock! > 0
                                      ? () => validateAndBook(singleitem.stock!)
                                      : null,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.orange,
                                    padding: EdgeInsets.symmetric(
                                      vertical: screenSize.height * 0.02,
                                    ),
                                  ),
                                  child: Text(
                                    "Book Now",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: screenSize.width * 0.045,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: screenSize.height * 0.02),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: _addToCart,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    padding: EdgeInsets.symmetric(
                                      vertical: screenSize.height * 0.02,
                                    ),
                                  ),
                                  child: Text(
                                    "Add to Cart",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: screenSize.width * 0.045,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: singleitem.stock! > 0
                                    ? () => validateAndBook(singleitem.stock!)
                                    : null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: screenSize.width * 0.05,
                                    vertical: screenSize.height * 0.02,
                                  ),
                                ),
                                child: Text(
                                  "Book Now",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: screenSize.width * 0.04,
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: _addToCart,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: screenSize.width * 0.05,
                                    vertical: screenSize.height * 0.02,
                                  ),
                                ),
                                child: Text(
                                  "Add to Cart",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: screenSize.width * 0.04,
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: TryOnButton(
        screenSize: screenSize,
        productFuture: _future,
      ),
    );
  }
}

class TryOnButton extends StatelessWidget {
  final Size screenSize;
  final Future<dynamic>? productFuture;

  const TryOnButton({
    super.key, 
    required this.screenSize,
    required this.productFuture,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () async {
        try {
          // 1. Resolve Product Data
          SingleProductModel? product;
          if (productFuture != null) {
            final data = await productFuture;
            if (data is SingleProductModel) {
              product = data;
            }
          }

          if (product == null) {
             ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Please wait for product to load')),
            );
            return;
          }

          // 2. Open Camera
          final cameras = await availableCameras();
          
          if (context.mounted) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NativeTryOnScreen(
                  cameras: cameras,
                  category: product!.categoryName ?? 'Necklace', // Default to Necklace
                ),
              ),
            );
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to open AR: $e')),
          );
        }
      },
      label: const Text("Try On", style: TextStyle(color: Colors.white)),
      icon: const Icon(Icons.camera_alt, color: Colors.white),
      backgroundColor: Colors.deepPurple,
    );
  }
}