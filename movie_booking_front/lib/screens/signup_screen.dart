import 'package:flutter/material.dart';
import 'package:movie_booking_front/screens/bottomnav_screen.dart';
import 'package:movie_booking_front/screens/login_screen.dart';
import 'package:movie_booking_front/services/auth_service.dart';
import 'package:movie_booking_front/widgets/my_button.dart';
import 'package:movie_booking_front/widgets/my_textfield.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController nameController = TextEditingController();

  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  bool loading = false;

  void signup() async {
    if (nameController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text(
            "Please fill in all fields",
            style: TextStyle(fontSize: 21),
          ),
        ),
      );
      return;
    }
    setState(() {
      loading = true;
    });

    try {
      await AuthService().signUp(
        nameController.text.trim(),
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: Text("Signup successful", style: TextStyle(fontSize: 21)),
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const BottomnavScreen()),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        // Added to avoid bottom overflow when keyboard shows up
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 80.0),
          child: Container(
            margin: EdgeInsets.only(top: 150),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Sign Up",
                  style: TextStyle(color: Colors.redAccent, fontSize: 36),
                ),
                const SizedBox(height: 50),
                MyTextfield(
                  controller: nameController,
                  obscureText: false,
                  hintText: "Username",
                ),
                const SizedBox(height: 12),
                MyTextfield(
                  controller: emailController,
                  obscureText: false,
                  hintText: "Email",
                ),
                const SizedBox(height: 12),
                MyTextfield(
                  controller: passwordController,
                  obscureText: true,
                  hintText: "Password",
                ),
                const SizedBox(height: 30),

                // Show a loading spinner if the request is processing, otherwise show the button
                loading
                    ? const CircularProgressIndicator(color: Colors.redAccent)
                    : MyButton(
                        onTap:
                            signup, // Fixed: Pointing to the signup function now!
                        text: "Register",
                      ),
                const SizedBox(height: 10),

                Container(
                  margin: EdgeInsets.only(right: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "Already have an account? ",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginScreen(onTap: () {}),
                            ),
                          );
                        },
                        child: Text(
                          "Sign In",
                          style: TextStyle(
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
