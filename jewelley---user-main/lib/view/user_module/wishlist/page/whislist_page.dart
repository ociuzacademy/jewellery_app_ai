import 'package:flutter/material.dart';
import 'package:jewellery_app/view/constants/urls.dart';
import 'package:jewellery_app/view/user_module/view_cart/page/user_cart_screen.dart';
import 'package:jewellery_app/view/user_module/wishlist/model/wishlist_model.dart';
import 'package:jewellery_app/view/user_module/wishlist/service/tocart_service.dart';
import 'package:jewellery_app/view/user_module/wishlist/service/wishlist_remove.dart';
import 'package:jewellery_app/view/user_module/wishlist/service/wishlist_service.dart';

class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  _WishlistPageState createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  

   Future<void> _removeFromWishlist(String itemId) async {
    try {
      final responseMessage = await wishlistItemService(
        wishlist_item_id:itemId,  
      );
       
      if (responseMessage.status == 'success') {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Product deleted successfully!')),
          );
          setState(() {});
         
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(responseMessage.message ?? "Unknown error")),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete product: $e')),
        );
      }
    }
  }

  // Future for post method to add to cart
  Future<void> _addToCart(String productId) async {
    try {
      final responseMessage = await toCartService(
        product_id:productId,
        
      );

      if (responseMessage == 'success') {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true, // Allows it to take full width
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          builder: (context) {
            return Container(
              width: MediaQuery.of(context).size.width, // Make it full width
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Product added to cart',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const UserCartScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      'View Cart',
                      style: TextStyle(
                        color: Color.fromARGB(255, 93, 7, 87),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );setState(() {});
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Wishlist"),
        backgroundColor: const Color.fromARGB(255, 101, 28, 111),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder<List<ViewWishlistModel>>(
        future: wishlistViewService(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                children: [
                  Image.asset('assets/images/noResponse.jpg'),
                  Text(
                    "Error: ${snapshot.error}",
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                children: [
                  Image.asset('assets/images/no products.jpg'),
                  const Text(
                    "No products found",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            );
          }

          List<ViewWishlistModel> wishlistItems = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.75,
              ),
              itemCount: wishlistItems.length,
              itemBuilder: (context, index) {
                final item = wishlistItems[index];
                final product = item.product;

                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(10)),
                              child: Image.network(
                                '${UserUrl.baseUrl}/${item.productMainImage!}' ??
                                    'assets/images/profile.jpg',
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            ),
                            Positioned(
                              left: 5,
                              top: 5,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.black54,
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.white),
                                  onPressed: () => _removeFromWishlist(item.id!.toString()),
                                  iconSize: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: 8),
                        child: Text(
                          item.productName! ?? "Product Name",
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          "₹${item.productPrice ?? "0"}",
                          style: const TextStyle(
                              fontSize: 14, color: Colors.deepPurple,),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 108, 33, 109),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () =>
                              _addToCart(item.product!.toString()),
                          child: const Text("Add to Cart"),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
