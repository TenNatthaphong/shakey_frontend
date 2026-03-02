import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shakey/app_color.dart';
import 'package:shakey/models/menu.dart';
import 'package:shakey/pages/reward_detail_page.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shakey/services/auth_service.dart';
import 'package:shakey/services/user_service.dart';
import 'package:shakey/models/user.dart';

class HomePage extends StatefulWidget {
  final ValueChanged<int>? onTabSelected;

  const HomePage({super.key, this.onTabSelected});

  @override
  State<HomePage> createState() => _HomePageState();
}

// Simplified banner data structure: just a list of image paths/URLs

class _HomePageState extends State<HomePage> {
  List<String> _banners = [];

  int get _bannerCount => _banners.length;
  List<_PromoCoupon> _promoCoupons = [];
  bool _isLoadingRewards = true;
  User? _user;
  bool _isLoadingProfile = true;
  final UserService _userService = UserService.instance;

  late final PageController _bannerController;
  Timer? _bannerTimer;
  int _activeBannerIndex = 0;

  @override
  void initState() {
    super.initState();
    _bannerController = PageController();
    _startTimer();
    _fetchBanners();
    _fetchRewards();
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
        return ((cups - 50) / 50).clamp(0.0, 1.0);
      case MemberLevel.Gold:
        return 1.0;
    }
  }

  String _getNextLevelText() {
    if (_user == null) return 'Join member to earn points';
    final cups = _user!.totalCupsPurchased;
    switch (_user!.member) {
      case MemberLevel.Bronze:
        final remaining = 50 - cups;
        return 'Another ${remaining > 0 ? remaining : 0} cups to reach Silver';
      case MemberLevel.Silver:
        final remaining = 100 - cups;
        return 'Another ${remaining > 0 ? remaining : 0} cups to reach Gold';
      case MemberLevel.Gold:
        return 'You are at the maximum level!';
    }
  }

  Future<void> _fetchRewards() async {
    try {
      final response = await http
          .get(Uri.parse('http://127.0.0.1:3333/reward'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (mounted) {
          setState(() {
            _promoCoupons = data
                .map((e) => _PromoCoupon.fromJson(e as Map<String, dynamic>))
                .take(4) // Fetch top 4 for the home page
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
    try {
      final response = await http.get(
        Uri.parse('http://127.0.0.1:3333/banner'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (mounted && data.isNotEmpty) {
          setState(() {
            _banners = data.map((url) => url.toString()).toList();
            _activeBannerIndex = 0;
          });
          // Reset banner timer/controller if necessary
          if (_bannerController.hasClients) {
            _bannerController.jumpToPage(0);
          }
          _startTimer();
        }
      }
    } catch (e) {
      debugPrint('Error fetching banners: $e');
    }
  }

  void _startTimer() {
    _bannerTimer?.cancel();
    // Only start timer if we actually have banners to cycle through
    if (_bannerCount == 0) return;

    _bannerTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _changeBannerPage(1);
    });
  }

  @override
  void dispose() {
    _userService.removeListener(_onUserChanged);
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
        content: Text('Scanned QR: $scannedCode'),
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
                const Text(
                  'Mock QR Scanner',
                  textAlign: TextAlign.center,
                  style: TextStyle(
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
                const Text(
                  'Demo mode: tap "Scan Success" to simulate QR result',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70, fontSize: 12),
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
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // TODO(backend): Replace with scanned payload from real QR scanner integration.
                          Navigator.of(dialogContext).pop('SHAKEY-EARN-001');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.primaryRed,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Scan Success'),
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

  void _showPrivilegeDialog() {
    final memberName = _user?.member.name ?? 'Bronze';
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$memberName Member Privileges'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('• 10% discount on all drinks'),
            Text('• Birthday special gift'),
            Text('• Double points on weekends'),
            Text('• Exclusive early access to new menus'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _openCouponDetail(_PromoCoupon coupon) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CouponDetailPage(
          previewReward: MenuReward(
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
    required _HomeScale scale,
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

  Widget _buildTopPanel(_HomeScale scale) {
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
                            _user?.username ?? 'Guest',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: scale.sp(20),
                              fontWeight: FontWeight.w800,
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
                          'Earn Point',
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
                          '${_user?.member.name ?? 'Bronze'} Member',
                          style: TextStyle(
                            color: const Color(0xFFC5A135),
                            fontWeight: FontWeight.w700,
                            fontSize: scale.sp(14),
                            height: 1,
                          ),
                        ),
                        SizedBox(height: scale.h(4)),
                        Text(
                          '${_user?.point ?? 0} Points',
                          style: TextStyle(
                            color: AppColor.primaryRed,
                            fontWeight: FontWeight.w800,
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
                          'Privilege',
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
                // Progress Bar
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
                        color: const Color(0xFFC5A135),
                        borderRadius: BorderRadius.circular(scale.r(3)),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(
                              0xFFC5A135,
                            ).withValues(alpha: 0.3),
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
                    fontWeight: FontWeight.w500,
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
    _HomeScale scale,
    String label, {
    VoidCallback? onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: _buildSectionCard(
          scale: scale,
          gradient: AppColor.backgroundGradient,
          padding: EdgeInsets.symmetric(vertical: scale.h(12)),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: const Color(0xFF1E1E1E),
                fontWeight: FontWeight.w600,
                fontSize: scale.sp(22),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBannerImage(_HomeScale scale, String imagePath) {
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

  Widget _buildBannerCarousel(_HomeScale scale) {
    // If no banners are loaded yet, show a placeholder or nothing
    if (_bannerCount == 0) {
      return SizedBox(
        height: scale.h(200),
        child: Center(
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
                  // If swiped manually, reset the timer
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
    required _HomeScale scale,
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

  Widget _buildRecentOrder(_HomeScale scale) {
    return SizedBox(
      height: scale.h(240), // Increased height to accommodate shadow
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        clipBehavior: Clip.none,
        cacheExtent: 500, // Pre-render items for smoother scrolling
        itemCount: 20,
        padding: EdgeInsets.fromLTRB(scale.w(16), 0, scale.w(16), scale.h(15)),
        separatorBuilder: (_, _) => SizedBox(width: scale.w(15)),
        itemBuilder: (_, index) {
          return RepaintBoundary(
            child: Container(
              width: scale.w(170),
              margin: EdgeInsets.only(bottom: scale.h(2)),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(scale.r(10)),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0x1F000000),
                    blurRadius: scale.r(15),
                    offset: Offset(0, scale.h(5)),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPromoHeader(_HomeScale scale) {
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
              'Rewards for you',
              style: TextStyle(
                color: const Color(0xFF2F3B59),
                fontWeight: FontWeight.w800,
                fontSize: scale.sp(24),
                height: 1,
              ),
            ),
          ),
          GestureDetector(
            onTap: () => widget.onTabSelected?.call(2),
            child: Text(
              'See all',
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

  Widget _buildRecentOrderHeader(_HomeScale scale) {
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
          'Recent Order',
          style: TextStyle(
            color: const Color(0xFF2F3B59),
            fontWeight: FontWeight.w800,
            fontSize: scale.sp(24),
            height: 1,
          ),
        ),
      ),
    );
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return 'No Expiry';
    try {
      final dt = DateTime.parse(dateStr);
      return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
    } catch (e) {
      return dateStr;
    }
  }

  Widget _buildPromoGrid(_HomeScale scale) {
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
        child: const Center(
          child: Text(
            'No rewards available.',
            style: TextStyle(color: Colors.grey),
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
                  // Image
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
                  // Text info
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
                          'Valid until ${_formatDate(coupon.validUntil)}',
                          style: TextStyle(
                            color: const Color(0xFF8A909C),
                            fontSize: scale.sp(11),
                          ),
                        ),
                        SizedBox(height: scale.h(6)),
                        Text(
                          '${coupon.points} Pts',
                          style: TextStyle(
                            color: AppColor.primaryRed,
                            fontWeight: FontWeight.w800,
                            fontSize: scale.sp(16),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  // Floating rounded Redeem button
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
                          'Redeem Now',
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
    final scale = _HomeScale(context);

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
                  clipper: _TopBgClipper(),
                  child: Container(
                    height: scale.h(
                      320,
                    ), // Pull curve lower to Reward/Menu area
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
                            'Reward',
                            onTap: () => widget.onTabSelected?.call(2),
                          ),
                          SizedBox(width: scale.w(10)),
                          _buildQuickAction(
                            scale,
                            'Menu',
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

class _TopBgClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    // Lower the curve so the dip aligns around Reward/Menu quick actions.
    path.lineTo(0, size.height * 0.80);

    path.cubicTo(
      size.width * 0.26,
      size.height * 0.55,
      size.width * 0.66,
      size.height * 1.18,
      size.width,
      size.height * 0.72,
    );

    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}

class _HomeScale {
  _HomeScale(this.context)
    : _ratio = (MediaQuery.sizeOf(context).width / _designWidth).clamp(
        _minScale,
        _maxScale,
      );

  final BuildContext context;
  final double _ratio;

  static const double _designWidth = 390;
  static const double _maxScale = 1.25;
  static const double _minScale = 0.9;

  double w(double value) => value * _ratio;
  double h(double value) => value * _ratio;
  double r(double value) => value * _ratio;
  double sp(double value) => value * _ratio;
}

// - detail <= description/detail (add this field when backend is ready)
class _PromoCoupon {
  factory _PromoCoupon.fromJson(Map<String, dynamic> json) {
    return _PromoCoupon(
      rewardId: json['reward_id'] as String? ?? '',
      imageAsset: json['image'] as String? ?? '',
      title: json['name'] as String? ?? 'Untitled',
      validUntil: json['exp_date'] as String? ?? '',
      points: json['require_point'] as int? ?? 0,
      condition: json['description'] as String? ?? '',
    );
  }

  const _PromoCoupon({
    required this.rewardId,
    required this.imageAsset,
    required this.title,
    required this.validUntil,
    required this.points,
    required this.condition,
  });

  final String rewardId;
  final String imageAsset;
  final String title;
  final String validUntil;
  final int points;
  final String condition;
}
