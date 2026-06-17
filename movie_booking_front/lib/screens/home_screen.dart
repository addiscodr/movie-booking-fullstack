import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:movie_booking_front/screens/detail_screen.dart';
import 'package:movie_booking_front/services/shared_prefs.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> imageUrls = [
    "assets/images/lord_of_the_rings.png",
    "assets/images/bourne_identity.png",
    "assets/images/machete_kills.png",
    "assets/images/die_hard.png",
    "assets/images/gladiator.png",
  ];

  String? userId;
  String? userName;
  String? userEmail;

  void getTheSharedPrefs() async {
    userId = SharedPreferencesHelper.getUserId();
    userName = SharedPreferencesHelper.getUserName();
    userEmail = SharedPreferencesHelper.getUserEmail();
    setState(() {});

    debugPrint("USER ID: $userId");
    debugPrint("USERNAME: $userName");
    debugPrint("EMAIL: $userEmail");

    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    getTheSharedPrefs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        margin: EdgeInsets.only(top: 60, left: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "Hello, ${userName ?? 'Guest'}",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              "Welcome to",
              style: TextStyle(
                color: const Color.fromARGB(186, 255, 255, 255),
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              children: [
                Text(
                  "Premier",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  "Movies",
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Center(
              child: CarouselSlider(
                items: imageUrls.map((url) {
                  return Builder(
                    builder: (BuildContext context) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(url, fit: BoxFit.cover),
                      );
                    },
                  );
                }).toList(),
                options: CarouselOptions(
                  height: 250,
                  autoPlay: true,
                  enlargeCenterPage: true,
                  aspectRatio: 16 / 9,
                  viewportFraction: 1,
                ),
              ),
            ),
            const SizedBox(height: 25),
            Text(
              "Trending Movies",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 230,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailScreen(
                            movieImage: "assets/images/lord_of_the_rings.png",
                            movieName: "Lord of the Rings",
                            movieShortDetail: "Action, Adventure",
                            movieDetail:
                                "The Lord of the Rings is an epic high-fantasy novel by J.R.R. Tolkien. Set in the mythical world of Middle-earth, the story follows a meek hobbit, Frodo Baggins, and a diverse fellowship on a perilous quest to destroy the One Ring, an artifact of immense power that can corrupt anyone who holds it.",
                            movieAdmissionFee: "5",
                          ),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.asset(
                              "assets/images/lord_of_the_rings.png",
                              height: 200,
                              width: 200,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 10),
                            margin: EdgeInsets.only(top: 160),
                            width: 200,
                            decoration: BoxDecoration(
                              color: Colors.black45,
                              borderRadius: BorderRadius.circular(20),
                            ),

                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Lord of the Rings",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 23,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "Action, Adventure",
                                  style: TextStyle(
                                    color: const Color.fromARGB(
                                      200,
                                      255,
                                      255,
                                      255,
                                    ),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailScreen(
                            movieImage: "assets/images/bourne_identity.png",
                            movieName: "Bourne Identity",
                            movieShortDetail: "Action, Adventure",
                            movieDetail:
                                "The Bourne Identity is a 2002 action-thriller directed by Doug Liman. It follows an amnesiac man (Matt Damon) found near death by a fishing boat. As he struggles to unlock his past, he discovers he possesses lethal combat skills and is being hunted by a clandestine CIA operation.",
                            movieAdmissionFee: "5",
                          ),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.asset(
                              "assets/images/bourne_identity.png",
                              height: 200,
                              width: 200,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 10),
                            margin: EdgeInsets.only(top: 160),
                            width: 200,
                            decoration: BoxDecoration(
                              color: Colors.black45,
                              borderRadius: BorderRadius.circular(20),
                            ),

                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Bourne Identity",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 23,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "Action, Adventure",
                                  style: TextStyle(
                                    color: const Color.fromARGB(
                                      200,
                                      255,
                                      255,
                                      255,
                                    ),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailScreen(
                            movieImage: "assets/images/machete_kills.png",
                            movieName: "Machete Kills",
                            movieShortDetail: "Action, Adventure",
                            movieDetail:
                                "Machete Kills (2013) is an over-the-top action-comedy written and directed by Robert Rodriguez. The film follows legendary ex-federale Machete Cortez (Danny Trejo), who is recruited by the U.S. President to stop a mad revolutionary and an eccentric billionaire arms dealer from launching a nuclear weapon into space.",
                            movieAdmissionFee: "5",
                          ),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.asset(
                              "assets/images/machete_kills.png",
                              height: 200,
                              width: 200,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 10),
                            margin: EdgeInsets.only(top: 160),
                            width: 200,
                            decoration: BoxDecoration(
                              color: Colors.black45,
                              borderRadius: BorderRadius.circular(20),
                            ),

                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Machete Kills",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 23,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "Action, Adventure",
                                  style: TextStyle(
                                    color: const Color.fromARGB(
                                      200,
                                      255,
                                      255,
                                      255,
                                    ),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),

                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailScreen(
                            movieImage: "assets/images/die_hard.png",
                            movieName: "Die Hard",
                            movieShortDetail: "Action, Adventure",
                            movieDetail:
                                "Die Hard is a critically acclaimed 1988 American action film directed by John McTiernan. It follows New York City police detective John McClane (Bruce Willis) who visits Los Angeles on Christmas Eve, only to become the lone hope when a group of heavily armed terrorists takes over a corporate skyscraper.",
                            movieAdmissionFee: "5",
                          ),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.asset(
                              "assets/images/die_hard.png",
                              height: 200,
                              width: 200,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 10),
                            margin: EdgeInsets.only(top: 160),
                            width: 200,
                            decoration: BoxDecoration(
                              color: Colors.black45,
                              borderRadius: BorderRadius.circular(20),
                            ),

                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Die Hard",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 23,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "Action, Adventure",
                                  style: TextStyle(
                                    color: const Color.fromARGB(
                                      200,
                                      255,
                                      255,
                                      255,
                                    ),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailScreen(
                            movieImage: "assets/images/gladiator.png",
                            movieName: "Gladiator",
                            movieShortDetail: "Action, Adventure",
                            movieDetail:
                                "The Avengers and their allies must be willing to sacrifice all in an attempt to defeat the powerful Thanos before his blitz of devastation and ruin puts an end to the universe.",
                            movieAdmissionFee: "5",
                          ),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.asset(
                              "assets/images/gladiator.png",
                              height: 200,
                              width: 200,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 10),
                            margin: EdgeInsets.only(top: 160),
                            width: 200,
                            decoration: BoxDecoration(
                              color: Colors.black45,
                              borderRadius: BorderRadius.circular(20),
                            ),

                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Gladiator",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 23,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "Action, Adventure",
                                  style: TextStyle(
                                    color: const Color.fromARGB(
                                      200,
                                      255,
                                      255,
                                      255,
                                    ),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
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
