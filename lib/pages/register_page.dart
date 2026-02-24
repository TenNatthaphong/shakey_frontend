import 'package:flutter/material.dart';
import 'package:shakey/app_color.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _acceptTerms = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primaryRed,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                // 1. Background top section (cream)
                Container(height: 340, color: const Color(0xFFFDF7E6)),
                // 2. Milkshake image (on top of cream)
                Positioned(
                  top: 60,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Image.asset(
                      'assets/images/Strawberry.png',
                      height: 220,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                // 3. Red section with wave (on top of image)
                ClipPath(
                  clipper: _RegisterWaveClipper(),
                  child: Container(height: 340, color: AppColor.primaryRed),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'REGISTER',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildLabel('Name'),
                  _buildTextField(hint: 'Name'),
                  const SizedBox(height: 14),
                  _buildLabel('Surname'),
                  _buildTextField(hint: 'Surname'),
                  const SizedBox(height: 14),
                  _buildLabel('Tel.'),
                  _buildTextField(hint: 'Tel.'),
                  const SizedBox(height: 14),
                  _buildLabel('Email'),
                  _buildTextField(hint: 'Email'),
                  const SizedBox(height: 14),
                  _buildLabel('Password'),
                  _buildTextField(hint: 'Password', isPassword: true),
                  const SizedBox(height: 14),
                  _buildLabel('Confirm Password'),
                  _buildTextField(hint: 'Confirm Password', isPassword: true),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Checkbox(
                        value: _acceptTerms,
                        onChanged: (val) =>
                            setState(() => _acceptTerms = val ?? false),
                        side: const BorderSide(color: Colors.white),
                        checkColor: AppColor.primaryRed,
                        activeColor: Colors.white,
                      ),
                      const Expanded(
                        child: Text(
                          'I accept terms of the agreement',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: SizedBox(
                      width: 180,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _acceptTerms
                            ? () {
                                Navigator.of(context).pop();
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppColor.primaryRed,
                          shape: const StadiumBorder(),
                        ),
                        child: const Text(
                          'REGISTER',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: const Text.rich(
                        TextSpan(
                          text: 'Already have an account? ',
                          style: TextStyle(color: Colors.white, fontSize: 13),
                          children: [
                            TextSpan(
                              text: 'Sign in',
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildTextField({required String hint, bool isPassword = false}) {
    return TextField(
      obscureText: isPassword,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 16,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.white, width: 2),
        ),
      ),
    );
  }
}

class _RegisterWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    // Start at bottom left
    path.moveTo(0, size.height);
    // Go up to the wave start
    path.lineTo(0, size.height - 40);
    // Draw the top edge (the wave)
    var firstControlPoint = Offset(size.width / 4, size.height - 90);
    var firstEndPoint = Offset(size.width / 2, size.height - 40);
    path.quadraticBezierTo(
      firstControlPoint.dx,
      firstControlPoint.dy,
      firstEndPoint.dx,
      firstEndPoint.dy,
    );

    var secondControlPoint = Offset(size.width * 3 / 4, size.height + 10);
    var secondEndPoint = Offset(size.width, size.height - 40);
    path.quadraticBezierTo(
      secondControlPoint.dx,
      secondControlPoint.dy,
      secondEndPoint.dx,
      secondEndPoint.dy,
    );
    // Go down to bottom right
    path.lineTo(size.width, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
