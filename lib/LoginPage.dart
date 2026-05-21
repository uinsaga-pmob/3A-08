import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),

          child: Column(
            children: [
              const SizedBox(height: 40),

              // ======================
              // LOGO
              // ======================
              Center(
                child: Image.asset("assets/images/kopilogo.png", height: 150),
              ),

              const SizedBox(height: 40),

              // ======================
              // TITLE
              // ======================
              const Align(
                alignment: Alignment.centerLeft,

                child: Text(
                  "Login",

                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
              ),

              const SizedBox(height: 8),

              const Align(
                alignment: Alignment.centerLeft,

                child: Text(
                  "Hey there, coffee lover! Login and grab your brew!",

                  style: TextStyle(fontSize: 14, height: 1.3),
                ),
              ),

              const SizedBox(height: 24),

<<<<<<< HEAD
              // ======================
              // LOGIN FIELD
              // ======================
              _buildInputField("Login"),

=======
              // Input fields
              _buildInputField("Email"),
>>>>>>> b76c2bab9bed56e13967fba28559e5a0271d2960
              const SizedBox(height: 12),

              // ======================
              // PASSWORD FIELD
              // ======================
              _buildInputField("Password", obscureText: true),

              const SizedBox(height: 20),

              // ======================
              // LOGIN BUTTON
              // ======================
              SizedBox(
                width: double.infinity,

                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,

                    foregroundColor: Colors.white,

                    padding: const EdgeInsets.symmetric(vertical: 14),

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),

                  onPressed: () {
                    Navigator.pushNamed(context, "/home");
                  },

                  child: const Text("Login"),
                ),
              ),

              // ======================
              // SPACE BOTTOM
              // ======================
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // ======================
  // CUSTOM INPUT FIELD
  // ======================
  static Widget _buildInputField(String hint, {bool obscureText = false}) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromRGBO(199, 186, 157, 1),

        borderRadius: BorderRadius.circular(12),
      ),

      child: TextField(
        obscureText: obscureText,

        decoration: InputDecoration(
          hintText: hint,

          border: InputBorder.none,

          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,

            vertical: 16,
          ),
        ),
      ),
    );
  }
}
