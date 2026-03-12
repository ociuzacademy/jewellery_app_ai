import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jewellery_app/view/user_module/cart_checkout/service/cart_checkout_service.dart';
import 'package:jewellery_app/view/user_module/cart_checkout/service/confirm_checkout_service.dart';
import 'package:jewellery_app/view/user_module/cart_product_payment/page/cart_produt_payment.dart';

class CheckoutScreenMain extends StatefulWidget {
 
  const CheckoutScreenMain({
    super.key,
   
  });

  @override
  _CheckoutScreenMainState createState() => _CheckoutScreenMainState();
}

class _CheckoutScreenMainState extends State<CheckoutScreenMain> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();

  // final double totalAmount = 850.0;
  // final double advanceFee = 0.2 * 850; // 20% of total amount



Future<void> _bookproduct() async {
  if (_formKey.currentState?.validate() == true) {
    try {
      // Convert timeController.text into HH:mm:ss format
      String formattedTime;
      try {
        DateTime parsedTime = DateFormat.jm().parse(timeController.text); // Parses '3:01 PM' to DateTime
        formattedTime = DateFormat.Hms().format(parsedTime); // Converts to '15:01:02'
      } catch (e) {
        formattedTime = "00:00:00"; // Default fallback if parsing fails
      }

      final responseMessage = await confirmCheckoutScreenService(
         visit_date:dateController.text, 
         visit_time:  formattedTime,
  
      );

      if (responseMessage.status == 'success') {
        if (mounted) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Proceed to Payment"),
                content: const Text("Do you want to continue to the payment page/n If there is a any cancelation please contact to the shop?"),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("No"),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => UserCartPayment( total_price: responseMessage.advanceFee.toString(),
                        booking_id: responseMessage.bookingId.toString(),)),
                      );
                    },
                    child: const Text("Yes"),
                  ),
                ],
              );
            },
          );
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
          SnackBar(content: Text('Product purchase failed: $e')),
        );
      }
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Checkout",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.purple.shade900,
      ),
      body: FutureBuilder(
        future: cartCheckoutScreen(),
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

          if (!snapshot.hasData) {
            return const Center(child: Text("No service found"));
          }

          final singleitem = snapshot.data;
 
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User Details
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "User Details",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Text(
                              "Name: ",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              singleitem!.userName!,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Text(
                              "Email: ",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              singleitem.userEmail!,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Text(
                              "Phone: ",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              singleitem
                                  .userPhoneNumber!, 
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Order Summary
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Order Summary",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.purple)),
                        const SizedBox(height: 10),
                        summaryRow("Total Amount",
                            "\u{20B9}${singleitem.totalPrice!}"),
                        summaryRow("Advance Fee (10%)",
                            "\u{20B9}${singleitem.advanceFee!}"),
                        const Divider(),
                        summaryRow("Total Advance Fee for Booking",
                            "\u{20B9}${singleitem.advanceFee!}",
                            isBold: true),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Booking Form
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildDateTimeField(
                          controller: dateController,
                          label: "Select Date",
                          icon: Icons.calendar_today,
                          isDate: true),
                      const SizedBox(height: 16),
                      buildDateTimeField(
                          controller: timeController,
                          label: "Select Time",
                          icon: Icons.access_time,
                          isDate: false),
                      const SizedBox(height: 24),
                      Center(
                        child: ElevatedButton(
                          onPressed: _bookproduct,
                          // {
                          //   if (_formKey.currentState!.validate()) {
                          //     Navigator.push(
                          //         context,
                          //         MaterialPageRoute(
                          //             builder: (context) => UserPaymet()));
                          //   }
                          // },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 14),
                            backgroundColor: Colors.purple.shade900,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          child: const Text("Confirm Booking",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white)),
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

  Widget summaryRow(String title, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
          Text(value,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }

  Widget buildDateTimeField(
      {required TextEditingController controller,
      required String label,
      required IconData icon,
      required bool isDate}) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: Icon(icon, color: Colors.purple.shade900),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onTap: () async {
        if (isDate) {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime(2100),
          );
          if (pickedDate != null) {
            controller.text = DateFormat('yyyy-MM-dd').format(pickedDate);
          }
        } else {
          TimeOfDay? pickedTime = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.now(),
          );
          if (pickedTime != null) {
            controller.text = pickedTime.format(context);
          }
        }
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "$label is required.";
        }
        return null;
      },
    );
  }
}
