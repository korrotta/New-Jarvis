import 'package:flutter/material.dart';
import 'package:newjarvis/components/custom_button.dart';
import 'package:newjarvis/components/custom_textfield.dart';
import 'package:newjarvis/models/user_model.dart';
import 'package:newjarvis/services/api_service.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;

  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // ApiService
  final ApiService apiService = ApiService();

  // Controllers for form fields
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Form key to validate the form
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Loading state
  bool isLoading = false;

  // Register Method
  void register() async {
    final String username = _usernameController.text;
    final String email = _emailController.text;
    final String password = _passwordController.text;

    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Set loading state
    setState(() {
      isLoading = true;
    });

    if (!mounted) return;

    try {
      // Call the registration service
      final response = await apiService.signUp(
          email: email,
          password: password,
          username: username,
          context: context);

      if (!mounted) return;

      // Set loading state
      setState(() {
        isLoading = false;
      });

      if (response.isNotEmpty) {
        // Create a new user object
        final UserModel user = UserModel.fromMap(response["user"]);

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registered successfully')),
        );

        print('User: $user');

        // Navigate to the login
        widget.onTap!();
      } else {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('An error occurred')),
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
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
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

                // Register Text
                Text(
                  "Register Account",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                Text(
                  "Get your free Jarvis account now.",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 25),

                // Username textfield with validation
                CustomTextfield(
                  hintText: "Username",
                  initialObscureText: false,
                  controller: _usernameController,
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        value.trim().isEmpty) {
                      return "Please enter a username";
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 10),

                // Email textfield with validation
                CustomTextfield(
                  hintText: "Email",
                  initialObscureText: false,
                  controller: _emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter an email";
                    }
                    if (!value.contains("@") || !value.contains(".")) {
                      return "Please enter a valid email";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 10),

                // Password textfield with validation
                CustomTextfield(
                  hintText: "Password",
                  initialObscureText: true,
                  controller: _passwordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter a password";
                    }
                    if (value.length < 6) {
                      return "Password must be at least 6 characters";
                    }
                    if (!RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{6,}$')
                        .hasMatch(value)) {
                      return "Password must contain at least one uppercase letter, one lowercase letter, one number";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 25),

                // Register button
                CustomButton(
                  text: "Register",
                  onTap: () => register(),
                ),

                const SizedBox(height: 10),

                // // -- OR --
                // Row(
                //   children: [
                //     Expanded(
                //       child: Container(
                //         margin: const EdgeInsets.only(left: 20, right: 10),
                //         child: Divider(
                //           color: Theme.of(context).colorScheme.inversePrimary,
                //         ),
                //       ),
                //     ),
                //     Text(
                //       "OR LOGIN WITH",
                //       style: TextStyle(
                //         color: Theme.of(context).colorScheme.inversePrimary,
                //         fontSize: 16,
                //       ),
                //     ),
                //     Expanded(
                //       child: Container(
                //         margin: const EdgeInsets.only(left: 10, right: 20),
                //         child: Divider(
                //           color: Theme.of(context).colorScheme.inversePrimary,
                //         ),
                //       ),
                //     ),
                //   ],
                // ),

                // const SizedBox(height: 10),

                // // Jarvis sign in
                // Container(
                //   margin: const EdgeInsets.symmetric(horizontal: 20),
                //   padding:
                //       const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                //   decoration: BoxDecoration(
                //     color: Theme.of(context).colorScheme.tertiary,
                //     borderRadius: BorderRadius.circular(8),
                //     border: Border.all(
                //       color: Theme.of(context).colorScheme.primary,
                //     ),
                //   ),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: [
                //       Image.asset(
                //         "assets/icons/icon.png",
                //         width: 30,
                //         height: 30,
                //       ),
                //       const SizedBox(width: 10),
                //       Text(
                //         "Jarvis",
                //         style: TextStyle(
                //           color: Theme.of(context).colorScheme.inversePrimary,
                //           fontSize: 16,
                //         ),
                //       )
                //     ],
                //   ),
                // ),

                // const SizedBox(height: 10),

                // Register now
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account? ",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary,
                      ),
                    ),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        "Sign in now",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.blue),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
