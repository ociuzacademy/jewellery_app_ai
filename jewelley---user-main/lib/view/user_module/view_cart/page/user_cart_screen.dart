import 'package:flutter/material.dart';
import 'package:jewellery_app/view/constants/urls.dart';
import 'package:jewellery_app/view/user_module/cart_checkout/page/cart_checkout_page.dart';

import 'package:jewellery_app/view/user_module/view_cart/model/main_cart_model.dart';
import 'package:jewellery_app/view/user_module/view_cart/service/cartitem_delete_service.dart';
import 'package:jewellery_app/view/user_module/view_cart/service/main_cart_service.dart';
import 'package:jewellery_app/view/user_module/wishlist/page/whislist_page.dart';

class UserCartScreen extends StatefulWidget {
  const UserCartScreen({super.key});

  @override
  _UserCartScreenState createState() => _UserCartScreenState();
}

class _UserCartScreenState extends State<UserCartScreen> {
  
  double getTotalPrice(List<CartItem> cartItems) {
    return cartItems.fold(0, (sum, item) => sum + (item.itemTotalPrice ?? 0));
  }

  void updateQuantity(int index, int change, List<CartItem> cartItems) {
    setState(() {
      cartItems[index].quantity = (cartItems[index].quantity ?? 0) + change;
      if (cartItems[index].quantity! < 1) {
        cartItems[index].quantity = 1;
      }
    });
  }

  Future<void> _deleteItem(dynamic cartItemId) async {
    try {
      final responseMessage = await cartDeleteService(
        cart_item_id: cartItemId.toString(), 
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        title: const Text(
          "Shopping Cart",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 78, 2, 91),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const WishlistPage()),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<MainCartModel>(
        future: mainCartService(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/noResponse.jpg'),
                  Text("Error: ${snapshot.error}",
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.cartItems == null) {
            return const Center(child: Text("No cart data found"));
          }

          final cartItems = snapshot.data!.cartItems!;
          final totalPrice = snapshot.data!.totalPrice ?? 0;

          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 227, 223, 229),
                  Color.fromARGB(255, 237, 232, 236),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 6),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 215, 198, 215),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Delete button at the top-right
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color:
                                          Color.fromARGB(255, 120, 118, 117)),
                                  onPressed: () =>
                                      _deleteItem(item.id), // Remove 'as String'
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    "${UserUrl.baseUrl}/${item.productImage}",
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(Icons.error);
                                    },
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(item.productName ?? '',
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold)),
                                      Text("Size: ${item.size ?? ''}"),
                                      Text("Weight: ${item.weight ?? ''}g"),
                                      Text("Stock: ${item.stock ?? ''}"),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove_circle_outline,
                                      color: Color.fromARGB(255, 78, 2, 91)),
                                  onPressed: () =>
                                      updateQuantity(index, -1, cartItems),
                                ),
                                Text(item.quantity.toString(),
                                    style: const TextStyle(fontSize: 18)),
                                IconButton(
                                  icon: const Icon(Icons.add_circle_outline,
                                      color: Color.fromARGB(255, 78, 2, 91)),
                                  onPressed: () =>
                                      updateQuantity(index, 1, cartItems),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  "\u{20B9}${item.itemTotalPrice?.toStringAsFixed(2) ?? '0.00'}",
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                // Subtotal and Checkout Button
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, -3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Subtotal:",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "\u{20B9}${totalPrice.toStringAsFixed(2)}",
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const CheckoutScreenMain(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 78, 2, 91),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            "Checkout",
                            style: TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(255, 241, 240, 240)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
