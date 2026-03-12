import 'package:flutter/material.dart';
import 'package:jewellery_app/view/user_module/login/page/user_login.dart';
import 'package:jewellery_app/view/user_module/registration/service/register_service.dart';

class UserRegister extends StatefulWidget {
  const UserRegister({super.key});

  @override
  _UserRegisterState createState() => _UserRegisterState();
}

class _UserRegisterState extends State<UserRegister> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() == true) {
      setState(() {
        _isLoading = true;
      });
      try {
        await userRegistrationService(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
          phone: _phoneController.text.trim(),
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registered successfully')),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const UserLogin()),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration failed: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
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
            left: screenWidth * 0.08,
            child: const Text(
              "Hello\nSign In !",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: screenHeight * 0.7,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(80),
                  topRight: Radius.circular(80),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.08, vertical: 30),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInputField(_nameController, TextInputType.text,
                            "Enter your name"),
                        _buildInputField(_emailController,
                            TextInputType.emailAddress, "Enter your email"),
                        _buildInputField(_phoneController, TextInputType.phone,
                            "Enter your phone number"),
                        _buildPasswordField(
                            _passwordController, true, "Enter your password"),
                        _buildPasswordField(_confirmPasswordController, false,
                            "Confirm your password"),
                        const SizedBox(height: 40),
                        Center(
                          child: _isLoading
                              ? const CircularProgressIndicator()
                              : ElevatedButton(
                                  onPressed: _submitForm,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        const Color.fromARGB(255, 93, 7, 87),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 50, vertical: 15),
                                  ),
                                  child: const Text("Register",
                                      style: TextStyle(
                                          fontSize: 18, color: Colors.white)),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
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
                  const Text(
                    "Don't have an account?",
                    style: TextStyle(color: Colors.black),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const UserLogin(),
                        ),
                      );
                    },
                    child: const Text(
                      'Login',
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
          const SizedBox(height: 30),
        ],
      ),
    );
  }

 Widget _buildInputField(
    TextEditingController controller, TextInputType type, String hint) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8.0),
    child: TextFormField(
      controller: controller,
      keyboardType: type,
      decoration: InputDecoration(hintText: hint),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "This field is required";
        }
        if (type == TextInputType.emailAddress) {
          String pattern =
              r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
          RegExp regex = RegExp(pattern);
          if (!regex.hasMatch(value.trim())) {
            return "Enter a valid email";
          }
        }
        if (type == TextInputType.phone) {
          if (!RegExp(r'^\d{10}$').hasMatch(value)) {
            return "Enter a valid 10-digit phone number";
          }
        }
        return null;
      },
    ),
  );
}


  Widget _buildPasswordField(
      TextEditingController controller, bool isPassword, String hint) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: TextFormField(
        controller: controller,
        obscureText:
            isPassword ? !_isPasswordVisible : !_isConfirmPasswordVisible,
        decoration: InputDecoration(
          hintText: hint,
          suffixIcon: IconButton(
            icon: Icon(
              isPassword
                  ? (_isPasswordVisible
                      ? Icons.visibility
                      : Icons.visibility_off)
                  : (_isConfirmPasswordVisible
                      ? Icons.visibility
                      : Icons.visibility_off),
            ),
            onPressed: () {
              setState(() {
                if (isPassword) {
                  _isPasswordVisible = !_isPasswordVisible;
                } else {
                  _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                }
              });
            },
          ),
        ),
      ),
    );
  }
}
