import 'package:flutter/material.dart';
import 'package:movie_booking_front/screens/login_screen.dart';
import 'package:movie_booking_front/screens/signup_screen.dart';
import 'package:movie_booking_front/services/auth_service.dart';
import 'package:movie_booking_front/services/shared_prefs.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  
  String? userName;
  String? userEmail;

  void getTheSharedPrefs() async {
    String? name = SharedPreferencesHelper.getUserName();
    String? email = SharedPreferencesHelper.getUserEmail();

    setState(() {
      userName = name;
      userEmail = email;
    });
  }

  @override
  void initState() {
    super.initState();
    getTheSharedPrefs();
  }

  Future<void> logout() async {
    bool? confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Logout"),
        content: const Text("Do you want to logout?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Logout"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await AuthService().signOut();

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SignupScreen()),
      );
    }
  }

  Future<void> deleteAccount() async {
    bool? confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Account"),
        content: const Text("This action is permanent. Are you sure?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Delete"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await AuthService().deleteUser();

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Account deleted successfully")),
        );

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen(onTap: () {})),
          (route) => false,
        );
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Failed to delete account: $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        margin: const EdgeInsets.only(top: 60),
        child: Column(
          children: [
            const Center(
              child: Text(
                "Profile",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),

            Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 50, left: 15, right: 15),
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    color: Color(0xff1e232c),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.only(
                      left: 10,
                      right: 10,
                      top: 20,
                      bottom: 20,
                    ),
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      children: [
                        Icon(
                          Icons.person_outline,
                          color: Colors.black,
                          size: 35,
                        ),
                        const SizedBox(width: 15),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Name",
                              style: TextStyle(
                                color: Colors.black38,
                                fontSize: 23,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              userName ?? "",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 23,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 20, left: 15, right: 15),
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    color: Color(0xff1e232c),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.only(
                      left: 10,
                      right: 10,
                      top: 20,
                      bottom: 20,
                    ),
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      children: [
                        Icon(Icons.logout, color: Colors.black, size: 35),
                        const SizedBox(width: 15),
                        GestureDetector(
                          onTap: logout,
                          child: Text(
                            "Logout",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Spacer(),
                        Icon(
                          Icons.arrow_forward_ios_outlined,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 20, left: 15, right: 15),
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    color: Color(0xff1e232c),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.only(
                      left: 10,
                      right: 10,
                      top: 20,
                      bottom: 20,
                    ),
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      children: [
                        Icon(
                          Icons.delete_outline,
                          color: Colors.black,
                          size: 35,
                        ),
                        const SizedBox(width: 15),
                        GestureDetector(
                          onTap: deleteAccount,
                          child: Text(
                            "Delete Account",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Spacer(),
                        Icon(
                          Icons.arrow_forward_ios_outlined,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
