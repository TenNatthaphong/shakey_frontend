import 'package:shakey/config.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shakey/app_color.dart';
import 'package:shakey/models/menu.dart';
import 'package:shakey/pages/reward_detail_page.dart';
import 'package:shakey/pages/menu_detail_page.dart';
import 'package:shakey/services/cart_service.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shakey/models/home_models.dart';
import 'package:shakey/services/auth_service.dart';
import 'package:shakey/services/user_service.dart';
import 'package:shakey/models/user.dart';
import 'package:shakey/services/banner_service.dart';
import 'package:shakey/services/menu_service.dart';
import 'package:shakey/services/language_service.dart';

class HomePage extends StatefulWidget {
  final ValueChanged<int>? onTabSelected;

  const HomePage({super.key, this.onTabSelected});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> _banners = [];

  int get _bannerCount => _banners.length;
  List<PromoCoupon> _promoCoupons = [];
  bool _isLoadingRewards = true;
  User? _user;
  bool _isLoadingProfile = true;
  final UserService _userService = UserService.instance;

  late final PageController _bannerController;
  Timer? _bannerTimer;
  int _activeBannerIndex = 0;
  List<Order> _recentOrders = [];
  bool _isLoadingOrders = true;
  final MenuService _menuService = MenuService.instance;
  final _lang = LanguageService.instance;

  @override
  void initState() {
    super.initState();
    _bannerController = PageController();
    _startTimer();
    _fetchBanners();
    _fetchRewards();
    _userService.addListener(_onUserChanged);
    _fetchProfile();
    BannerService.instance.addListener(_onBannersChanged);
    _banners = BannerService.instance.banners;
    _fetchRecentOrders();
    CartService.instance.addListener(_onCartChanged);
    _lang.addListener(_onLanguageChanged);
  }

  void _onLanguageChanged() {
    if (mounted) setState(() {});
  }

  void _onCartChanged() {
    // Refresh recent orders when cart changes (e.g. after clearing upon successful order)
    _fetchRecentOrders();
  }

  Future<void> _fetchRecentOrders() async {
    if (!AuthService.instance.isAuthenticated) {
      if (mounted) setState(() => _isLoadingOrders = false);
      return;
    }
    final orders = await _menuService.getOrderHistory();
    if (mounted) {
      setState(() {
        _recentOrders = orders;
        _isLoadingOrders = false;
      });
    }
  }

  void _onBannersChanged() {
    if (mounted) {
      setState(() {
        _banners = BannerService.instance.banners;
      });
    }
  }

  void _onUserChanged() {
    if (mounted) {
      final oldUser = _user;
      setState(() {
        _user = _userService.user;
      });
      // If user changed from null to logged in, or changed user, refresh orders
      if (_user != null &&
          (oldUser == null || oldUser.userId != _user!.userId)) {
        _fetchRecentOrders();
      }
    }
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
      debugPrint('Error fetching profile: $e');
      if (mounted) setState(() => _isLoadingProfile = false);
    }
  }

  double _calculateProgress() {
    if (_user == null) return 0.0;
    final cups = _user!.totalCupsPurchased;
    switch (_user!.member) {
      case MemberLevel.Bronze:
        return (cups / 50).clamp(0.0, 1.0);
      case MemberLevel.Silver:
        return ((cups - 50) / 100).clamp(0.0, 1.0);
      case MemberLevel.Gold:
        return 1.0;
    }
  }

  String _getNextLevelText() {
    if (_user == null) return _lang.get('join_member_earn');
    final cups = _user!.totalCupsPurchased;
    switch (_user!.member) {
      case MemberLevel.Bronze:
        final remaining = 50 - cups;
        return '${_lang.get('another')} ${remaining > 0 ? remaining : 0} ${_lang.get('cups_to')} ${_lang.get('reach_silver')}';
      case MemberLevel.Silver:
        final remaining = 150 - cups;
        return '${_lang.get('another')} ${remaining > 0 ? remaining : 0} ${_lang.get('cups_to')} ${_lang.get('reach_gold')}';
      case MemberLevel.Gold:
        return _lang.get('max_level');
    }
  }

  Color _getMemberColor() {
    if (_user == null) return AppColor.bronzeColor;
    switch (_user!.member) {
      case MemberLevel.Bronze:
        return AppColor.bronzeColor;
      case MemberLevel.Silver:
        return AppColor.silverColor;
      case MemberLevel.Gold:
        return AppColor.goldColor;
    }
  }

  Future<void> _fetchRewards() async {
    try {
      final response = await http
          .get(Uri.parse('${AppConfig.baseUrl}/reward?take=4'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (mounted) {
          setState(() {
            _promoCoupons = data
                .map((e) => PromoCoupon.fromJson(e as Map<String, dynamic>))
                .toList();
            _isLoadingRewards = false;
          });
        }
      } else {
        if (mounted) setState(() => _isLoadingRewards = false);
      }
    } catch (e) {
      debugPrint('Error fetching home rewards: $e');
      if (mounted) setState(() => _isLoadingRewards = false);
    }
  }

  Future<void> _fetchBanners() async {
    BannerService.instance.getBanners();
  }

  void _startTimer() {
    _bannerTimer?.cancel();
    if (_bannerCount == 0) return;

    _bannerTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _changeBannerPage(1);
    });
  }

  @override
  void dispose() {
    _userService.removeListener(_onUserChanged);
    BannerService.instance.removeListener(_onBannersChanged);
    _bannerTimer?.cancel();
    _bannerController.dispose();
    super.dispose();
  }

  void _changeBannerPage(int delta, {bool manual = false}) {
    if (!mounted || !_bannerController.hasClients || _bannerCount == 0) return;

    if (manual) _startTimer();

    final int currentPage =
        _bannerController.page?.round() ?? _activeBannerIndex;
    final int nextPage = (currentPage + delta + _bannerCount) % _bannerCount;

    _bannerController.animateToPage(
      nextPage,
      duration: Duration(milliseconds: manual ? 400 : 800),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _onEarnPointTap() async {
    final scannedCode = await _showMockQrScanner();
    if (!mounted || scannedCode == null) return;

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text('${_lang.get('scanned_qr_msg')}$scannedCode'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<String?> _showMockQrScanner() {
    return showDialog<String>(
      context: context,
      barrierColor: Colors.black54,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 24,
          ),
          child: Container(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
            decoration: BoxDecoration(
              color: const Color(0xFF1B1B1B),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white24),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  _lang.get('mock_qr_scanner'),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  height: 240,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0E0E0E),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColor.primaryRed, width: 1.2),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      const Icon(
                        Icons.qr_code_scanner_rounded,
                        color: Colors.white54,
                        size: 90,
                      ),
                      Container(
                        width: 180,
                        height: 180,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white70, width: 1.3),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  _lang.get('demo_mode_msg'),
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(dialogContext).pop(),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white38),
                        ),
                        child: Text(_lang.get('cancel')),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(dialogContext).pop('SHAKEY-EARN-001');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.primaryRed,
                          foregroundColor: Colors.white,
                        ),
                        child: Text(_lang.get('scan_success')),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _getLocalizedMemberName(MemberLevel? level) {
    if (level == null) return _lang.get('bronze_member');
    switch (level) {
      case MemberLevel.Bronze:
        return _lang.get('bronze_member');
      case MemberLevel.Silver:
        return _lang.get('silver_member');
      case MemberLevel.Gold:
        return _lang.get('gold_member');
    }
  }

  void _showPrivilegeDialog() {
    showDialog<void>(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _getMemberColor(),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.star_rounded,
                  color: Colors.white,
                  size: 40,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '${_getLocalizedMemberName(_user?.member)} ${_lang.get('privilege')}',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              _buildPrivilegeRow(
                Icons.local_offer_rounded,
                _lang.get('privilege_discount'),
              ),
              const SizedBox(height: 16),
              _buildPrivilegeRow(
                Icons.cake_rounded,
                _lang.get('privilege_birthday'),
              ),
              const SizedBox(height: 16),
              _buildPrivilegeRow(
                Icons.auto_awesome_rounded,
                _lang.get('privilege_double_points'),
              ),
              const SizedBox(height: 16),
              _buildPrivilegeRow(
                Icons.fiber_new_rounded,
                _lang.get('privilege_early_access'),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primaryRed,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    elevation: 0,
                  ),
                  child: Text(
                    _lang.get('close'),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPrivilegeRow(IconData icon, String text) {
    final cleanText = text.startsWith('• ') ? text.substring(2) : text;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColor.primaryRed, size: 22),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            cleanText,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  void _openCouponDetail(PromoCoupon coupon) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CouponDetailPage(
          previewReward: Reward(
            id: coupon.rewardId,
            name: coupon.title,
            image: coupon.imageAsset,
            points: coupon.points,
            description: coupon.condition,
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required HomeScale scale,
    required Widget child,
    EdgeInsetsGeometry? padding,
    double radius = 12,
    Color color = Colors.white,
    Gradient? gradient,
  }) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: gradient == null ? color : null,
        gradient: gradient,
        borderRadius: BorderRadius.circular(scale.r(radius)),
        boxShadow: [
          BoxShadow(
            color: const Color(0x1F000000),
            blurRadius: scale.r(15),
            offset: Offset(0, scale.h(5)),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildTopPanel(HomeScale scale) {
    return Container(
      color: Colors.transparent,
      padding: EdgeInsets.fromLTRB(
        scale.w(16),
        scale.h(18),
        scale.w(16),
        scale.h(26),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: scale.r(20),
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.person_outline_rounded,
                        color: AppColor.primaryRed,
                        size: scale.sp(30),
                      ),
                    ),
                    SizedBox(width: scale.w(10)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (_isLoadingProfile)
                          SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        else
                          Text(
                            _user?.username ?? _lang.get('guest'),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: scale.sp(20),
                              fontWeight: FontWeight.w700,
                              height: 0.95,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 120,
                height: 30,
                child: GestureDetector(
                  onTap: _onEarnPointTap,
                  child: _buildSectionCard(
                    scale: scale,
                    gradient: AppColor.backgroundGradient,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    radius: 24,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.qr_code_scanner,
                          color: AppColor.primaryRed,
                          size: scale.sp(22),
                        ),
                        SizedBox(width: scale.w(8)),
                        Text(
                          _lang.get('earn_point'),
                          style: TextStyle(
                            color: AppColor.primaryRed,
                            fontWeight: FontWeight.w700,
                            fontSize: scale.sp(12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: scale.h(20)),
          _buildSectionCard(
            scale: scale,
            padding: EdgeInsets.fromLTRB(
              scale.w(16),
              scale.h(16),
              scale.w(16),
              scale.h(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _getLocalizedMemberName(_user?.member),
                          style: TextStyle(
                            color: _getMemberColor(),
                            fontWeight: FontWeight.w700,
                            fontSize: scale.sp(14),
                            height: 1,
                          ),
                        ),
                        SizedBox(height: scale.h(4)),
                        Text(
                          '${_user?.point ?? 0} ${_lang.get('points')}',
                          style: TextStyle(
                            color: AppColor.primaryRed,
                            fontWeight: FontWeight.w700,
                            fontSize: scale.sp(22),
                            height: 1,
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: _showPrivilegeDialog,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: scale.w(14),
                          vertical: scale.h(6),
                        ),
                        decoration: BoxDecoration(
                          color: AppColor.primaryRed.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(scale.r(20)),
                        ),
                        child: Text(
                          _lang.get('privilege'),
                          style: TextStyle(
                            color: AppColor.primaryRed,
                            fontWeight: FontWeight.w700,
                            fontSize: scale.sp(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: scale.h(16)),
                Stack(
                  children: [
                    Container(
                      height: scale.h(6),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEEEEEE),
                        borderRadius: BorderRadius.circular(scale.r(3)),
                      ),
                    ),
                    Container(
                      height: scale.h(6),
                      width:
                          (MediaQuery.of(context).size.width - scale.w(64)) *
                          _calculateProgress(),
                      decoration: BoxDecoration(
                        color: _getMemberColor(),
                        borderRadius: BorderRadius.circular(scale.r(3)),
                        boxShadow: [
                          BoxShadow(
                            color: _getMemberColor().withValues(alpha: 0.3),
                            blurRadius: scale.r(4),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: scale.h(8)),
                Text(
                  _getNextLevelText(),
                  style: TextStyle(
                    fontSize: scale.sp(11),
                    color: const Color(0xFF8A909C),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAction(
    HomeScale scale,
    String label, {
    IconData? icon,
    VoidCallback? onTap,
  }) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(scale.r(24)),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFFFFFF),
              Color(0xFFFDFBF5), // Very soft cream
              Color(0xFFF2E5CC), // Elegant warm beige
            ],
            stops: [0.0, 0.4, 1.0],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 24,
              offset: Offset(0, scale.h(12)),
            ),
            BoxShadow(
              color: AppColor.primaryRed.withValues(alpha: 0.08),
              blurRadius: 20,
              offset: Offset(0, scale.h(8)),
            ),
            BoxShadow(
              // Soft top rim light
              color: Colors.white,
              blurRadius: 10,
              offset: const Offset(-2, -2),
            ),
          ],
          border: Border.all(color: Colors.white, width: 1.5),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(scale.r(24)),
            splashColor: AppColor.primaryRed.withValues(alpha: 0.12),
            highlightColor: Colors.white.withValues(alpha: 0.4),
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: scale.h(14),
                horizontal: scale.w(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Container(
                      padding: EdgeInsets.all(scale.r(8)),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.06),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Icon(
                        icon,
                        color: AppColor.primaryRed,
                        size: scale.sp(20),
                      ),
                    ),
                    SizedBox(width: scale.w(10)),
                  ],
                  Text(
                    label,
                    style: TextStyle(
                      color: const Color(0xFF2C2C2C),
                      fontWeight: FontWeight.w700,
                      fontSize: scale.sp(17),
                      letterSpacing: -0.3,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBannerImage(HomeScale scale, String imagePath) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(scale.r(10)),
        boxShadow: [
          BoxShadow(
            color: const Color(0x1F000000),
            blurRadius: scale.r(15),
            offset: Offset(0, scale.h(5)),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(scale.r(10)),
        child: Image.network(
          imagePath,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _buildErrorBanner(),
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              color: Colors.grey[200],
              child: const Center(
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildErrorBanner() {
    return Container(
      color: Colors.grey[300],
      child: const Icon(Icons.broken_image, color: Colors.grey),
    );
  }

  Widget _buildBannerCarousel(HomeScale scale) {
    if (_bannerCount == 0) {
      return SizedBox(
        height: scale.h(200),
        child: const Center(
          child: CircularProgressIndicator(
            color: AppColor.primaryRed,
            strokeWidth: 2,
          ),
        ),
      );
    }

    return Column(
      children: [
        SizedBox(
          height: scale.h(200),
          child: Stack(
            children: [
              PageView.builder(
                controller: _bannerController,
                itemCount: _bannerCount,
                physics: const BouncingScrollPhysics(),
                onPageChanged: (index) {
                  setState(() {
                    _activeBannerIndex = index;
                  });
                  _startTimer();
                },
                itemBuilder: (_, index) {
                  final bannerPath = _banners[index];
                  return RepaintBoundary(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: scale.w(10)),
                      child: Align(
                        alignment: Alignment.center,
                        child: _buildBannerImage(scale, bannerPath),
                      ),
                    ),
                  );
                },
              ),
              Positioned(
                left: scale.w(16),
                top: 0,
                bottom: 0,
                child: Center(
                  child: _buildBannerArrowButton(
                    scale: scale,
                    icon: Icons.chevron_left_rounded,
                    onTap: () => _changeBannerPage(-1, manual: true),
                  ),
                ),
              ),
              Positioned(
                right: scale.w(16),
                top: 0,
                bottom: 0,
                child: Center(
                  child: _buildBannerArrowButton(
                    scale: scale,
                    icon: Icons.chevron_right_rounded,
                    onTap: () => _changeBannerPage(1, manual: true),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: scale.h(10)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_bannerCount, (index) {
            final isActive = index == _activeBannerIndex;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              margin: EdgeInsets.symmetric(horizontal: scale.w(4)),
              width: isActive ? scale.w(14) : scale.w(8),
              height: scale.h(4),
              decoration: BoxDecoration(
                color: isActive ? AppColor.primaryRed : const Color(0xFFCFCFCF),
                borderRadius: BorderRadius.circular(scale.r(2)),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildBannerArrowButton({
    required HomeScale scale,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white.withValues(alpha: 0.9),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: scale.w(32),
          height: scale.h(32),
          child: Icon(icon, color: AppColor.primaryRed, size: scale.sp(20)),
        ),
      ),
    );
  }

  Widget _buildRecentOrder(HomeScale scale) {
    if (_isLoadingOrders) {
      return SizedBox(
        height: scale.h(160),
        child: const Center(
          child: CircularProgressIndicator(color: AppColor.primaryRed),
        ),
      );
    }

    if (_recentOrders.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: scale.w(16)),
        child: Container(
          padding: EdgeInsets.all(scale.r(20)),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(scale.r(12)),
          ),
          child: Center(
            child: Text(
              _lang.get('no_recent_orders'),
              style: TextStyle(color: Colors.grey, fontSize: scale.sp(14)),
            ),
          ),
        ),
      );
    }

    return SizedBox(
      height: scale.h(260), // Increased height for vertical menu-style card
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        clipBehavior: Clip.none,
        itemCount: _recentOrders.length,
        padding: EdgeInsets.fromLTRB(scale.w(16), 0, scale.w(16), scale.h(15)),
        separatorBuilder: (_, _) => SizedBox(width: scale.w(16)),
        itemBuilder: (_, index) {
          return _buildRecentOrderCard(scale, _recentOrders[index]);
        },
      ),
    );
  }

  Widget _buildRecentOrderCard(HomeScale scale, Order order) {
    final firstItem = order.items.isNotEmpty ? order.items.first : null;
    final otherItemsCount = order.items.length - 1;

    return Container(
      width: scale.w(
        170,
      ), // Width matching roughly half the screen like menu grid
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(scale.r(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: scale.r(15),
            offset: Offset(0, scale.h(8)),
          ),
        ],
      ),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(scale.r(12)),
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(scale.r(24)),
              child: InkWell(
                onTap: firstItem != null
                    ? () async {
                        final added = await Navigator.push<bool>(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                MenuDetailPage(menu: firstItem.menu),
                          ),
                        );
                        if (added == true) {
                          widget.onTabSelected?.call(1);
                        }
                      }
                    : null,
                borderRadius: BorderRadius.circular(scale.r(24)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image Section
                    Expanded(
                      child: Stack(
                        children: [
                          Container(
                            width: double.infinity,
                            height: double.infinity,
                            decoration: BoxDecoration(
                              color: AppColor.cream,
                              borderRadius: BorderRadius.circular(scale.r(18)),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(scale.r(18)),
                              child:
                                  (firstItem?.menu.imagePath.startsWith(
                                        'http',
                                      ) ??
                                      false)
                                  ? Image.network(
                                      firstItem!.menu.imagePath,
                                      fit: BoxFit.cover,
                                      errorBuilder: (ctx, err, stack) =>
                                          const Icon(
                                            Icons.broken_image,
                                            size: 50,
                                          ),
                                    )
                                  : Image.asset(
                                      firstItem?.menu.imagePath ??
                                          'assets/images/Chocolate.png',
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                          // Badge (Delivery/Pickup)
                          Positioned(
                            top: scale.h(8),
                            left: scale.w(8),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: scale.w(8),
                                vertical: scale.h(4),
                              ),
                              decoration: BoxDecoration(
                                color: order.delivery
                                    ? Colors.blue
                                    : Colors.orange,
                                borderRadius: BorderRadius.circular(scale.r(8)),
                              ),
                              child: Text(
                                order.delivery
                                    ? _lang.get('delivery')
                                    : _lang.get('pickup'),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: scale.sp(9),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          // Reorder Action Button
                          Positioned(
                            bottom: scale.h(6),
                            right: scale.w(6),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  // Simplified reorder action: re-add first item or push to menu detail
                                  if (firstItem != null) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => MenuDetailPage(
                                          menu: firstItem.menu,
                                        ),
                                      ),
                                    );
                                  }
                                },
                                borderRadius: BorderRadius.circular(
                                  scale.r(20),
                                ),
                                child: Container(
                                  padding: EdgeInsets.all(scale.r(6)),
                                  decoration: const BoxDecoration(
                                    color: AppColor.primaryRed,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.refresh_rounded,
                                    color: Colors.white,
                                    size: scale.sp(16),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: scale.h(12)),
                    // Text Section
                    Text(
                      firstItem?.menu.name ?? _lang.get('order'),
                      style: TextStyle(
                        fontSize: scale.sp(15),
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                        height: 1.1,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: scale.h(4)),
                    Text(
                      otherItemsCount > 0
                          ? _lang
                                .get('items_more')
                                .replaceFirst('{n}', otherItemsCount.toString())
                          : _lang.get('one_item'),
                      style: TextStyle(
                        fontSize: scale.sp(11),
                        color: Colors.grey.shade500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: scale.h(6)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '\$${order.totalPrice.toStringAsFixed(0)}',
                          style: TextStyle(
                            fontSize: scale.sp(16),
                            fontWeight: FontWeight.w700,
                            color: AppColor.primaryRed,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromoHeader(HomeScale scale) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        scale.w(16),
        scale.h(18),
        scale.w(16),
        scale.h(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              _lang.get('rewards_for_you'),
              style: TextStyle(
                color: const Color(0xFF2F3B59),
                fontWeight: FontWeight.w700,
                fontSize: scale.sp(24),
                height: 1,
              ),
            ),
          ),
          GestureDetector(
            onTap: () => widget.onTabSelected?.call(2),
            child: Text(
              _lang.get('see_all'),
              style: TextStyle(
                color: const Color(0xFF4F86D9),
                fontWeight: FontWeight.w600,
                fontSize: scale.sp(16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentOrderHeader(HomeScale scale) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        scale.w(16),
        scale.h(18),
        scale.w(16),
        scale.h(8),
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          _lang.get('recent_order_header'),
          style: TextStyle(
            color: const Color(0xFF2F3B59),
            fontWeight: FontWeight.w700,
            fontSize: scale.sp(24),
            height: 1,
          ),
        ),
      ),
    );
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return _lang.get('no_expiry_text');
    try {
      final dt = DateTime.parse(dateStr);
      return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
    } catch (e) {
      return dateStr;
    }
  }

  Widget _buildPromoGrid(HomeScale scale) {
    if (_isLoadingRewards) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: scale.h(40)),
        child: const Center(
          child: CircularProgressIndicator(color: AppColor.primaryRed),
        ),
      );
    }
    if (_promoCoupons.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: scale.h(40)),
        child: Center(
          child: Text(
            _lang.get('no_rewards_available_home'),
            style: const TextStyle(color: Colors.grey),
          ),
        ),
      );
    }
    return Padding(
      padding: EdgeInsets.fromLTRB(
        scale.w(16),
        scale.h(8),
        scale.w(16),
        scale.h(16),
      ),
      child: GridView.builder(
        itemCount: _promoCoupons.length,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: scale.w(12),
          mainAxisSpacing: scale.h(16),
          mainAxisExtent: scale.h(270),
        ),
        itemBuilder: (_, index) {
          final coupon = _promoCoupons[index];
          return GestureDetector(
            onTap: () => _openCouponDetail(coupon),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(scale.r(16)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: scale.r(10),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(scale.r(16)),
                    ),
                    child: SizedBox(
                      height: scale.h(130),
                      width: double.infinity,
                      child: coupon.imageAsset.startsWith('http')
                          ? Image.network(
                              coupon.imageAsset,
                              fit: BoxFit.cover,
                              errorBuilder: (ctx, err, stack) =>
                                  const Icon(Icons.broken_image),
                            )
                          : Image.asset(
                              coupon.imageAsset.isEmpty
                                  ? 'assets/images/Chocolate.png'
                                  : coupon.imageAsset,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      scale.w(12),
                      scale.h(10),
                      scale.w(12),
                      0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          coupon.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: const Color(0xFF2F2F34),
                            fontWeight: FontWeight.w700,
                            fontSize: scale.sp(15),
                          ),
                        ),
                        SizedBox(height: scale.h(4)),
                        Text(
                          '${_lang.get('valid_until_text')} ${_formatDate(coupon.validUntil)}',
                          style: TextStyle(
                            color: const Color(0xFF8A909C),
                            fontSize: scale.sp(11),
                          ),
                        ),
                        SizedBox(height: scale.h(6)),
                        Text(
                          '${coupon.points} ${_lang.get('pts_unit')}',
                          style: TextStyle(
                            color: AppColor.primaryRed,
                            fontWeight: FontWeight.w700,
                            fontSize: scale.sp(16),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      scale.w(10),
                      0,
                      scale.w(10),
                      scale.h(10),
                    ),
                    child: SizedBox(
                      height: scale.h(36),
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _openCouponDetail(coupon),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.primaryRed,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(scale.r(20)),
                          ),
                        ),
                        child: Text(
                          _lang.get('redeem_now'),
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: scale.sp(13),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scale = HomeScale(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: AppColor.backgroundGradient,
              ),
            ),
          ),
          Positioned.fill(
            child: IgnorePointer(
              child: Align(
                alignment: Alignment.topCenter,
                child: ClipPath(
                  clipper: TopBgClipper(),
                  child: Container(
                    height: scale.h(320),
                    color: AppColor.primaryRed,
                  ),
                ),
              ),
            ),
          ),
          SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildTopPanel(scale),
                  Transform.translate(
                    offset: Offset(0, -scale.h(8)),
                    child: Container(
                      color: Colors.transparent,
                      padding: EdgeInsets.fromLTRB(
                        scale.w(10),
                        0,
                        scale.w(10),
                        scale.h(14),
                      ),
                      child: Row(
                        children: [
                          _buildQuickAction(
                            scale,
                            _lang.get('rewards'),
                            icon: Icons.redeem_rounded, // Better gift icon
                            onTap: () => widget.onTabSelected?.call(2),
                          ),
                          SizedBox(width: scale.w(10)),
                          _buildQuickAction(
                            scale,
                            _lang.get('menu'),
                            icon: Icons.menu_book_rounded,
                            onTap: () => widget.onTabSelected?.call(1),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    color: Colors.transparent,
                    padding: EdgeInsets.only(top: scale.h(6)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildBannerCarousel(scale),
                        _buildRecentOrderHeader(scale),
                        SizedBox(height: scale.h(10)),
                        _buildRecentOrder(scale),
                      ],
                    ),
                  ),
                  _buildPromoHeader(scale),
                  _buildPromoGrid(scale),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
