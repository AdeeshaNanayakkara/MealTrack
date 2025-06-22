import 'package:flutter/material.dart';
//import 'package:flutter/scheduler.dart' show timeDilation;
// For ImageFilter.blur, though not used in this exact design.

// Import your actual LoginScreen from its specified path
import 'package:eatro/Feature/Auth/pages/login.dart'; // <--- THIS IS YOUR LOGIN SCREEN IMPORT

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food Habit App',
      theme: ThemeData(
        primarySwatch: Colors.blue, // A default primary color for MaterialApp
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // Define the theme colors – easily changeable!
  static const Map<String, Color> theme = {
    'primary': Color(0xFF5B79FF), // Main brand color for loader
    'secondary': Color(0xFFFFFFFF), // Background color
  };

  @override
  void initState() {
    super.initState();
    // Navigate to the LoginScreen after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      // Changed back to 3 seconds
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => const LoginPage(),
          ), // Navigating to your LoginScreen
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions for responsive design
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: theme['secondary'], // Clean white background
      body: Center(
        // Center the entire Column horizontally and vertically
        child: Column(
          mainAxisAlignment: MainAxisAlignment
              .center, // Center content vertically within the Column
          crossAxisAlignment: CrossAxisAlignment
              .center, // Center content horizontally within the Column
          children: [
            // Logo Image Placeholder
            Image.asset(
              'lib/assets/app_name.png', // Sample asset path for the app logo
              width: size.width * 0.55, // Responsive width
              height: size.width * 0.55, // Keep aspect ratio
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                // Fallback for image loading error or if asset is not found
                return Container(
                  width: size.width * 0.35,
                  height: size.width * 0.35,
                  color: Colors.grey[200],
                  child: Center(
                    child: Icon(
                      Icons.fastfood,
                      size: size.width * 0.2,
                      color: Colors.grey[600],
                    ), // Sample food icon
                  ),
                );
              },
            ),
            SizedBox(
              height: size.height * 0.05,
            ), // Space between logo and loader
            // Vertical Loading Animation (LinearProgressIndicator rotated)
            RotatedBox(
              quarterTurns: 0, // Rotate by 270 degrees to make it vertical
              child: SizedBox(
                width: size.height * 0.2, // Length of the vertical bar
                height: 5, // Thickness of the bar
                child: LinearProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(theme['primary']!),
                  backgroundColor: theme['primary']!.withOpacity(0.3),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// No LoginScreen code is included here.
// It is expected to be in 'lib/Feature/Auth/pages/login.dart'.
