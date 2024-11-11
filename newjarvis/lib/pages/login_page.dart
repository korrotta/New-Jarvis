import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:newjarvis/components/custom_button.dart';
import 'package:newjarvis/components/custom_textfield.dart';
import 'package:newjarvis/services/api_service.dart';

class LoginPage extends StatefulWidget {
  // Page navigation
  final void Function()? onTap;

  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // ApiService
  final ApiService apiService = ApiService();

  // Form key for validation
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Email and Password controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Loading state
  bool isLoading = false;

  // Validate email and password
  bool validateEmailAndPassword(String email, String password) {
    // Check if email and password are not empty
    if (email.isEmpty || password.isEmpty) {
      return false;
    }

    // Check if email is valid
    if (!email.contains("@") || !email.contains(".")) {
      return false;
    }

    // Check if password is at least 6 characters long
    if (password.length < 6) {
      return false;
    }

    return true;
  }

  // Check network connectivity
  Future<bool> checkNetworkConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      return false;
    }
    return true;
  }

  // Sign in API call
  void signIn() async {
    final String email = _emailController.text;
    final String password = _passwordController.text;

    // Validate email and password using Form validation
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Set loading state
    setState(() {
      isLoading = true;
    });

    if (!mounted) return;

    // Check network connectivity
    bool isConnected = await checkNetworkConnectivity();
    if (!isConnected) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No internet connection')),
      );
      return;
    }

    try {
      // Await the response from the signIn API
      final response =
          await apiService.signIn(email: email, password: password);

      if (!mounted) return;

      // Set loading state
      setState(() {
        isLoading = false;
      });

      if (response.isNotEmpty) {
        Navigator.pushReplacementNamed(context, '/chat');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login failed')),
        );
      }
    } catch (e) {
      if (!mounted) return;

      // Set loading state
      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 45),
            // Logo
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/icons/icon.png",
                  width: 30,
                  height: 30,
                ),
                Container(
                  margin: const EdgeInsets.only(left: 10),
                  child: const Text(
                    "Jarvis",
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),

            const SizedBox(height: 25),

            // Welcome back text
            Text(
              "Welcome Back !",
              style: TextStyle(
                color: Theme.of(context).colorScheme.inversePrimary,
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              "Sign in to continue to Jarvis",
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 30),

            // Form for email and password fields
            Form(
              key: _formKey,
              child: Column(
                children: [
                  // Email textfield
                  CustomTextfield(
                    hintText: "Email",
                    obscureText: false,
                    controller: _emailController,
                    validator: (email) {
                      if (email == null || email.isEmpty) {
                        return "Please enter an email";
                      }
                      if (!email.contains("@") || !email.contains(".")) {
                        return "Please enter a valid email";
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  // Password textfield
                  CustomTextfield(
                    hintText: "Password",
                    obscureText: true,
                    controller: _passwordController,
                    validator: (password) {
                      if (password == null || password.isEmpty) {
                        return "Please enter a password";
                      }
                      if (password.length < 6) {
                        return "Password should be at least 6 characters";
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 10),

                  // Remebmer me and forgot password
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Checkbox(value: false, onChanged: (value) {}),
                            Text(
                              "Remember me",
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: const Text(
                            "Forgot password?",
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Login button
                  isLoading
                      ? const CircularProgressIndicator()
                      : CustomButton(
                          text: "Login",
                          onTap: signIn,
                        ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // -- OR --
            Row(
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(left: 20, right: 10),
                    child: Divider(
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),
                ),
                Text(
                  "OR LOGIN WITH",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary,
                    fontSize: 16,
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(left: 10, right: 20),
                    child: Divider(
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // Jarvis sign in
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.tertiary,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/icons/icon.png",
                    width: 30,
                    height: 30,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "Jarvis",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      fontSize: 16,
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height: 10),

            // Register now
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don't have an account? ",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary),
                ),
                GestureDetector(
                  onTap: widget.onTap,
                  child: const Text(
                    "Sign up now",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.blue),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
