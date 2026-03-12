import 'package:flutter/material.dart';
import 'package:jewellery_app/view/constants/urls.dart';
import 'package:jewellery_app/view/user_module/booking_history/model/history_model.dart';
import 'package:jewellery_app/view/user_module/booking_history/service/history_service.dart';

class BookingHistoryScreen extends StatefulWidget {
  const BookingHistoryScreen({super.key});

  @override
  _BookingHistoryScreenState createState() => _BookingHistoryScreenState();
}

class _BookingHistoryScreenState extends State<BookingHistoryScreen> {
  late Future<BookingHistoryMoldel> futureBookingHistory;

  @override
  void initState() {
    super.initState();
    futureBookingHistory = viewBookingsService();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Booking History",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 78, 2, 91),
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder<BookingHistoryMoldel>(
        future: futureBookingHistory,
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

          if (!snapshot.hasData ||
              (snapshot.data!.productBookings == null ||
                  snapshot.data!.cartBookings == null)) {
            return const Center(child: Text("No bookings found"));
          }

          final productBookings = snapshot.data!.productBookings ?? [];
          final cartBookings = snapshot.data!.cartBookings ?? [];
          final allBookings = [...productBookings, ...cartBookings];

          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 227, 223, 229),
                  Color.fromARGB(255, 237, 232, 236)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: allBookings.length,
              itemBuilder: (context, index) {
                final booking = allBookings[index];

                return Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading:

                        //  ClipRRect(
                        //   borderRadius: BorderRadius.circular(8),
                        //   child: Image.asset(
                        //     'assets/images/image1.jpg', // Replace with actual image URL if available
                        //     width: 50,
                        //     height: 50,
                        //     fit: BoxFit.cover,
                        //   ),
                        // ),

                        ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        '${UserUrl.baseUrl}/${booking.productImage!}', // Replace with your actual image URL
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(booking.productName ?? "Unknown Product",
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(
                        "Booked on: ${booking.bookingDate?.toLocal().toString().split(' ')[0] ?? "Unknown Date"}"),
                    trailing: Text("\u{20B9}${booking.totalPrice ?? "0"}",
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
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
