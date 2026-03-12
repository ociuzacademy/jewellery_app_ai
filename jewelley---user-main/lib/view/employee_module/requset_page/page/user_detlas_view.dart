import 'package:flutter/material.dart';
import 'package:jewellery_app/view/employee_module/requset_page/model/request_model.dart';
import 'package:jewellery_app/view/employee_module/requset_page/service/user_meet_service.dart';

class UserDetailsViewPage extends StatefulWidget {
  final UserDetails? userDetails;
  final List<AssignedBooking>? assignedBookings;

  const UserDetailsViewPage({super.key, this.userDetails, this.assignedBookings});

  @override
  State<UserDetailsViewPage> createState() => _UserDetailsViewPageState();
}

class _UserDetailsViewPageState extends State<UserDetailsViewPage> {
  String? status;

  @override
  void initState() {
    super.initState();
    if (widget.assignedBookings != null && widget.assignedBookings!.isNotEmpty) {
      status = widget.assignedBookings!.first.status;
    }
  }

  Future<void> _updateStatusAndDisplayUserId(BuildContext context, int userId) async {
  try {
    final responseMessage = await changeStatusService(
      user_id: userId.toString(),
    );

    if (responseMessage.status == 'success') {
      setState(() {
        status = 'user_meet'; // Updating the status
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('status changed')),
      );

      // Refresh the screen after a short delay
      // Future.delayed(const Duration(milliseconds: 500), () {
      //   Navigator.pushReplacement(
      //     context,
      //     MaterialPageRoute(builder: (context) => UserDetailsViewPage()), // Replace with actual screen
      //   );
      // });

    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(responseMessage.message ?? "Unknown error")),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to stop: $e')),
    );
  }
}

  Color _getButtonColor(String? status) {
    switch (status) {
      case 'assigned':
        return Colors.yellow;
      case 'user_meet':
        return Colors.orange;
      default:
        return const Color.fromARGB(255, 28, 28, 28);
    }
  }

  String _getButtonText(String? status) {
    switch (status) {
      case 'assigned':
        return 'Assigned';
      case 'user_meet':
        return 'User Meet';
      default:
        return 'Completed';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Details", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 87, 3, 82),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 4,
              margin: const EdgeInsets.only(bottom: 20),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Name: ${widget.userDetails?.name ?? 'N/A'}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Text("Phone: ${widget.userDetails?.phoneNumber ?? 'N/A'}"),
                    Text("Email: ${widget.userDetails?.email ?? 'N/A'}"),
                    Text("Address: ${widget.userDetails?.address ?? 'N/A'}"),
                    const SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          if (widget.userDetails?.userId != null) {
                            _updateStatusAndDisplayUserId(context, widget.userDetails!.userId!);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _getButtonColor(status),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        ),
                        child: Text(
                          _getButtonText(status),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Center(child: Text("Assigned Bookings", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
            const SizedBox(height: 10),
            if (widget.assignedBookings != null && widget.assignedBookings!.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: widget.assignedBookings!.length,
                  itemBuilder: (context, index) {
                    final booking = widget.assignedBookings![index];
                    return Card(
                      elevation: 4,
                      margin: const EdgeInsets.only(bottom: 10),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Product: ${booking.productName ?? 'N/A'}", style: const TextStyle(fontWeight: FontWeight.bold)),
                            Text("Advance Fees: ${booking.advanceFee ?? 'N/A'}"),
                            Text("Quantity: ${booking.quantity ?? 'N/A'}"),
                            Text("Status: ${booking.status ?? 'N/A'}"),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            if (widget.assignedBookings == null || widget.assignedBookings!.isEmpty)
              const Center(
                child: Text("No assigned bookings found", style: TextStyle(fontSize: 16, color: Colors.grey)),
              ),
          ],
        ),
      ),
    );
  }
}
