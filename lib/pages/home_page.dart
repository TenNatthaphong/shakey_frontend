import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shakey/app_color.dart';

class HomePage extends StatefulWidget {
  final ValueChanged<int>? onTabSelected;

  const HomePage({super.key, this.onTabSelected});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const int _bannerCount = 4;
  static const List<String> _banners = [
    'assets/images/shakewow banner.png',
    'assets/images/shakewow banner2.png',
    'assets/images/shakewow banner3.png',
    'assets/images/shakewow banner4.png',
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
                    color: const Color(0xFFD0D0D0),
                    borderRadius: BorderRadius.circular(scale.r(4)),
                  ),
                ),
                SizedBox(width: scale.w(10)),
                Text(
                  'Member Card\nManage',
                  style: TextStyle(
                    color: AppColor.primaryRed,
                    fontWeight: FontWeight.w700,
                    fontSize: scale.sp(12),
                    height: 1.05,
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

  Widget _buildBannerImage(_HomeScale scale, String assetPath) {
    return Container(
      width: scale.w(370),
      height: scale.h(200),
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(scale.r(10)),
        child: Image.asset(assetPath, fit: BoxFit.cover),
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
                  return RepaintBoundary(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: scale.w(10)),
                      child: Align(
                        alignment: Alignment.center,
                        child: _buildBannerImage(scale, _banners[index]),
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
      color: Colors.white.withOpacity(0.9),
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

  Widget _buildPromoGrid(_HomeScale scale) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        scale.w(16),
        scale.h(18),
        scale.w(16),
        scale.h(16),
      ),
      child: GridView.builder(
        itemCount: 4,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: scale.w(12),
          mainAxisSpacing: scale.h(12),
          childAspectRatio: 0.8,
        ),
        itemBuilder: (_, index) {
          return Container(
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
                        SizedBox(height: scale.h(18)),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: scale.w(10),
                          ),
                          child: Text(
                            'Recent Order',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColor.primaryRed,
                              fontWeight: FontWeight.w700,
                              fontSize: scale.sp(22),
                            ),
                          ),
                        ),
                        SizedBox(height: scale.h(18)),
                        _buildRecentOrder(scale),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      scale.w(10),
                      scale.h(18),
                      scale.w(10),
                      0,
                    ),
                    child: Text(
                      'Promotion for you',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColor.primaryRed,
                        fontWeight: FontWeight.w700,
                        fontSize: scale.sp(22),
                      ),
                    ),
                  ),
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
