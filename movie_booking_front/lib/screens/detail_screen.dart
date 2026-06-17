import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:movie_booking_front/services/database.dart';
import 'package:movie_booking_front/services/shared_prefs.dart';
import 'package:random_string/random_string.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DetailScreen extends StatefulWidget {
  final String movieImage;
  final String movieName;
  final String movieShortDetail;
  final String movieDetail;
  final String movieAdmissionFee;

  const DetailScreen({
    super.key,
    required this.movieImage,
    required this.movieName,
    required this.movieShortDetail,
    required this.movieDetail,
    required this.movieAdmissionFee,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  String? id;
  String? userName;
  Map<String, dynamic>? paymentIntent;
  late final List<String> dates;
  String? currentDate;
  bool isLoadingPrefs = true; // Added to manage loading states elegantly

  void getTheSharedPref() async {
    try {
      final savedId = SharedPreferencesHelper.getUserId();
      final savedName = SharedPreferencesHelper.getUserName();

      if (mounted) {
        setState(() {
          id = (savedId != null && savedId.isNotEmpty) ? savedId : null;
          userName = savedName ?? "Guest";
          isLoadingPrefs = false;
        });
      }
    } catch (e) {
      debugPrint("Error loading shared prefs: $e");
      if (mounted) {
        setState(() {
          id = null;
          userName = "Guest";
          isLoadingPrefs = false;
        });
      }
    }
  }

  List<String> getFormattedDates() {
    final now = DateTime.now();
    final formatter = DateFormat('EEE d');
    return List.generate(7, (index) {
      final date = now.add(Duration(days: index));
      return formatter.format(date);
    });
  }

  int track = 0;
  int quantity = 1;
  int total = 0;
  String selectedTimeSlot = "02:00 PM";

  @override
  void initState() {
    super.initState();
    getTheSharedPref();
    dates = getFormattedDates();
    currentDate = dates.isNotEmpty ? dates.first : null;
    total = int.tryParse(widget.movieAdmissionFee) ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    final feePerTicket = int.tryParse(widget.movieAdmissionFee) ?? 0;

    // ✅ FIXED: Show loader ONLY while pulling preferences, not permanently if ID is null
    if (isLoadingPrefs) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator(color: Colors.redAccent)),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            Image.asset(
              widget.movieImage,
              height: MediaQuery.of(context).size.height / 2,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            ),
            Positioned(
              // Use Positioned inside a Stack
              top: 40,
              left: 20,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.arrow_back, color: Colors.black),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 20, left: 20, right: 10),
              margin: EdgeInsets.only(
                top: MediaQuery.of(context).size.height / 2.5,
              ),
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: Color(0xff1e232c),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.movieName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      widget.movieShortDetail,
                      style: const TextStyle(
                        color: Color.fromARGB(174, 255, 255, 255),
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      widget.movieDetail,
                      style: const TextStyle(
                        color: Color.fromARGB(174, 255, 255, 255),
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Select Date",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 7),
                    SizedBox(
                      height: 55,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: dates.length,
                        itemBuilder: (context, index) {
                          final isSelected = track == index;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                track = index;
                                currentDate = dates[index];
                              });
                            },
                            child: Container(
                              width: 100,
                              margin: const EdgeInsets.only(right: 20),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? Colors.redAccent
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.grey,
                                  width: 2,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  dates[index],
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.grey,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      "Select Time Slot",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        timeSlotWidget(
                          "02:00 PM",
                          selectedTimeSlot == "02:00 PM",
                          () => setState(() => selectedTimeSlot = "02:00 PM"),
                        ),
                        timeSlotWidget(
                          "04:00 PM",
                          selectedTimeSlot == "04:00 PM",
                          () => setState(() => selectedTimeSlot = "04:00 PM"),
                        ),
                        timeSlotWidget(
                          "06:00 PM",
                          selectedTimeSlot == "06:00 PM",
                          () => setState(() => selectedTimeSlot = "06:00 PM"),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Row(
                      children: [
                        Container(
                          width: 140,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  if (quantity > 1) {
                                    setState(() {
                                      quantity--;
                                      total = quantity * feePerTicket;
                                    });
                                  }
                                },
                                child: const Icon(
                                  Icons.remove,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                quantity.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    quantity++;
                                    total = quantity * feePerTicket;
                                  });
                                },
                                child: const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 20),
                        GestureDetector(
                          onTap: () {
                            // ✅ Informative fallback warning instead of hard layout bricking
                            if (id == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Account missing! Please login again to sync booking data.",
                                  ),
                                  backgroundColor: Colors.orange,
                                ),
                              );
                            }
                            makePayment(total.toString());
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.redAccent,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            width: 200,
                            child: Column(
                              children: [
                                Text(
                                  "Total : \$$total",
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const Text(
                                  "Book Now",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 23,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget timeSlotWidget(String time, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.redAccent : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? Colors.white : Colors.redAccent,
            width: 2,
          ),
        ),
        child: Text(
          time,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.redAccent,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  // --- STRIPE SDK INTEGRATION METHODS ---
  Future<void> makePayment(String amount) async {
    try {
      final paymentData = await createPaymentIntent(amount);

      if (paymentData != null &&
          (paymentData['clientSecret'] != null ||
              paymentData['client_secret'] != null)) {
        final String secret =
            paymentData['clientSecret'] ?? paymentData['client_secret'];

        await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
            paymentIntentClientSecret: secret,
            style: ThemeMode.dark,
            merchantDisplayName: 'Movie Booking',
          ),
        );

        await displayPaymentSheet();
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Payment sheet config failed. Server response invalid.",
            ),
          ),
        );
      }
    } catch (e) {
      debugPrint("❌ Unexpected Error: $e");
    }
  }

  Future<Map<String, dynamic>?> createPaymentIntent(
    String amountInDollars,
  ) async {
    try {
      final int centsAmount = (int.tryParse(amountInDollars) ?? 0) * 100;
      final response = await http.post(
        Uri.parse('http://10.0.2.2:3030/create-payment-intent'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'amount': centsAmount}),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<void> displayPaymentSheet() async {
    try {
      // 1. Present sheet first
      await Stripe.instance.presentPaymentSheet();

      // 2. Setup your document payloads
      String uniqueId = randomAlphaNumeric(5);
      String finalSelectedDate =
          currentDate ?? (dates.isNotEmpty ? dates.first : "No Date Selected");

      Map<String, dynamic> userMovieMap = {
        "MovieName": widget.movieName,
        "MovieImage": widget.movieImage,
        "MovieDate": finalSelectedDate,
        "MovieTime": selectedTimeSlot,
        "TicketQuantity": quantity.toString(),
        "Total": total.toString(),
        "QrId": uniqueId,
        "Username": userName,
        "Timestamp": FieldValue.serverTimestamp(),
      };

      String activeUid = id ?? "guest_user_${randomAlphaNumeric(4)}";

      // ✅ Inner try-catch protects against showing success if the DB fails
      try {
        await DatabaseMethods().addUserBooking(userMovieMap, activeUid);
        await DatabaseMethods().addQrId(uniqueId);

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            content: Text(
              "Booking has been successful",
              style: TextStyle(fontSize: 21),
            ),
          ),
        );
      } catch (dbError) {
        debugPrint("❌ Firestore Failed: $dbError");
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              "Payment completed, but cloud saving failed: $dbError",
            ),
          ),
        );
      }
    } on StripeException catch (e) {
      debugPrint('Stripe Page Cancelled/Failed: ${e.error.localizedMessage}');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Payment Cancelled: ${e.error.localizedMessage ?? 'User exited.'}",
          ),
        ),
      );
    } catch (e) {
      debugPrint('❌ Unexpected Operation Aborted: $e');
    }
  }
}
