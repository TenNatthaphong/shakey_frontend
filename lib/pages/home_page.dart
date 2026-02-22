import 'package:flutter/material.dart';
import 'package:shakey/app_color.dart';

class HomePage extends StatelessWidget {
  final ValueChanged<int>? onTabSelected;

  const HomePage({super.key, this.onTabSelected});

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
              _buildSectionCard(
                scale: scale,
                gradient: AppColor.backgroundGradient,
                padding: EdgeInsets.symmetric(
                  horizontal: scale.w(12),
                  vertical: scale.h(10),
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
                  shaderCallback: (Rect bounds) => const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFFE5C058), Color(0xFFB1881D)],
                  ).createShader(bounds),
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

  Widget _buildPlaceholder(
    _HomeScale scale,
    double height, {
    String text = 'Banner',
  }) {
    return Container(
      height: scale.h(height),
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
      alignment: Alignment.center,
      child: Text(
        text,
        style: TextStyle(fontSize: scale.sp(40), color: Colors.black87),
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
        itemCount: 20,
        padding: EdgeInsets.fromLTRB(scale.w(16), 0, scale.w(16), scale.h(15)),
        separatorBuilder: (_, _) => SizedBox(width: scale.w(15)),
        itemBuilder: (_, index) {
          return Container(
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
                            onTap: () => onTabSelected?.call(2),
                          ),
                          SizedBox(width: scale.w(10)),
                          _buildQuickAction(
                            scale,
                            'Menu',
                            onTap: () => onTabSelected?.call(1),
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
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: scale.w(10),
                          ),
                          child: _buildPlaceholder(scale, 200),
                        ),
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
                        SizedBox(height: scale.h(12)),
                        _buildRecentOrder(scale),
                        SizedBox(height: scale.h(18)),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: scale.w(10),
                          ),
                          child: _buildPlaceholder(scale, 200),
                        ),
                      ],
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
  _HomeScale(this.context);

  final BuildContext context;

  static const double _designWidth = 393;
  static const double _maxScale = 1.25;
  static const double _minScale = 0.9;

  double get _ratio {
    final width = MediaQuery.sizeOf(context).width;
    return (width / _designWidth).clamp(_minScale, _maxScale);
  }

  double w(double value) => value * _ratio;
  double h(double value) => value * _ratio;
  double r(double value) => value * _ratio;
  double sp(double value) => value * _ratio;
}
