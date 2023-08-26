import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return OverlaySupport(
      child: MaterialApp(
        title: 'Easy Task',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          textTheme: GoogleFonts.openSansTextTheme(),
        ),
        home: const LoginPage(),
      ),
    );
  }
}
