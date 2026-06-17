import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future addUserDetails(Map<String, dynamic> userInfoMap, String id) async {
    return await _firestore.collection("users").doc(id).set(userInfoMap);
  }

  Future<QuerySnapshot> getUserEmail(String email) async {
    return await _firestore
        .collection("users")
        .where("Email", isEqualTo: email)
        .get();
  }

  Future addUserBooking(Map<String, dynamic> userMovieMap, String id) async {
    return await _firestore
        .collection("users")
        .doc(id)
        .collection("bookings")
        .add(userMovieMap);
  }

  // FIX: Target the passed tracking variable, not the hardcoded string literal
  Future addQrId(String qrId) async {
    return await _firestore.collection("qr_codes").doc(qrId).set({
      "status": "valid",
      "createdAt": FieldValue.serverTimestamp(),
    });
  }

  // FIX: Fixed collection name mapping typo matching plural ("bookings")
  Future<Stream<QuerySnapshot>> getBooking(String id) async {
    return _firestore
        .collection("users")
        .doc(id)
        .collection("bookings")
        .snapshots();
  }
}
