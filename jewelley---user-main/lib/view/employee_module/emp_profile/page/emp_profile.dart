import 'package:flutter/material.dart';
import 'package:jewellery_app/view/constants/urls.dart';
import 'package:jewellery_app/view/employee_module/emp_login/page/emp_login.dart';
import 'package:jewellery_app/view/employee_module/emp_profile/service/emp_profile_service.dart';
import 'package:jewellery_app/view/employee_module/emp_profile/model/emp_profile_model.dart';
import 'package:jewellery_app/view/utils/prefence_value.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Profile",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 100, 4, 117),
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder<EmpProfileModel>(
        future: empProfileService(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/noResponse.jpg',
                      height: screenHeight * 0.3),
                  const SizedBox(height: 10),
                  Text(
                    "Error: ${snapshot.error}",
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text("No user profile found"));
          }

          final empProfile = snapshot.data!;

          return Padding(
            padding: EdgeInsets.all(screenWidth * 0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: screenWidth * 0.15,
                  backgroundImage:
                      empProfile.photo != null && empProfile.photo!.isNotEmpty
                          ? NetworkImage(
                              '${UserUrl.empbaseUrl}/${empProfile.photo!}')
                          : const AssetImage('assets/images/default_user.png')
                              as ImageProvider,
                ),
                SizedBox(height: screenHeight * 0.03),
                Text(
                  empProfile.name ?? "No Name",
                  style: TextStyle(
                      fontSize: screenWidth * 0.06,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: screenHeight * 0.02),

                // Email, Phone, Address, etc.
                _infoCard(Icons.email, "Email", empProfile.email ?? "No Email",
                    screenWidth),
                _infoCard(Icons.phone, "Phone",
                    empProfile.phone ?? "No Phone Number", screenWidth),
                _infoCard(Icons.location_on, "Address",
                    empProfile.address ?? "No Address", screenWidth),
                _infoCard(
                  Icons.calendar_today,
                  "Date Joined",
                  empProfile.dateJoined != null
                      ? "${empProfile.dateJoined!.day}-${empProfile.dateJoined!.month}-${empProfile.dateJoined!.year}"
                      : "No Date of Joining",
                  screenWidth,
                ),
                _infoCard(Icons.work, "Position",
                    empProfile.position ?? "No Position added", screenWidth),

                SizedBox(height: screenHeight * 0.03),
                SizedBox(
                  width: screenWidth * 0.6,
                  child: ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Logout"),
                            content:
                                const Text("Are you sure you want to log out?"),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text("Cancel"),
                              ),
                              TextButton(
                                onPressed: () async {
                                  await PreferenceValues.employeeLogout();
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const EmployeeLoginPage()),
                                  );
                                },
                                child: const Text("Logout"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 148, 94, 159),
                      padding:
                          EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(screenWidth * 0.02),
                      ),
                    ),
                    child: Text(
                      "Logout",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenWidth * 0.045,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _infoCard(
      IconData icon, String label, String value, double screenWidth) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: Colors.purple, size: screenWidth * 0.07),
        title: Text(value, style: TextStyle(fontSize: screenWidth * 0.045)),
      ),
    );
  }
}
