import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:shakey/app_color.dart';
import 'package:shakey/router.dart';
import 'package:shakey/services/auth_service.dart';
import 'package:shakey/services/language_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscurePassword = true;
  bool _isLoading = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _lang = LanguageService.instance;

  @override
  void initState() {
    super.initState();
    _lang.addListener(_onLanguageChanged);
  }

  void _onLanguageChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _lang.removeListener(_onLanguageChanged);
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _onLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_lang.get('enter_email_password'))),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await AuthService.instance.login(email: email, password: password);
      if (mounted) {
        if (!AuthService.instance.hasPin) {
          Navigator.of(context).pushReplacementNamed(
            AppRoutes.pinPage,
            arguments: {'isSetting': true},
          );
        } else {
          Navigator.of(context).pushReplacementNamed(AppRoutes.homePage);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString().replaceAll('Exception: ', ''))),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _onRegister() {
    Navigator.of(context).pushNamed(AppRoutes.registerPage);
  }

  Future<void> _onGoogleLogin() async {
    setState(() => _isLoading = true);
    try {
      await AuthService.instance.signInWithGoogle();
      if (mounted) {
        if (!AuthService.instance.hasPin) {
          Navigator.of(context).pushReplacementNamed(
            AppRoutes.pinPage,
            arguments: {'isSetting': true},
          );
        } else {
          Navigator.of(context).pushReplacementNamed(AppRoutes.homePage);
        }
      }
    } catch (e) {
      if (mounted) {
        _showUnsuccessfulLoginDialog(
          e.toString().replaceAll('Exception: ', ''),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showUnsuccessfulLoginDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: const BoxDecoration(
                  color: Color(0xFFFFEBEE),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.error_outline_rounded,
                  color: AppColor.primaryRed,
                  size: 50,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Unsuccessful Login',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2F2F34),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                message,
                style: const TextStyle(
                  fontSize: 15,
                  color: Color(0xFF8A909C),
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primaryRed,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'OK',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    return Scaffold(
      backgroundColor: AppColor.primaryRed,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final availableHeight = constraints.maxHeight;
            final topHeight = (availableHeight * 0.44).clamp(320.0, 390.0);
            final fitScale = (availableHeight / 920).clamp(0.68, 1.0);
            final imageHeight = (428.0 * fitScale).clamp(338.0, 428.0);
            final imageTop = (-6.0 * fitScale).clamp(-10.0, -4.0);
            final imageShiftX = (56.0 * fitScale).clamp(48.0, 56.0);
            final imageShiftY = (70.0 * fitScale).clamp(66.0, 70.0);
            final horizontalPadding = (constraints.maxWidth * 0.1).clamp(
              24.0,
              40.0,
            );
            final fieldGap = availableHeight < 780 ? 14.0 : 20.0;
            final sectionGap = availableHeight < 780 ? 16.0 : 24.0;
            final bottomGap = availableHeight < 780 ? 20.0 : 36.0;

            return SingleChildScrollView(
              padding: EdgeInsets.only(bottom: bottomInset),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: availableHeight),
                child: Column(
                  children: [
                    SizedBox(
                      height: topHeight,
                      child: Stack(
                        children: [
                          Container(color: const Color(0xFFFDF7E6)),
                          Positioned(
                            top: 40,
                            left: 0,
                            right: 0,
                            child: Center(
                              child: Text(
                                'SHAKEY',
                                style: TextStyle(
                                  fontFamily: 'Kanit',
                                  fontSize: 42,
                                  fontWeight: FontWeight.w900,
                                  color: AppColor.primaryRed,
                                  letterSpacing: 8,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: imageTop,
                            left: 0,
                            right: 0,
                            child: Center(
                              child: Transform.translate(
                                offset: Offset(imageShiftX, imageShiftY),
                                child: Transform.rotate(
                                  angle: math.pi / 18,
                                  child: Image.asset(
                                    'assets/images/Strawberry.png',
                                    height: imageHeight,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          ClipPath(
                            clipBehavior: Clip.hardEdge,
                            clipper: _LoginWaveClipper(),
                            child: Container(color: AppColor.primaryRed),
                          ),
                          Positioned(
                            left: 0,
                            right: 0,
                            bottom: 0,
                            child: Container(
                              height: 3,
                              color: AppColor.primaryRed,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Transform.translate(
                      offset: const Offset(0, -1),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: horizontalPadding,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              _lang.get('sign_in'),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: sectionGap),
                            Text(
                              _lang.get('email'),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 6),
                            _buildTextField(
                              controller: _emailController,
                              hint: _lang.get('email'),
                              icon: Icons.email_outlined,
                            ),
                            SizedBox(height: fieldGap),
                            Text(
                              _lang.get('password'),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 6),
                            _buildTextField(
                              controller: _passwordController,
                              hint: _lang.get('password'),
                              icon: Icons.lock_outline,
                              isPassword: true,
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  Navigator.of(
                                    context,
                                  ).pushNamed(AppRoutes.forgotPasswordPage);
                                },
                                child: Text(
                                  _lang.get('forgot_password'),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                              height: 48,
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : _onLogin,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: AppColor.primaryRed,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: _isLoading
                                    ? const SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: AppColor.primaryRed,
                                        ),
                                      )
                                    : Text(
                                        _lang.get('login'),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16,
                                        ),
                                      ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Center(
                              child: GestureDetector(
                                onTap: _onRegister,
                                child: Text.rich(
                                  TextSpan(
                                    text: _lang.get('no_account_yet'),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: _lang.get('register'),
                                        style: const TextStyle(
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: sectionGap),
                            Row(
                              children: [
                                const Expanded(
                                  child: Divider(color: Colors.white54),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  child: Text(
                                    _lang.get('or_login_with'),
                                    style: TextStyle(
                                      color: Colors.white.withValues(
                                        alpha: 0.8,
                                      ),
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                const Expanded(
                                  child: Divider(color: Colors.white54),
                                ),
                              ],
                            ),
                            SizedBox(height: sectionGap),
                            SizedBox(
                              height: 48,
                              child: ElevatedButton.icon(
                                onPressed: _isLoading ? null : _onGoogleLogin,
                                icon: Image.asset(
                                  'assets/images/google_logo.png',
                                  height: 20,
                                ),
                                label: const Text(
                                  'Google',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: AppColor.primaryRed,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: bottomGap),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword ? _obscurePassword : false,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.white, size: 20),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              )
            : null,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 12,
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
        errorStyle: const TextStyle(color: Colors.yellow),
      ),
    );
  }
}

class _LoginWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    // Start at bottom left
    path.moveTo(0, size.height);
    // Go up to the wave start
    path.lineTo(0, size.height - 80);
    // Draw the top edge (the wave)
    var firstControlPoint = Offset(size.width / 4, size.height - 130);
    var firstEndPoint = Offset(size.width / 2, size.height - 80);
    path.quadraticBezierTo(
      firstControlPoint.dx,
      firstControlPoint.dy,
      firstEndPoint.dx,
      firstEndPoint.dy,
    );

    var secondControlPoint = Offset(size.width * 3 / 4, size.height - 30);
    var secondEndPoint = Offset(size.width, size.height - 80);
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
