import 'package:flutter/material.dart';
import 'package:jewellery_app/view/user_home.dart';
import 'package:jewellery_app/view/user_module/single_product_payment/service/card_service.dart';
import 'package:jewellery_app/view/user_module/single_product_payment/service/gpay_service.dart';

class UserPayment extends StatefulWidget {
  final String total_price;
  final String booking_id;

  const UserPayment({
    super.key,
    required this.total_price,
    required this.booking_id,
  });

  @override
  UserPaymentState createState() => UserPaymentState();
}

class UserPaymentState extends State<UserPayment> {
  String? selectedBank;
  final TextEditingController pricecontroller = TextEditingController();
  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();
  final TextEditingController expiryDateController = TextEditingController();
  final TextEditingController upiController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final List<Map<String, String>> banks = [
    {'name': 'Google Pay', 'image': 'assets/icons/google-pay-icon.webp'},
    {'name': 'Credit/Debit Cards', 'image': 'assets/icons/credit_card.jpg'},
  ];

  @override
  void initState() {
    super.initState();
    selectedBank = 'Credit/Debit Cards';
    pricecontroller.text = "₹${widget.total_price}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('Select Payment Method',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            ...banks.map((bank) => ListTile(
                  leading: Image.asset(bank['image']!, width: 40, height: 40),
                  title: Text(bank['name']!),
                  trailing: Radio<String>(
                    value: bank['name']!,
                    groupValue: selectedBank,
                    onChanged: (value) {
                      setState(() {
                        selectedBank = value;
                      });
                    },
                  ),
                )),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _showPaymentSheet,
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                backgroundColor: const Color.fromARGB(255, 125, 50, 119),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 5,
              ),
              child: const Text(
                'Proceed to Payment',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPaymentSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Form(
            key: _formKey,
            child: selectedBank == 'Google Pay'
                ? _buildGooglePayForm()
                : _buildCardPaymentForm(),
          ),
        );
      },
    );
  }

  Future<void> _cardpay() async {
    if (_formKey.currentState!.validate()) {
      try {
        final responseMessage = await cardPayService(
          booking_id: widget.booking_id,
          name: nameController.text.trim(),
          card_number: cardNumberController.text.trim(),
          cvv: cvvController.text.trim(),
          expiry_date: expiryDateController.text.trim(),
        );
       
        if (responseMessage.message == 'Success') {
           ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('UPI Payment Successful')),
        );
          // Fixed comparison
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage()), // Push widget
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Card Payment failed: $e')),
        );
      }
    }
  }

  Future<void> _gpay() async {
    if (_formKey.currentState!.validate()) {
      try {
        final responseMessage = await gpayService(
          upi_id: upiController.text.trim(),
          booking_id: widget.booking_id,
        );

        if (responseMessage.status == 'Success') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('UPI Payment Successful')),
          );
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => HomePage()), // Push widget
            );
          
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Unknown error occurred')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('UPI Payment failed: $e')),
        );
      }
    }
  }

  Widget _buildCardPaymentForm() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('Enter Card Details',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        _buildValidatedTextField(
            controller: cardNumberController,
            label: 'Card Number',
            validator: (value) =>
                value!.length == 16 ? null : 'Card number must be 16 digits'),
        _buildValidatedTextField(
            controller: nameController,
            label: 'Cardholder Name',
            validator: (value) => value!.isNotEmpty ? null : 'Name required'),
        Row(
          children: [
            Expanded(
              child: _buildValidatedTextField(
                controller: expiryDateController,
                label: 'Expiry Date (MM/YY)',
                validator: (value) =>
                    RegExp(r'^(0[1-9]|1[0-2])\/(\d{2})$').hasMatch(value!)
                        ? null
                        : 'Invalid date format',
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
                child: _buildValidatedTextField(
                    controller: cvvController,
                    label: 'CVV',
                    obscureText: true,
                    validator: (value) =>
                        value!.length == 3 ? null : 'CVV must be 3 digits')),
          ],
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              backgroundColor: const Color.fromARGB(255, 98, 44, 95),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 5,
            ),
            onPressed: _cardpay,
            child: const Text(
              'Submit Payment',
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGooglePayForm() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('Enter UPI ID for Google Pay',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        _buildValidatedTextField(
            controller: upiController,
            label: 'UPI ID',
            validator: (value) => RegExp(r'^[\w.-]+@[\w]+$').hasMatch(value!)
                ? null
                : 'Invalid UPI ID'),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              backgroundColor: const Color.fromARGB(255, 94, 41, 116),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 5,
            ),
            onPressed: _gpay,
            child: const Text(
              'Submit Payment',
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildValidatedTextField(
      {required TextEditingController controller,
      required String label,
      bool obscureText = false,
      String? Function(String?)? validator}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
            labelText: label,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
        validator: validator,
      ),
    );
  }
}
