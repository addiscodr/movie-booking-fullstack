import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String text;
  final void Function()? onTap;
  const MyButton({super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.redAccent,
          borderRadius: BorderRadius.circular(30),
        ),
        padding: EdgeInsets.all(20),
        margin: EdgeInsets.symmetric(horizontal: 25),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
