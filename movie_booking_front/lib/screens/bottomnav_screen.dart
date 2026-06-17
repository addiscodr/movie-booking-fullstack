import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:movie_booking_front/screens/booking_screen.dart';
import 'package:movie_booking_front/screens/home_screen.dart';
import 'package:movie_booking_front/screens/profile_screen.dart';

class BottomnavScreen extends StatefulWidget {
  const BottomnavScreen({super.key});

  @override
  State<BottomnavScreen> createState() => _BottomnavScreenState();
}

class _BottomnavScreenState extends State<BottomnavScreen> {
  late List<Widget> screens;

  late HomeScreen home;
  late BookingScreen booking;
  late ProfileScreen profile;

  int currentTabIndex = 0;

  @override
  void initState() {
    super.initState();
    home = HomeScreen();
    booking = BookingScreen();
    profile = ProfileScreen();
    screens = [home, booking, profile];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.black,
        color: Colors.red,

        //color: Color.fromARGB(255, 204, 151, 7),
        animationDuration: Duration(milliseconds: 500),
        onTap: (int index) {
          setState(() {
            currentTabIndex = index;
          });
        },
        items: [
          Icon(Icons.home, color: Colors.white, size: 30),
          Icon(Icons.book, color: Colors.white, size: 30),
          Icon(Icons.person, color: Colors.white, size: 30),
        ],
      ),
      body: screens[currentTabIndex],
    );
  }
}
