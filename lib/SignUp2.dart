import 'package:flutter/material.dart';

class SignUpStep2 extends StatelessWidget {
  const SignUpStep2({super.key});

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

              // LOGO
              Center(
                child: Image.asset("assets/images/kopilogo.png", height: 150),
              ),

              const SizedBox(height: 40),

              // TITLE
              const Align(
                alignment: Alignment.centerLeft,

                child: Text(
                  "Sign Up",
<<<<<<< HEAD

=======
>>>>>>> b76c2bab9bed56e13967fba28559e5a0271d2960
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
              ),

              const SizedBox(height: 8),

              const Align(
                alignment: Alignment.centerLeft,

                child: Text(
                  "Let’s finalize your account setup!",

                  style: TextStyle(fontSize: 14, height: 1.3),
                ),
              ),

              const SizedBox(height: 24),

              // USERNAME
              _buildInputField("Username"),

              const SizedBox(height: 12),

              // PASSWORD
              _buildInputField("Password", obscureText: true),

              const SizedBox(height: 12),

              // CONFIRM PASSWORD
              _buildInputField("Confirm Password", obscureText: true),

              const SizedBox(height: 20),

              // BUTTON
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
<<<<<<< HEAD
                    Navigator.pushReplacementNamed(context, "/login");
=======
                    Navigator.pushNamed(context, "/login");
>>>>>>> b76c2bab9bed56e13967fba28559e5a0271d2960
                  },

                  child: const Text("Sign Up"),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // INPUT FIELD
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
