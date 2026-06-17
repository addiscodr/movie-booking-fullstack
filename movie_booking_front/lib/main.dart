import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:movie_booking_front/firebase_options.dart';
import 'package:movie_booking_front/screens/signup_screen.dart';
import 'package:movie_booking_front/services/shared_prefs.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    await SharedPreferencesHelper.init();

    await dotenv.load(fileName: ".env");

    Stripe.publishableKey = dotenv.env['STRIPE_PUBLISHABLE_KEY'] ?? "";

    await Stripe.instance.applySettings();
  } catch (e) {
    debugPrint("$e");
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Movie Booking',
      theme: ThemeData.dark(),
      home: const SignupScreen(),
    );
  }
}
