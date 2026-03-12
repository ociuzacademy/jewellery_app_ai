import 'package:flutter/material.dart';
import 'package:jewellery_app/view/user_home.dart';
import 'package:jewellery_app/view/user_module/login/service/user_login_service.dart';
import 'package:jewellery_app/view/user_module/registration/page/user_register.dart';
import 'package:jewellery_app/view/utils/prefence_value.dart';
import 'package:jewellery_app/view/constants/urls.dart';

class UserLogin extends StatefulWidget {
  const UserLogin({super.key});

  @override
  _UserLoginState createState() => _UserLoginState();
}

class _UserLoginState extends State<UserLogin> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  Future<void> _loginVendor() async {
    if (_formKey.currentState?.validate() == true) {
      setState(() {
        _isLoading = true;
      });

      try {
        final responseMessage = await userLoginService(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        await PreferenceValues.userLogin(userId: responseMessage.userId!.toString());

        if (responseMessage.status == 'approved') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User Login successful')),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const HomePage(),
            ),
          );
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
            SnackBar(content: Text('Login failed: $e')),
          );
        }
      } finally {
        if (mounted) {
          // setState(() {
          //   _isLoading = false;
          // });
        }
      }
    }
  }

  void _showServerSettingsDialog(BuildContext context) {
    final TextEditingController urlController = TextEditingController(text: UserUrl.baseUrl);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Server Settings"),
        content: TextField(
          controller: urlController,
          decoration: const InputDecoration(
            labelText: "Server URL",
            hintText: "https://example.devtunnels.ms/",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              String newUrl = urlController.text.trim();
              if (newUrl.isNotEmpty) {
                UserUrl.setBaseUrl(newUrl);
                await PreferenceValues.setServerUrl(newUrl);
                if (mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Server URL updated to: $newUrl')),
                  );
                }
              }
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 26, 27, 27),
                  Color.fromARGB(255, 87, 3, 82),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Positioned(
            top: screenHeight * 0.15,
            left: screenWidth * 0.1,
            child: GestureDetector(
              onLongPress: () => _showServerSettingsDialog(context),
              child: const Text(
                "Hello\nSign In !",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: screenHeight * 0.6,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(80),
                  topRight: Radius.circular(80),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1, vertical: screenHeight * 0.05),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          "Email",
                          style: TextStyle(
                            color: Color.fromARGB(255, 93, 19, 83),
                            fontSize: 18,
                          ),
                        ),
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            labelText: "abc@gmail.com",
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter your email";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),
                        const Text(
                          "Password",
                          style: TextStyle(
                            color: Color.fromARGB(255, 93, 19, 83),
                            fontSize: 18,
                          ),
                        ),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: !_isPasswordVisible,
                          decoration: InputDecoration(
                            labelText: "******",
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter your password";
                            }
                            if (value.length < 6) {
                              return "Password must be at least 6 characters long";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: _isLoading
                              ? const CircularProgressIndicator()
                              : ElevatedButton(
                                  onPressed: _loginVendor,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color.fromARGB(255, 93, 7, 87),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                                  ),
                                  child: const Text("Login", style: TextStyle(fontSize: 18, color: Colors.white)),
                                ),
                        ),
                        const SizedBox(height: 30),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: TextButton(
                            onPressed: () {},
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                const Text("Don't have an account?", style: TextStyle(color: Colors.black)),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const UserRegister(),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    'Sign Up',
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 93, 7, 87),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}