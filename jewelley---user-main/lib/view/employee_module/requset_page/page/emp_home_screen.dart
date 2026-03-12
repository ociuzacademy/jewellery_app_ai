import 'package:flutter/material.dart';
import 'package:jewellery_app/view/employee_module/requset_page/model/request_model.dart';
import 'package:jewellery_app/view/employee_module/requset_page/page/user_detlas_view.dart';
import 'package:jewellery_app/view/employee_module/requset_page/service/request_service.dart';


class UserRequestPage extends StatelessWidget {
  const UserRequestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Requests", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 87, 3, 82),
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder<List<RequestViewModel>>(
        future: requestViewService(), // Use the existing service function
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text("Error: ${snapshot.error}", style: const TextStyle(fontSize: 18, color: Colors.black54)),
            );
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No items found", style: TextStyle(fontSize: 18, color: Colors.black54)));
          }

          final requests = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: requests.length,
            itemBuilder: (context, index) {
              final request = requests[index];
              final userDetails = request.userDetails;
              final assignedBookings = request.assignedBookings;

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserDetailsViewPage(userDetails: userDetails, assignedBookings: assignedBookings),
                    ),
                  );
                },
                child: Card(
                  elevation: 5,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Name: ${userDetails?.name ?? 'N/A'}",
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 5),
                        Text("Phone: ${userDetails?.phoneNumber ?? 'N/A'}"),
                        Text("Email: ${userDetails?.email ?? 'N/A'}"),
                        Text("Address: ${userDetails?.address ?? 'N/A'}"),
                        const SizedBox(height: 10),
                        if (assignedBookings != null && assignedBookings.isNotEmpty)
                          Text("Booking Date: ${assignedBookings.first.bookingDate?.toLocal().toString().split(' ')[0] ?? 'N/A'}"),
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(255, 250, 250, 249),
                              foregroundColor: Colors.black,
                            ),
                            onPressed:null,
                            child: const Text("Requested"),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}