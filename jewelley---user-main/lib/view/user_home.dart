import 'package:flutter/material.dart';
import 'package:jewellery_app/view/user_module/booking_history/page/booking_history.dart';
import 'package:jewellery_app/view/user_module/view_cart/page/user_cart_screen.dart';
import 'package:jewellery_app/view/user_module/user_home/page/user_home_screen.dart';
import 'package:jewellery_app/view/user_module/user_profile/page/user_profile_screen.dart';
import 'package:jewellery_app/view/user_module/wishlist/page/whislist_page.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.animateToPage(index,
        duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: const [
          UserHomeScreen(),
          UserCartScreen(),
          WishlistPage(),
          BookingHistoryScreen(),
          UserProfileScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "Cart"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Wishlist"),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: "History"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: const Color.fromARGB(255, 111, 5, 109),
        unselectedItemColor: Colors.grey,
        enableFeedback: false,
        selectedFontSize: 13,
        iconSize: 20,
        showSelectedLabels: true,
      ),
    );
  }
}


