import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:shakey/app_color.dart';
import 'package:shakey/services/auth_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _authService = AuthService();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _acceptTerms = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_acceptTerms) return;

    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await _authService.register(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        firstname: firstNameController.text.trim(),
        lastname: lastNameController.text.trim(),
        phone: phoneController.text.trim(),
      );

      if (!mounted) return;

      Navigator.of(context).pop();
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceAll("Exception: ", "");
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColor.primaryRed,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final availableHeight = constraints.maxHeight;
            final fitScale = (availableHeight / 920).clamp(0.68, 1.0);
            final topHeight = (230.0 * fitScale).clamp(170.0, 230.0);
            final imageHeight = (428.0 * fitScale).clamp(338.0, 428.0);
            final imageTop = (-6.0 * fitScale).clamp(-10.0, -4.0);
            final imageShiftX = (36.0 * fitScale).clamp(28.0, 36.0);
            final imageShiftY = (10.0 * fitScale).clamp(6.0, 10.0);
            final horizontalPadding = (constraints.maxWidth * 0.1).clamp(
              24.0,
              40.0,
            );
            final titleSize = (26.0 * fitScale).clamp(20.0, 26.0);
            final labelSize = (12.5 * fitScale).clamp(10.5, 12.5);
            final termsSize = (11.5 * fitScale).clamp(9.5, 11.5);
            final fieldFontSize = (14.0 * fitScale).clamp(12.0, 14.0);
            final fieldHeight = (48.0 * fitScale).clamp(36.0, 48.0);
            final fieldVerticalPadding = (10.0 * fitScale).clamp(6.0, 10.0);
            final fieldGap = (7.0 * fitScale).clamp(4.0, 7.0);
            final sectionGap = (10.0 * fitScale).clamp(6.0, 10.0);
            final buttonWidth = (165.0 * fitScale).clamp(132.0, 165.0);
            final buttonHeight = (40.0 * fitScale).clamp(34.0, 40.0);
            final bottomGap = (6.0 * fitScale).clamp(3.0, 6.0);
            final checkboxScale = fitScale.clamp(0.78, 1.0);

            return Column(
              children: [
                SizedBox(
                  height: topHeight,
                  child: Stack(
                    clipBehavior: Clip.hardEdge,
                    children: [
                      Container(color: AppColor.primaryRed),
                      ClipPath(
                        clipBehavior: Clip.hardEdge,
                        clipper: _RegisterCreamTopClipper(),
                        child: Container(color: const Color(0xFFFDF7E6)),
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
                        clipper: _RegisterWaveClipper(),
                        child: Container(color: AppColor.primaryRed),
                      ),
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: Container(height: 3, color: AppColor.primaryRed),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Register',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: titleSize,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          SizedBox(height: sectionGap),
                          _buildLabel(
                            'Name',
                            fontSize: labelSize,
                            bottomPadding: 2.5 * fitScale,
                          ),
                          SizedBox(
                            height: fieldHeight,
                            child: _buildTextField(
                              hint: 'Name',
                              controller: firstNameController,
                              fontSize: fieldFontSize,
                              verticalPadding: fieldVerticalPadding,
                            ),
                          ),
                          SizedBox(height: fieldGap),
                          _buildLabel(
                            'Surname',
                            fontSize: labelSize,
                            bottomPadding: 2.5 * fitScale,
                          ),
                          SizedBox(
                            height: fieldHeight,
                            child: _buildTextField(
                              hint: 'Lastname',
                              controller: lastNameController,
                              fontSize: fieldFontSize,
                              verticalPadding: fieldVerticalPadding,
                            ),
                          ),
                          SizedBox(height: fieldGap),
                          _buildLabel(
                            'Tel.',
                            fontSize: labelSize,
                            bottomPadding: 2.5 * fitScale,
                          ),
                          SizedBox(
                            height: fieldHeight,
                            child: _buildTextField(
                              hint: 'Tel.',
                              controller: phoneController,
                              fontSize: fieldFontSize,
                              verticalPadding: fieldVerticalPadding,
                            ),
                          ),
                          SizedBox(height: fieldGap),
                          _buildLabel(
                            'Email',
                            fontSize: labelSize,
                            bottomPadding: 2.5 * fitScale,
                          ),
                          SizedBox(
                            height: fieldHeight,
                            child: _buildTextField(
                              hint: 'Email',
                              controller: emailController,
                              fontSize: fieldFontSize,
                              verticalPadding: fieldVerticalPadding,
                            ),
                          ),
                          SizedBox(height: fieldGap),
                          _buildLabel(
                            'Password',
                            fontSize: labelSize,
                            bottomPadding: 2.5 * fitScale,
                          ),
                          SizedBox(
                            height: fieldHeight,
                            child: _buildTextField(
                              hint: 'Password',
                              controller: passwordController,
                              isPassword: true,
                              fontSize: fieldFontSize,
                              verticalPadding: fieldVerticalPadding,
                            ),
                          ),
                          SizedBox(height: fieldGap),
                          _buildLabel(
                            'Confirm Password',
                            fontSize: labelSize,
                            bottomPadding: 2.5 * fitScale,
                          ),
                          SizedBox(
                            height: fieldHeight,
                            child: _buildTextField(
                              hint: 'Confirm Password',
                              controller: confirmPasswordController,
                              isPassword: true,
                              isConfirm: true,
                              fontSize: fieldFontSize,
                              verticalPadding: fieldVerticalPadding,
                            ),
                          ),
                          SizedBox(height: sectionGap - 2),
                          Row(
                            children: [
                              Transform.scale(
                                scale: checkboxScale,
                                child: Checkbox(
                                  value: _acceptTerms,
                                  onChanged: (val) => setState(
                                    () => _acceptTerms = val ?? false,
                                  ),
                                  side: const BorderSide(color: Colors.white),
                                  checkColor: AppColor.primaryRed,
                                  activeColor: Colors.white,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  'I accept terms of the agreement',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: termsSize,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: sectionGap),
                          if (_errorMessage != null) ...[
                            SizedBox(height: 6),
                            Text(
                              _errorMessage!,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.yellow,
                                fontSize: (12.0 * fitScale).clamp(10.0, 12.0),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: sectionGap),
                          ],
                          Center(
                            child: SizedBox(
                              width: buttonWidth,
                              height: buttonHeight,
                              child: ElevatedButton(
                                onPressed: (_acceptTerms && !_isLoading)
                                    ? _submit
                                    : null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: AppColor.primaryRed,
                                  shape: const StadiumBorder(),
                                ),
                                child: _isLoading
                                    ? SizedBox(
                                        width: 18,
                                        height: 18,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor: AlwaysStoppedAnimation(
                                            AppColor.primaryRed,
                                          ),
                                        ),
                                      )
                                    : Text(
                                        'REGISTER',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: (14.0 * fitScale).clamp(
                                            11.0,
                                            14.0,
                                          ),
                                        ),
                                      ),
                              ),
                            ),
                          ),
                          SizedBox(height: (8.0 * fitScale).clamp(5.0, 8.0)),
                          Center(
                            child: GestureDetector(
                              onTap: () => Navigator.of(context).pop(),
                              child: Text.rich(
                                TextSpan(
                                  text: 'Already have an account? ',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: (12.0 * fitScale).clamp(
                                      10.0,
                                      12.0,
                                    ),
                                  ),
                                  children: const [
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
                          SizedBox(height: bottomGap),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildLabel(
    String label, {
    double fontSize = 13,
    double bottomPadding = 4,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.white,
          fontSize: fontSize,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String hint,
    required TextEditingController controller,
    bool isPassword = false,
    bool isConfirm = false,
    double fontSize = 14,
    double verticalPadding = 10,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword
          ? (isConfirm ? _obscureConfirmPassword : _obscurePassword)
          : false,
      style: TextStyle(color: Colors.white, fontSize: fontSize),
      decoration: InputDecoration(
        isDense: true,
        contentPadding: EdgeInsets.symmetric(
          vertical: verticalPadding,
          horizontal: 16,
        ),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  (isConfirm ? _obscureConfirmPassword : _obscurePassword)
                      ? Icons.visibility_off
                      : Icons.visibility,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    if (isConfirm) {
                      _obscureConfirmPassword = !_obscureConfirmPassword;
                    } else {
                      _obscurePassword = !_obscurePassword;
                    }
                  });
                },
              )
            : null,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.white, width: 3),
        ),
        errorStyle: const TextStyle(color: Colors.yellow),
      ),
    );
  }
}

class _RegisterCreamTopClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(0, size.height - 40);
    path.quadraticBezierTo(
      size.width / 4,
      size.height - 90,
      size.width / 2,
      size.height - 40,
    );
    path.quadraticBezierTo(
      size.width * 3 / 4,
      size.height + 10,
      size.width,
      size.height - 40,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
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
