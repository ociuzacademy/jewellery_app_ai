// import 'package:flutter/material.dart';

// class UserDetailsPage extends StatefulWidget {
//   const UserDetailsPage({super.key});

//   @override
//   _UserDetailsPageState createState() => _UserDetailsPageState();
// }

// class _UserDetailsPageState extends State<UserDetailsPage> {
//   Map<String, dynamic> userDetails = {
//     "name": "John Doe",
//     "phone": "123-456-7890",
//     "email": "john.doe@example.com",
//     "address": "123 Main Street, City, Country",
//     "advancePayment": "₹5,000",
//     "status": "User Meet",
//     "purchasedProducts": [
//       {
//         "name": "Gold Necklace",
//         "price": "\$2500",
//         "quantity": "2",
//         "image": "assets/images/offer.webp",
//         "size": "Medium",
//         "purchased": "1"
//       },
//       {
//         "name": "Platinum Ring",
//         "price": "\$1500",
//         "quantity": "5",
//         "image": "assets/images/offer.webp",
//         "size": "Ring Size 8",
//         "purchased": "2"
//       }
//     ]
//   };

//   final List<String> statusStages = ["User Meet", "Make Payment", "User Leave from the Shop"];
//   int currentStatusIndex = 0;

//   void updateStatus() {
//     setState(() {
//       if (currentStatusIndex < statusStages.length - 1) {
//         currentStatusIndex++;
//         userDetails["status"] = statusStages[currentStatusIndex];
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("User Details"),
//         backgroundColor: Color.fromARGB(255, 87, 3, 82),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(10),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Card(
//               elevation: 5,
//               margin: const EdgeInsets.all(16),
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//               child: Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text("User Information", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.purple)),
//                     const Divider(),
//                     _buildDetailRow("Name", userDetails["name"]),
//                     _buildDetailRow("Phone", userDetails["phone"]),
//                     _buildDetailRow("Email", userDetails["email"]),
//                     _buildDetailRow("Address", userDetails["address"]),
//                     _buildDetailRow("Advance Payment", userDetails["advancePayment"]),
//                     const SizedBox(height: 10),
//                     Center(
//                       child: ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: currentStatusIndex == 2 ? Colors.green : Colors.blue,
//                           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//                           padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
//                         ),
//                         onPressed: updateStatus,
//                         child: Text(
//                           userDetails["status"],
//                           style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(height: 10),
//             const Text("Purchased Products", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: userDetails["purchasedProducts"].length,
//                 itemBuilder: (context, index) {
//                   final product = userDetails["purchasedProducts"][index];
//                   return Card(
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                     margin: const EdgeInsets.symmetric(vertical: 10),
//                     child: ListTile(
//                       leading: ClipRRect(
//                         borderRadius: BorderRadius.circular(10),
//                         child: Image.asset(product["image"], width: 50, height: 50, fit: BoxFit.cover),
//                       ),
//                       title: Text(product["name"], style: const TextStyle(fontWeight: FontWeight.bold)),
//                       subtitle: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text("Price: ${product["price"]}"),
//                           Text("Quantity: ${product["quantity"]}"),
//                           Text("Size: ${product["size"]}"),
//                           Text("Purchased: ${product["purchased"]}"),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildDetailRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 5),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
//           Text(value, style: const TextStyle(fontSize: 16, color: Colors.black54)),
//         ],
//       ),
//     );
//   }
// }
