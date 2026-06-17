import 'package:flutter/material.dart';
import 'package:movie_booking_front/screens/bottomnav_screen.dart';
import 'package:movie_booking_front/screens/signup_screen.dart';
import 'package:movie_booking_front/services/auth_service.dart';
import 'package:movie_booking_front/widgets/my_button.dart';
import 'package:movie_booking_front/widgets/my_textfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required Null Function() onTap});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool loading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> login() async {
    if (emailController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text(
            "All fields are required",
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
      final user = await AuthService().signIn(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      if (user != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            content: Text("Login successful", style: TextStyle(fontSize: 21)),
          ),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const BottomnavScreen()),
        );
      }
    } catch (e) {
      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Error"),
          content: Text(e.toString()),
        ),
      );
    }

    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            const Text(
              "Sign In",

              style: TextStyle(
                color: Colors.red,
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 50),

            MyTextfield(
              hintText: "Email",
              obscureText: false,
              controller: emailController,
            ),

            const SizedBox(height: 15),

            MyTextfield(
              hintText: "Password",
              obscureText: true,
              controller: passwordController,
            ),

            const SizedBox(height: 30),

            loading
                ? const CircularProgressIndicator(color: Colors.red)
                : MyButton(text: "Login", onTap: login),
            const SizedBox(height: 10),

            Container(
              margin: EdgeInsets.only(right: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text(
                    "Don't have an account? ",
                    style: TextStyle(color: Colors.white),
                  ),

                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => SignupScreen()),
                      );
                    },
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(
                        color: Colors.blue,
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
    );
  }
}
