import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:movie_booking_front/services/qrcode_scanner.dart';

class VerifyQrScreen extends StatefulWidget {
  const VerifyQrScreen({super.key});

  @override
  State<VerifyQrScreen> createState() => _VerifyQrScreenState();
}

class _VerifyQrScreenState extends State<VerifyQrScreen> {
  final String collectionName = "allqrcode";
  final String documentId = "qSQc2FXUp3nSIYpJpXft";
  final String arrayField = "QrCode";
  List<dynamic>? array;

  Future<List?> fetchArray() async {
    try {
      // Reference to the specific document
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection("allqrcode")
          .doc("qSQc2FXUp3nSIYpJpXft")
          .get();

      if (snapshot.exists) {
        array = snapshot[arrayField];
        return array;
      } else {
        throw "Document doesn't exist";
      }
    } catch (e) {
      debugPrint("Error fetching array: $e");
      return [];
    }
  }

  @override
  void initState() {
    super.initState();
    fetchArray();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: 90),
        child: Column(
          children: [
            Center(
              child: Image.asset(
                "assets/images/qr-code.png",
                height: 350,
                width: 350,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 80),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        QrCodeScanner(qrcodedata: array ?? []),
                  ),
                );
              },
              child: Material(
                elevation: 5,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: 250,
                  height: 80,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white54, width: 2),
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      "Scan QR Code",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
