import 'package:flutter/material.dart';
import 'package:shakey/app_color.dart';
import 'package:shakey/router.dart';
import 'package:shakey/services/auth_service.dart';
import 'package:shakey/services/user_service.dart';
import 'package:shakey/models/user.dart';
import 'package:shakey/pages/edit_profile_page.dart';

class MorePage extends StatefulWidget {
  const MorePage({super.key});

  @override
  State<MorePage> createState() => _MorePageState();
}

class _MorePageState extends State<MorePage> {
  final UserService _userService = UserService.instance;
  User? _user;
  bool _isLoadingProfile = true;
  bool _isActionLoading = false;

  @override
  void initState() {
    super.initState();
    _userService.addListener(_onUserChanged);
    _fetchProfile();
  }

  void _onUserChanged() {
    if (mounted) {
      setState(() {
        _user = _userService.user;
      });
    }
  }

  @override
  void dispose() {
    _userService.removeListener(_onUserChanged);
    super.dispose();
  }

  Future<void> _fetchProfile() async {
    final auth = AuthService.instance;
    if (!auth.isAuthenticated) {
      if (mounted) setState(() => _isLoadingProfile = false);
      return;
    }

    try {
      final user = await _userService.getProfile();
      if (mounted) {
        setState(() {
          _user = user;
          _isLoadingProfile = false;
        });
      }
    } catch (e) {
      debugPrint('Error fetching profile in MorePage: $e');
      if (mounted) setState(() => _isLoadingProfile = false);
    }
  }

  Future<void> _changePassword() async {
    if (_user == null || _user?.email == null) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('User email not found')));
      }
      return;
    }

    final email = _user!.email;

    setState(() => _isActionLoading = true);
    try {
      await AuthService.instance.forgotPassword(email);
      if (mounted) {
        Navigator.of(
          context,
        ).pushNamed(AppRoutes.otpVerificationPage, arguments: email);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString().replaceAll('Exception: ', ''))),
        );
      }
    } finally {
      if (mounted) setState(() => _isActionLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              // Profile Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.account_circle,
                          size: 70,
                          color: AppColor.primaryRed,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _isLoadingProfile
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppColor.primaryRed,
                                  ),
                                )
                              : Text(
                                  _user?.username ?? 'Guest',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                        ),
                        TextButton.icon(
                          onPressed: _user == null
                              ? null
                              : () async {
                                  final refresh = await Navigator.of(context)
                                      .push(
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              EditProfilePage(user: _user!),
                                        ),
                                      );
                                  if (refresh == true) {
                                    _fetchProfile();
                                  }
                                },
                          icon: const Icon(
                            Icons.edit_note,
                            size: 18,
                            color: Colors.black,
                          ),
                          label: const Text(
                            'edit profile',
                            style: TextStyle(
                              color: AppColor.primaryRed,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '${_user?.point ?? 0} points',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Divider(color: AppColor.primaryRed, thickness: 1.5),
              const SizedBox(height: 10),

              // Menu Options
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    _buildMenuOption(
                      'Change PIN',
                      icon: Icons.lock_outline,
                      onTap: () {
                        Navigator.of(context).pushNamed(
                          AppRoutes.pinPage,
                          arguments: {'isSetting': true},
                        );
                      },
                    ),
                    _buildMenuOption(
                      'Change Password',
                      icon: Icons.password_outlined,
                      onTap: (_isLoadingProfile || _isActionLoading)
                          ? null
                          : _changePassword,
                      trailing: _isActionLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColor.primaryRed,
                              ),
                            )
                          : null,
                    ),
                    _buildMenuOption('Language', icon: Icons.language),
                    _buildMenuOption(
                      'Contact',
                      icon: Icons.contact_support_outlined,
                    ),
                    _buildMenuOption('Setting', icon: Icons.settings_outlined),
                    _buildMenuOption('Help', icon: Icons.help_outline),
                    _buildMenuOption(
                      'FAQ',
                      icon: Icons.question_answer_outlined,
                    ),
                    _buildMenuOption(
                      'Terms and condition',
                      icon: Icons.description_outlined,
                    ),
                    _buildMenuOption(
                      'Log out',
                      icon: Icons.logout,
                      onTap: () async {
                        await AuthService.instance.logout();
                        if (mounted) {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            AppRoutes.loginPage,
                            (route) => false,
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              Text(
                'version 1.0.0',
                style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuOption(
    String title, {
    required IconData icon,
    VoidCallback? onTap,
    Widget? trailing,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColor.primaryRed.withOpacity(0.3),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColor.primaryRed, size: 22),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ),
            if (trailing != null)
              trailing
            else
              const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
