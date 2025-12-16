import 'package:flutter/material.dart';

import 'screens/login_screen.dart';
import 'screens/register_screen.dart';

// NOTE: Dashboard is in THIS file as RAGStatusApp (Scaffold), not MaterialApp.

void main() {
  runApp(const AppRoot());
}

class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RAG Status Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: const Color(0xFFF9FAFB),
        fontFamily: 'Roboto',
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4F46E5),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF4F46E5), width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 1,
          iconTheme: IconThemeData(color: Color(0xFF6B7280)),
          titleTextStyle: TextStyle(
            color: Color(0xFF1F2937),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      initialRoute: '/login',
      routes: {
        '/login': (_) => const LoginScreen(),
        '/register': (_) => const RegisterationScreen(),
        '/dashboard': (_) => const RAGStatusApp(), // ✅ dashboard is a SCREEN now
      },
    );
  }
}

// -------------------------------
// DASHBOARD SCREEN (IN main.dart)
// -------------------------------
class RAGStatusApp extends StatelessWidget {
  const RAGStatusApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Replace this Scaffold with your full dashboard UI if you want.
    return Scaffold(
      appBar: AppBar(
        title: const Text('RAG Status'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(context, '/login', (r) => false);
            },
          )
        ],
      ),
      body: const Center(
        child: Text('Dashboard'),
      ),
    );
  }
}
