import 'package:flutter/material.dart';
import 'package:jewellery_app/view/employee_module/history/model/history_model.dart';
import 'package:jewellery_app/view/employee_module/history/service/history_servie.dart';


class EmpBookingHistory extends StatefulWidget {
  const EmpBookingHistory({super.key});

  @override
  _EmpBookingHistoryState createState() => _EmpBookingHistoryState();
}

class _EmpBookingHistoryState extends State<EmpBookingHistory> {
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("History", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 87, 3, 82),
        automaticallyImplyLeading: false,
      ),
      
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: FutureBuilder<List<HistoryModel>>(
          future: historyProductList(),
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
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              );
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("No history found"));
            }

            final historyList = snapshot.data!;

            return ListView.builder(
              itemCount: historyList.length,
              itemBuilder: (context, index) {
                final history = historyList[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  elevation: 5,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(history.username ?? "No Name",
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Text("Phone: ${history.phoneNumber ?? "N/A"}"),
                        Text("Email: ${history.email ?? "N/A"}"),
                        
                        const SizedBox(height: 10),
                        const Text("Purchased Products:",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text("- ${history.productName ?? "N/A"} (x${history.quantity ?? "0"}) - ${history.totalPrice ?? "N/A"}"),
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(255, 81, 179, 85),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: null, // Button is disabled as it's a permanent "Completed" state
                            child: const Text("Completed"),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}