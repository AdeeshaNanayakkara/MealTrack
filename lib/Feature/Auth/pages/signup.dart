import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sign Up Form',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple, // Main theme color for app bar etc.
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey[100], // Light grey background for text fields
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0), // Rounded corners
            borderSide: BorderSide.none, // No border line
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16.0,
            horizontal: 16.0,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple, // Button background color
            foregroundColor: Colors.white, // Button text color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                10.0,
              ), // Rounded corners for button
            ),
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            textStyle: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      home: const SignUpScreen(),
    );
  }
}

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  // Function to build a labeled text field
  Widget _buildTextField({
    required String labelText,
    required String hintText,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    Widget? suffixIcon,
    double bottomPadding = 20.0, // Added a parameter for bottom padding
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            labelText,
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hintText,
            suffixIcon: suffixIcon,
          ),
        ),
        SizedBox(height: bottomPadding), // Use the parameter for spacing
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _buildTextField(
              labelText: 'Name',
              hintText: 'Enter name',
              controller: _nameController,
            ),
            _buildTextField(
              labelText: 'Email',
              hintText: 'Enter email',
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
            ),
            _buildTextField(
              labelText: 'Password',
              hintText: 'Enter password',
              controller: _passwordController,
              obscureText: !_isPasswordVisible,
              suffixIcon: IconButton(
                icon: Icon(
                  _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  color: Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              ),
            ),
            // Group Weight, Height, and Age horizontally
            Row(
              crossAxisAlignment:
                  CrossAxisAlignment.start, // Align labels at the top
              children: [
                Expanded(
                  child: _buildTextField(
                    labelText: 'Weight (Kg)',
                    hintText: 'Enter weight',
                    controller: _weightController,
                    keyboardType: TextInputType.number,
                    bottomPadding: 0.0, // No bottom padding for fields in a row
                  ),
                ),
                const SizedBox(width: 16.0), // Horizontal spacing
                Expanded(
                  child: _buildTextField(
                    labelText: 'Height (cm)',
                    hintText: 'Enter height',
                    controller: _heightController,
                    keyboardType: TextInputType.number,
                    bottomPadding: 0.0,
                  ),
                ),
                const SizedBox(width: 16.0), // Horizontal spacing
                Expanded(
                  child: _buildTextField(
                    labelText: 'Age',
                    hintText: 'Enter age',
                    controller: _ageController,
                    keyboardType: TextInputType.number,
                    bottomPadding: 0.0,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30.0), // Spacing after the horizontal row

            ElevatedButton(
              onPressed: () {
                // TODO: Implement sign up logic here
                print('Sign Up button pressed!');
                print('Name: ${_nameController.text}');
                print('Email: ${_emailController.text}');
                print('Password: ${_passwordController.text}');
                print('Weight: ${_weightController.text}');
                print('Height: ${_heightController.text}');
                print('Age: ${_ageController.text}');
              },
              child: const Text('Sign up'),
            ),
            const SizedBox(height: 20.0),
            Center(
              child: Text(
                'OR SIGN UP WITH',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            Center(
              child: GestureDetector(
                onTap: () {
                  // TODO: Implement Google sign up logic
                  print('Google Sign Up button pressed!');
                },
                child: Container(
                  width: 50.0,
                  height: 50.0,
                  decoration: BoxDecoration(
                    color: Colors.red, // Google's primary color
                    borderRadius: BorderRadius.circular(
                      25.0,
                    ), // Circular button
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      'G',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Already have an account? ',
                  style: TextStyle(fontSize: 16.0),
                ),
                GestureDetector(
                  onTap: () {
                    // TODO: Navigate to sign-in screen
                    print('Sign in link pressed!');
                  },
                  child: const Text(
                    'Sign in',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple, // Highlight "Sign in" text
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20.0), // Bottom padding
          ],
        ),
      ),
    );
  }
}
