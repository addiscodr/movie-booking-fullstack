import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:movie_booking_front/services/database.dart';
import 'package:movie_booking_front/services/shared_prefs.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // SIGN UP
  Future<User?> signUp(String name, String email, String password) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = credential.user;

      if (user != null) {
        Map<String, dynamic> userInfoMap = {
          "Id": user.uid,
          "Name": name,
          "Email": email,
        };

        // Save to Firestore
        await DatabaseMethods().addUserDetails(userInfoMap, user.uid);

        // Save locally
        await SharedPreferencesHelper.saveUserId(user.uid);

        await SharedPreferencesHelper.saveUserName(name);

        await SharedPreferencesHelper.saveUserEmail(email);
      }

      return user;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  // LOGIN
  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = credential.user;
      if (user != null) {
        // Fetch user data from Firestore to populate SharedPreferences
        var doc = await FirebaseFirestore.instance
            .collection("users")
            .doc(user.uid)
            .get();
        if (doc.exists) {
          await SharedPreferencesHelper.saveUserId(user.uid);
          await SharedPreferencesHelper.saveUserName(
            doc.data()?['Name'] ?? "Guest",
          );
          await SharedPreferencesHelper.saveUserEmail(
            doc.data()?['Email'] ?? email,
          );
        }
      }
      return user;
    } catch (e) {
      rethrow;
    }
  }

  // SIGN OUT
  Future<void> signOut() async {
    await _auth.signOut();
    await SharedPreferencesHelper.clearAllData();
  }

  // DELETE USER
  Future deleteUser() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      String uid = user.uid;
      await user.delete();

      // Optional: Remove user doc from your Firestore collection matching rules 
      await FirebaseFirestore.instance.collection("users").doc(uid).delete();
      await SharedPreferencesHelper.clearAllData();
    }
  }
}
