import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:movie_booking_front/services/database.dart';
import 'package:movie_booking_front/services/shared_prefs.dart';
import 'package:qr_flutter/qr_flutter.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  Stream? bookingStream;
  String? id;
  String? userName;
  bool isLoading = true; // Added to manage initial loading state

  Future<void> getTheSharedPref() async {
    try {
      id = SharedPreferencesHelper.getUserId();

      userName = SharedPreferencesHelper.getUserName();
    } catch (e) {
      debugPrint("Error loading shared prefs: $e");
    }
  }

  void getOnTheLoad() async {
    await getTheSharedPref();

    if (id == null) {
      setState(() {
        isLoading = false;
      });

      return;
    }

    bookingStream = await DatabaseMethods().getBooking(id!);

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getOnTheLoad();
  }

  Widget allBooking() {
    return StreamBuilder(
      stream: bookingStream,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              "Error: ${snapshot.error}",
              style: const TextStyle(color: Colors.white),
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data.docs.isEmpty) {
          return const Center(
            child: Text(
              "No bookings found.",
              style: TextStyle(color: Colors.white54, fontSize: 18),
            ),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: snapshot.data.docs.length,
          itemBuilder: (context, index) {
            DocumentSnapshot ds = snapshot.data.docs[index];

            // Safe fallback mapping for Firestore data fields
            String qrData = ds.data().toString().contains('QrId')
                ? ds["QrId"]
                : "No QR Id";
            String uName = ds.data().toString().contains('Username')
                ? ds["Username"]
                : userName ?? "User";
            String movieName = ds.data().toString().contains('MovieName')
                ? ds["MovieName"]
                : "Unknown Movie";
            String ticketQty = ds.data().toString().contains('TicketQuantity')
                ? ds["TicketQuantity"].toString()
                : "0";
            String totalAmount = ds.data().toString().contains('Total')
                ? ds["Total"].toString()
                : "0.00";

            return Container(
              margin: const EdgeInsets.only(
                bottom: 15,
              ), // Separates individual ticket containers
              padding: const EdgeInsets.all(20),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Center(
                    child: QrImageView(
                      data: qrData,
                      version: QrVersions.auto,
                      size: 100,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          ds["MovieImage"],
                          width: 110,
                          height: 110,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                                width: 110,
                                height: 110,
                                color: Colors.grey,
                                child: const Icon(
                                  Icons.movie,
                                  color: Colors.white,
                                ),
                              ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        // Wrapped in Expanded to prevent text overflow layout breaks
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.person_outline_outlined,
                                        color: Colors.black54,
                                      ),
                                      const SizedBox(width: 7),
                                      Text(
                                        uName,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.movie_outlined,
                                        color: Colors.black54,
                                      ),
                                      const SizedBox(width: 7),
                                      Text(
                                        movieName,
                                        style: const TextStyle(
                                          color: Colors.black54,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            Row(
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.group_outlined,
                                        color: Colors.black54,
                                      ),
                                      const SizedBox(width: 7),
                                      Text(
                                        ticketQty,
                                        style: const TextStyle(
                                          color: Colors.black54,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),

                                      const SizedBox(width: 15),

                                      Text(
                                        "\$$totalAmount",
                                        style: const TextStyle(
                                          color: Colors.black54,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.alarm, color: Colors.black54),
                                    const SizedBox(width: 7),
                                    Text(
                                      ds["MovieTime"],
                                      style: const TextStyle(
                                        color: Colors.black54,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 15),

                                    Icon(
                                      Icons.calendar_month,
                                      color: Colors.black54,
                                    ),
                                    const SizedBox(width: 7),
                                    Text(
                                      ds["MovieDate"],
                                      style: const TextStyle(
                                        color: Colors.black54,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
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
                "Booking",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(top: 20, left: 15, right: 15),
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  color: Color(0xff1e232c),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: isLoading
                    ? const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      )
                    : allBooking(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
