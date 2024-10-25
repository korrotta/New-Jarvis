import 'package:flutter/material.dart';
import 'package:newjarvis/components/custom_button.dart';
import 'package:newjarvis/components/custom_textfield.dart';
import 'package:newjarvis/services/auth_service.dart';

class RegisterPage extends StatelessWidget {
  // Email and Password controllers
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Page navigation
  final void Function()? onTap;

  RegisterPage({super.key, required this.onTap});

  // Validate email and password
  bool validateEmailAndPassword(
      String username, String email, String password) {
    // Check if email and password are not empty
    if (username.isEmpty || email.isEmpty || password.isEmpty) {
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

  // Register Method
  void register(BuildContext context) {
    // Auth Service
    final authService = AuthService();

    final String username = _usernameController.text;
    final String email = _emailController.text;
    final String password = _passwordController.text;

    // Check if email and password are not empty
    if (!validateEmailAndPassword(username, email, password)) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text("Please enter a valid email and password"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    } else {
      try {
        authService.signUpWithEmailPassword(email, password);
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Error"),
              content: Text(e.toString()),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("OK"),
                ),
              ],
            );
          },
        );
      }
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

              // Username textfield
              CustomTextfield(
                hintText: "Username",
                obscureText: false,
                controller: _usernameController,
              ),

              const SizedBox(height: 10),

              // Email textfield
              CustomTextfield(
                hintText: "Email",
                obscureText: false,
                controller: _emailController,
              ),

              const SizedBox(height: 10),

              // Password textfield
              CustomTextfield(
                hintText: "Password",
                obscureText: true,
                controller: _passwordController,
              ),

              const SizedBox(height: 25),

              // Register button
              CustomButton(
                text: "Register",
                onTap: () => register(context),
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                    "Already have an account? ",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),
                  GestureDetector(
                    onTap: onTap,
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
    );
  }
}
