class UserUrl {
  // Base URL for the API server 
  static String baseUrl = "";
  
  static String get userbaseUrl => "$baseUrl/userapp";
  static String get empbaseUrl => "$baseUrl/employeeapp";

  static String get user_login => "$userbaseUrl/login/";
  static String get user_register => "$userbaseUrl/register/";
  static String get gold => "$userbaseUrl/register/";
  static String get categories => "$userbaseUrl/user_category_list/";
  static String get single_category => "$userbaseUrl/products/";
  static String get book_product => "$userbaseUrl/book_products/";
  static String get user_profile => "$userbaseUrl/view_user_profile/";
  static String get user_feedback => "$userbaseUrl/submit_feedback/";
  static String get user_checkout => "$userbaseUrl/payments/";
  static String get user_confirm_checkout => "$userbaseUrl/checkout/";
  static String get cart_product => "$userbaseUrl/cart_products/";
  static String get view_cart => "$userbaseUrl/view_cart/";
  static String get cart_item_delete => "$userbaseUrl/remove_cart_items/";
  static String get add_to_wishlist => "$userbaseUrl/add_wishlist/";
  static String get view_wishlist => "$userbaseUrl/view_wishlist/";
  static String get delete_wishlist => "$userbaseUrl/remove_wishlist_items/";
  static String get wishlist_to_cart => "$userbaseUrl/wishlist_to_cart/";
  static String get single_gpay => "$userbaseUrl/upi_payment/";
  static String get single_card => "$userbaseUrl/card_payment/";
  static String get cart_checkout => "$userbaseUrl/cart_booking_summary/";
  static String get cart_checkout_details => "$userbaseUrl/cart_checkout/";
  static String get cart_card_payment => "$userbaseUrl/cart_card_payment/";
  static String get cart_upi => "$userbaseUrl/cart_upi_payment/";
  static String get history => "$userbaseUrl/booking_history/";
  
  // Employee login details 
  static String get emp_login => "$empbaseUrl/login/";
  static String get emp_profile_view => "$empbaseUrl/view_employee_profile/";
  static String get request_view => "$empbaseUrl/assigned_bookings/";
  static String get userMeet => "$empbaseUrl/update_user_booking_status/";
  static String get emphistory => "$empbaseUrl/employee_booking_history/";

  static void setBaseUrl(String newUrl) {
    if (!newUrl.endsWith('/')) {
      newUrl += '/';
    }
    baseUrl = newUrl;
  }
}
