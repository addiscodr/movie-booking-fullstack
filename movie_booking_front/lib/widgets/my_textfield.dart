import 'package:flutter/material.dart';

class MyTextfield extends StatelessWidget {
  final String hintText;
  final bool obscureText;
  final TextEditingController controller;

  const MyTextfield({
    super.key,
    required this.hintText,
    required this.obscureText,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: TextField(
        style: TextStyle(color: Colors.white),
        obscureText: obscureText,
        controller: controller,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white30),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white70),
          ),
          fillColor: Colors.white54,
          filled: true,
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.white70),
        ),
      ),
    );
  }
}
