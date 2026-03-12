import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jewellery_app/view/user_module/checkout_screen/service/checkout_service.dart';
import 'package:jewellery_app/view/user_module/checkout_screen/service/confirm_checkout_service.dart';
import 'package:jewellery_app/view/user_module/single_product_payment/page/user_paymet.dart';

class CheckoutScreen extends StatefulWidget {
  final String booking_id;

  const CheckoutScreen({
    super.key,
    required this.booking_id,
  });

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();

  Future<void> _bookproduct() async {
    if (_formKey.currentState?.validate() == true) {
      try {
        String formattedTime;
        try {
          DateTime parsedTime = DateFormat.jm().parse(timeController.text);
          formattedTime = DateFormat.Hms().format(parsedTime);
        } catch (e) {
          formattedTime = "00:00:00";
        }

        final responseMessage = await confirmCheckoutService(
          booking_id: widget.booking_id,
          visit_date: dateController.text,
          visit_time: formattedTime,
        );

        if (responseMessage.status == 'success') {
          if (mounted) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(
                    "Proceed to Payment",
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.05,
                    ),
                  ),
                  content: Text(
                    "Do you want to continue to the payment page/n If there is a any cancelation please contact to the shop?",
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.04,
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "No",
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.04,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UserPayment(
                              total_price: responseMessage.advanceFee.toString(),
                              booking_id: responseMessage.bookingId.toString(),
                            ),
                          ),
                        );
                      },
                      child: Text(
                        "Yes",
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.04,
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  responseMessage.message ?? "Unknown error",
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.04,
                  ),
                ),
              ),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Product purchase failed: $e',
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.04,
                ),
              ),
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final bool isPortrait = screenSize.height > screenSize.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Checkout",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: screenSize.width * 0.05,
          ),
        ),
        backgroundColor: Colors.purple.shade900,
      ),
      body: FutureBuilder(
        future: checkoutService(booking_id: widget.booking_id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
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
                      fontWeight: FontWeight.bold,
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
                style: TextStyle(
                  fontSize: screenSize.width * 0.045,
                ),
              ),
            );
          }

          final singleitem = snapshot.data;

          return SingleChildScrollView(
            padding: EdgeInsets.all(screenSize.width * 0.04),
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
                    padding: EdgeInsets.all(screenSize.width * 0.05),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "User Details",
                          style: TextStyle(
                            fontSize: screenSize.width * 0.05,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple,
                          ),
                        ),
                        SizedBox(height: screenSize.height * 0.01),
                        _buildDetailRow(
                          context,
                          "Name: ",
                          singleitem!.userName!,
                        ),
                        _buildDetailRow(
                          context,
                          "Email: ",
                          singleitem.userEmail!,
                        ),
                        _buildDetailRow(
                          context,
                          "Phone: ",
                          singleitem.userPhoneNumber!,
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: screenSize.height * 0.02),

                // Order Summary
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(screenSize.width * 0.04),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Order Summary",
                          style: TextStyle(
                            fontSize: screenSize.width * 0.05,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple,
                          ),
                        ),
                        SizedBox(height: screenSize.height * 0.01),
                        _buildSummaryRow(
                          context,
                          "Total Amount",
                          "\u{20B9}${singleitem.totalPrice!}",
                        ),
                        _buildSummaryRow(
                          context,
                          "Advance Fee (10%)",
                          "\u{20B9}${singleitem.advanceFee!}",
                        ),
                        Divider(),
                        _buildSummaryRow(
                          context,
                          "Total Advance Fee for Booking",
                          "\u{20B9}${singleitem.advanceFee!}",
                          isBold: true,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: screenSize.height * 0.02),

                // Booking Form
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDateTimeField(
                        context,
                        controller: dateController,
                        label: "Select Date",
                        icon: Icons.calendar_today,
                        isDate: true,
                      ),
                      SizedBox(height: screenSize.height * 0.02),
                      _buildDateTimeField(
                        context,
                        controller: timeController,
                        label: "Select Time",
                        icon: Icons.access_time,
                        isDate: false,
                      ),
                      SizedBox(height: screenSize.height * 0.03),
                      Center(
                        child: ElevatedButton(
                          onPressed: _bookproduct,
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              horizontal: screenSize.width * 0.1,
                              vertical: screenSize.height * 0.02,
                            ),
                            backgroundColor: Colors.purple.shade900,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            "Confirm Booking",
                            style: TextStyle(
                              fontSize: screenSize.width * 0.04,
                              color: Colors.white,
                            ),
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

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.005),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.04,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.04,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(BuildContext context, String title, String value, {bool isBold = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.005),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.04,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.04,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateTimeField(
    BuildContext context, {
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required bool isDate,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          fontSize: MediaQuery.of(context).size.width * 0.04,
        ),
        suffixIcon: Icon(
          icon,
          color: Colors.purple.shade900,
          size: MediaQuery.of(context).size.width * 0.06,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.04,
          vertical: MediaQuery.of(context).size.height * 0.02,
        ),
      ),
      style: TextStyle(
        fontSize: MediaQuery.of(context).size.width * 0.04,
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