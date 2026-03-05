import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:shakey/app_color.dart';
import 'package:shakey/services/auth_service.dart';
import 'package:shakey/services/language_service.dart';
import 'package:shakey/router.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _acceptTerms = false;
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
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
    _nameController.dispose();
    _surnameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _onRegister() async {
    final name = _nameController.text.trim();
    final surname = _surnameController.text.trim();
    final phone = _phoneController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirm = _confirmPasswordController.text.trim();

    if (name.isEmpty ||
        surname.isEmpty ||
        phone.isEmpty ||
        email.isEmpty ||
        password.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(_lang.get('fill_all_fields'))));
      return;
    }

    if (password != confirm) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(_lang.get('passwords_not_match'))));
      return;
    }

    if (!_acceptTerms) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(_lang.get('accept_terms_error'))));
      return;
    }

    setState(() => _isLoading = true);

    try {
      await AuthService.instance.register(
        email: email,
        password: password,
        firstname: name,
        lastname: surname,
        phone: phone,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_lang.get('registration_success')),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pushNamedAndRemoveUntil(
          AppRoutes.pinPage,
          (route) => false,
          arguments: {'isSetting': true},
        );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
            final fieldVerticalPadding = (10.0 * fitScale).clamp(6.0, 10.0);
            final fieldGap = (7.0 * fitScale).clamp(4.0, 7.0);
            final sectionGap = (10.0 * fitScale).clamp(6.0, 10.0);
            final buttonWidth = (165.0 * fitScale).clamp(132.0, 165.0);
            final buttonHeight = (40.0 * fitScale).clamp(34.0, 40.0);
            final checkboxScale = fitScale.clamp(0.78, 1.0);

            return SingleChildScrollView(
              padding: EdgeInsets.zero,
              child: Column(
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
                          child: Container(
                            height: 3,
                            color: AppColor.primaryRed,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          _lang.get('register'),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: titleSize,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: sectionGap),
                        _buildLabel(_lang.get('username'), fontSize: labelSize),
                        _buildTextField(
                          controller: _nameController,
                          hint: _lang.get('username'),
                          fontSize: fieldFontSize,
                          verticalPadding: fieldVerticalPadding,
                        ),
                        SizedBox(height: fieldGap),
                        _buildLabel(_lang.get('surname'), fontSize: labelSize),
                        _buildTextField(
                          controller: _surnameController,
                          hint: _lang.get('surname'),
                          fontSize: fieldFontSize,
                          verticalPadding: fieldVerticalPadding,
                        ),
                        SizedBox(height: fieldGap),
                        _buildLabel(_lang.get('phone'), fontSize: labelSize),
                        _buildTextField(
                          controller: _phoneController,
                          hint: _lang.get('phone'),
                          fontSize: fieldFontSize,
                          verticalPadding: fieldVerticalPadding,
                        ),
                        SizedBox(height: fieldGap),
                        _buildLabel(_lang.get('email'), fontSize: labelSize),
                        _buildTextField(
                          controller: _emailController,
                          hint: _lang.get('email'),
                          fontSize: fieldFontSize,
                          verticalPadding: fieldVerticalPadding,
                        ),
                        SizedBox(height: fieldGap),
                        _buildLabel(_lang.get('password'), fontSize: labelSize),
                        _buildTextField(
                          controller: _passwordController,
                          hint: _lang.get('password'),
                          isPassword: true,
                          fontSize: fieldFontSize,
                          verticalPadding: fieldVerticalPadding,
                        ),
                        SizedBox(height: fieldGap),
                        _buildLabel(
                          _lang.get('confirm_password'),
                          fontSize: labelSize,
                        ),
                        _buildTextField(
                          controller: _confirmPasswordController,
                          hint: _lang.get('confirm_password'),
                          isPassword: true,
                          isConfirm: true,
                          fontSize: fieldFontSize,
                          verticalPadding: fieldVerticalPadding,
                        ),
                        SizedBox(height: sectionGap),
                        Row(
                          children: [
                            Transform.scale(
                              scale: checkboxScale,
                              child: Checkbox(
                                value: _acceptTerms,
                                onChanged: (val) =>
                                    setState(() => _acceptTerms = val ?? false),
                                side: const BorderSide(color: Colors.white),
                                checkColor: AppColor.primaryRed,
                                activeColor: Colors.white,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                _lang.get('accept_terms'),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: termsSize,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: sectionGap),
                        Center(
                          child: SizedBox(
                            width: buttonWidth,
                            height: buttonHeight,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _onRegister,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: AppColor.primaryRed,
                                shape: const StadiumBorder(),
                              ),
                              child: _isLoading
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: AppColor.primaryRed,
                                      ),
                                    )
                                  : Text(_lang.get('register').toUpperCase()),
                            ),
                          ),
                        ),
                        SizedBox(height: 12),
                        Center(
                          child: GestureDetector(
                            onTap: () => Navigator.of(context).pop(),
                            child: Text.rich(
                              TextSpan(
                                text: _lang.get('already_have_account'),
                                style: const TextStyle(color: Colors.white),
                                children: [
                                  TextSpan(
                                    text: _lang.get('login'),
                                    style: const TextStyle(
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLabel(String label, {double fontSize = 13}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.white,
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    bool isPassword = false,
    bool isConfirm = false,
    double fontSize = 14,
    double verticalPadding = 10,
  }) {
    return TextField(
      controller: controller,
      obscureText:
          isPassword &&
          (isConfirm ? _obscureConfirmPassword : _obscurePassword),
      style: TextStyle(color: Colors.white, fontSize: fontSize),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.white54, fontSize: fontSize),
        isDense: true,
        contentPadding: EdgeInsets.symmetric(
          vertical: verticalPadding,
          horizontal: 16,
        ),
        suffixIcon: isPassword
            ? IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: Icon(
                  (isConfirm ? _obscureConfirmPassword : _obscurePassword)
                      ? Icons.visibility_off
                      : Icons.visibility,
                  color: Colors.white54,
                  size: 18 * fontSize / 14,
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
