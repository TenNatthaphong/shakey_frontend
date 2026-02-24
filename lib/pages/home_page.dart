import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shakey/app_color.dart';
import 'package:shakey/pages/coupon_detail_page.dart';
import 'package:shakey/pages/member_card_page.dart';

class HomePage extends StatefulWidget {
  final ValueChanged<int>? onTabSelected;

  const HomePage({super.key, this.onTabSelected});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomeBanner {
  final String bannerId; // Map to banner_id
  final String image; // Map to image
  final bool isAsset;

  const _HomeBanner({
    required this.bannerId,
    required this.image,
    this.isAsset = true,
  });
}

class _HomePageState extends State<HomePage> {
  // TODO(backend): When API is ready, fetch banners and update this list.
  // Ideally, use a FutureBuilder or a proper state management solution.
  static const List<_HomeBanner> _banners = [
    _HomeBanner(
      bannerId: 'b1a1a1a1-1111-1111-1111-111111111111',
      image: 'assets/images/shakewow banner.png',
    ),
    _HomeBanner(
      bannerId: 'b2b2b2b2-2222-2222-2222-222222222222',
      image: 'assets/images/shakewow banner2.png',
    ),
    _HomeBanner(
      bannerId: 'b3b3b3b3-3333-3333-3333-333333333333',
      image: 'assets/images/shakewow banner3.png',
    ),
    _HomeBanner(
      bannerId: 'b4b4b4b4-4444-4444-4444-444444444444',
      image: 'assets/images/shakewow banner4.png',
    ),
  ];

  int get _bannerCount => _banners.length;
  // TODO(backend): Replace with coupon list model from database/API.
  // Expected fields: title (promo_name), imageAsset (image_url), validUntil (valid_until), points (point_cost), detail/description.
  static const List<_PromoCoupon> _promoCoupons = [
    _PromoCoupon(
      imageAsset: 'assets/images/shakewow banner.png',
      title: 'Get 35 THB Topping San Pa Tong Sticky Rice Coupon',
      validUntil: '04 May 2026',
      points: 5,
      condition:
          '• This coupon is only for Shakey App Members.\n• This coupon is valid from 18 Feb 2026 - 4 May 2026 only.\n• This coupon can be used for Dine-in only.',
    ),
    _PromoCoupon(
      imageAsset: 'assets/images/shakewow banner2.png',
      title: 'Get 129 THB Cloudy Rocky Road Coupon',
      validUntil: '31 Mar 2026',
      points: 9,
      condition:
          '• Valid for Cloudy Rocky Road only.\n• Cannot be combined with other promotions.',
    ),
    _PromoCoupon(
      imageAsset: 'assets/images/shakewow banner3.png',
      title: 'Get 149 THB Mango Boat Coupon',
      validUntil: '04 May 2026',
      points: 9,
      condition:
          '• Valid for Mango Boat only.\n• Limited to 1 redemption per member.',
    ),
    _PromoCoupon(
      imageAsset: 'assets/images/shakewow banner4.png',
      title: '50% off Iced Lemonade & Iced Lemon Tea',
      validUntil: '31 Jan 2027',
      points: 40,
      condition:
          '• 50% discount on Iced Lemonade or Iced Lemon Tea.\n• Valid at all Shakey branches.',
    ),
  ];
  late final PageController _bannerController;
  Timer? _bannerTimer;
  int _activeBannerIndex = 0;

  @override
  void initState() {
    super.initState();
    _bannerController = PageController();
    _startTimer();
  }

  void _startTimer() {
    _bannerTimer?.cancel();
    _bannerTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _changeBannerPage(1);
    });
  }

  @override
  void dispose() {
    _bannerTimer?.cancel();
    _bannerController.dispose();
    super.dispose();
  }

  void _changeBannerPage(int delta, {bool manual = false}) {
    if (!mounted || !_bannerController.hasClients) return;

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

  void _openMemberCardPage() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const MemberCardPage()));
  }

  void _openCouponDetail(_PromoCoupon coupon) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CouponDetailPage(
          imageAsset: coupon.imageAsset,
          title: coupon.title,
          validUntil: coupon.validUntil,
          points: coupon.points,
          condition: coupon.condition,
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
                        Text(
                          'Welcome',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: scale.sp(12),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          'Kainui',
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
              scale.h(12),
              scale.w(12),
              scale.h(12),
            ),
            child: Row(
              children: [
                ShaderMask(
                  blendMode: BlendMode.srcIn,
                  shaderCallback: (Rect bounds) =>
                      AppColor.goldGradient.createShader(bounds),
                  child: Icon(Icons.person, size: scale.sp(34)),
                ),
                SizedBox(width: scale.w(10)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // TODO(backend): Replace with membership tier and point balance from API.
                      Text(
                        'Gold',
                        style: TextStyle(
                          color: const Color(0xFFC5A135),
                          fontWeight: FontWeight.w700,
                          fontSize: scale.sp(12),
                          height: 0.9,
                        ),
                      ),
                      Text(
                        '60 Point',
                        style: TextStyle(
                          color: AppColor.primaryRed,
                          fontWeight: FontWeight.w700,
                          fontSize: scale.sp(16),
                          height: 1,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: scale.w(66),
                  height: scale.h(41),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(scale.r(4)),
                    border: Border.all(color: const Color(0xFFE0E0E0)),
                  ),
                ),
                SizedBox(width: scale.w(10)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // TODO(backend): Replace with member card metadata from API.
                    Text(
                      'Member Card',
                      style: TextStyle(
                        color: AppColor.primaryRed,
                        fontWeight: FontWeight.w700,
                        fontSize: scale.sp(12),
                        height: 1,
                      ),
                    ),
                    SizedBox(height: scale.h(2)),
                    GestureDetector(
                      onTap: _openMemberCardPage,
                      child: Text(
                        'Manage',
                        style: TextStyle(
                          color: const Color(0xFF3FA9F5),
                          fontWeight: FontWeight.w700,
                          fontSize: scale.sp(12),
                          height: 1,
                          decoration: TextDecoration.underline,
                          decorationColor: const Color(0xFF3FA9F5),
                        ),
                      ),
                    ),
                  ],
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

  Widget _buildBannerImage(_HomeScale scale, _HomeBanner banner) {
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
        child: banner.isAsset
            ? Image.asset(banner.image, fit: BoxFit.cover)
            : Image.network(
                banner.image,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey[300],
                  child: const Icon(Icons.broken_image, color: Colors.grey),
                ),
              ),
      ),
    );
  }

  Widget _buildBannerCarousel(_HomeScale scale) {
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
                  final banner = _banners[index];
                  return RepaintBoundary(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: scale.w(10)),
                      child: Align(
                        alignment: Alignment.center,
                        child: _buildBannerImage(scale, banner),
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

  Widget _buildPromoGrid(_HomeScale scale) {
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
          mainAxisSpacing: scale.h(14),
          mainAxisExtent: scale.h(252),
        ),
        itemBuilder: (_, index) {
          final coupon = _promoCoupons[index];
          return GestureDetector(
            onTap: () => _openCouponDetail(coupon),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(scale.r(14)),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0x17000000),
                    blurRadius: scale.r(12),
                    offset: Offset(0, scale.h(3)),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(scale.r(14)),
                    ),
                    child: SizedBox(
                      height: scale.h(128),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.asset(coupon.imageAsset, fit: BoxFit.cover),
                          Positioned(
                            top: scale.h(8),
                            left: scale.w(8),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: scale.w(10),
                                vertical: scale.h(4),
                              ),
                              decoration: BoxDecoration(
                                color: AppColor.primaryRed.withValues(
                                  alpha: 0.9,
                                ),
                                borderRadius: BorderRadius.circular(
                                  scale.r(24),
                                ),
                              ),
                              child: Text(
                                'Use at Store',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: scale.sp(10),
                                  height: 1,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        scale.w(10),
                        scale.h(8),
                        scale.w(10),
                        scale.h(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            coupon.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: const Color(0xFF2F2F34),
                              fontWeight: FontWeight.w700,
                              fontSize: scale.sp(12),
                              height: 1.2,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            'Valid until',
                            style: TextStyle(
                              color: const Color(0xFF8A909C),
                              fontWeight: FontWeight.w500,
                              fontSize: scale.sp(10),
                            ),
                          ),
                          SizedBox(height: scale.h(2)),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  coupon.validUntil,
                                  style: TextStyle(
                                    color: const Color(0xFF656D7B),
                                    fontWeight: FontWeight.w500,
                                    fontSize: scale.sp(11),
                                  ),
                                ),
                              ),
                              _buildCouponPointChip(scale, coupon.points),
                            ],
                          ),
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
    );
  }

  Widget _buildCouponPointChip(_HomeScale scale, int points) {
    return Row(
      children: [
        Container(
          width: scale.w(18),
          height: scale.h(18),
          decoration: const BoxDecoration(
            color: AppColor.primaryRed,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.star_rounded,
            color: Colors.white,
            size: scale.sp(12),
          ),
        ),
        SizedBox(width: scale.w(4)),
        Text(
          '$points',
          style: TextStyle(
            color: AppColor.primaryRed,
            fontWeight: FontWeight.w700,
            fontSize: scale.sp(16),
            height: 1,
          ),
        ),
      ],
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
                    height: scale.h(240), // Increased to pull the curve down
                    color: AppColor.primaryRed,
                  ),
                ),
              ),
            ),
          ),
          SafeArea(
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

    // Right end point ends at height * 0.58 (just below Member Card)
    // Left start point is at height * 0.68 (slightly lower than the right end)
    path.lineTo(0, size.height * 0.68);

    // Exact Bezier mapped from the Figma blueprint proportional bounding box
    path.cubicTo(
      size.width * 0.25, // cp1 x (pulls curve up for the first mound)
      size.height * 0.45, // cp1 y
      size.width * 0.65, // cp2 x (pulls curve down into the deep trough)
      size.height * 1.05, // cp2 y
      size.width, // end x (right edge)
      size.height * 0.58, // end y (matches Figma's top right anchor)
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
  const _PromoCoupon({
    required this.imageAsset,
    required this.title,
    required this.validUntil,
    required this.points,
    required this.condition,
  });

  final String imageAsset;
  final String title;
  final String validUntil;
  final int points;
  final String condition;
}
