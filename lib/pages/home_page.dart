import 'package:flutter/material.dart';
import 'package:shakey/router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const Color _primaryRed = Color(0xFFE62553);
  static const Color _cream = Color(0xFFF1E3C0);
  static const Color _softGold = Color(0xFFF6E6B8);
  static const Color _placeholder = Color(0xFFB7B7B7);

  void _onNavTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        break;
      case 1:
        Navigator.pushReplacementNamed(context, AppRoutes.MenuPage);
        break;
      case 2:
        Navigator.pushReplacementNamed(context, AppRoutes.RewardPage);
        break;
      case 3:
        Navigator.pushReplacementNamed(context, AppRoutes.MorePage);
        break;
    }
  }

  Widget _buildSectionCard({
    required _HomeScale scale,
    required Widget child,
    EdgeInsetsGeometry? padding,
    double radius = 12,
    Color color = Colors.white,
  }) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(scale.r(radius)),
        boxShadow: [
          BoxShadow(
            color: const Color(0x30000000),
            blurRadius: scale.r(7),
            offset: Offset(0, scale.h(3)),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildTopPanel(_HomeScale scale) {
    return Container(
      color: _primaryRed,
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
                        color: _primaryRed,
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
                            fontSize: scale.sp(20),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          'Kainui',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: scale.sp(38),
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
                color: _softGold,
                padding: EdgeInsets.symmetric(
                  horizontal: scale.w(12),
                  vertical: scale.h(10),
                ),
                radius: 24,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.qr_code_2_rounded,
                      color: _primaryRed,
                      size: scale.sp(22),
                    ),
                    SizedBox(width: scale.w(8)),
                    Text(
                      'Earn Point',
                      style: TextStyle(
                        color: _primaryRed,
                        fontWeight: FontWeight.w700,
                        fontSize: scale.sp(15),
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
                Icon(
                  Icons.account_circle_rounded,
                  size: scale.sp(34),
                  color: const Color(0xFFBE9C2D),
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
                          fontSize: scale.sp(26),
                          height: 0.9,
                        ),
                      ),
                      Text(
                        '60 Point',
                        style: TextStyle(
                          color: _primaryRed,
                          fontWeight: FontWeight.w700,
                          fontSize: scale.sp(28),
                          height: 1,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: scale.w(70),
                  height: scale.h(38),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD0D0D0),
                    borderRadius: BorderRadius.circular(scale.r(5)),
                  ),
                ),
                SizedBox(width: scale.w(10)),
                Text(
                  'Member Card\nManage',
                  style: TextStyle(
                    color: _primaryRed,
                    fontWeight: FontWeight.w700,
                    fontSize: scale.sp(17),
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

  Widget _buildQuickAction(_HomeScale scale, String label) {
    return Expanded(
      child: _buildSectionCard(
        scale: scale,
        color: _softGold,
        padding: EdgeInsets.symmetric(vertical: scale.h(12)),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: const Color(0xFF1E1E1E),
              fontWeight: FontWeight.w500,
              fontSize: scale.sp(34),
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
        color: _placeholder,
        borderRadius: BorderRadius.circular(scale.r(10)),
        boxShadow: [
          BoxShadow(
            color: const Color(0x30000000),
            blurRadius: scale.r(7),
            offset: Offset(0, scale.h(3)),
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
      height: scale.h(225),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        primary: false,
        itemCount: 6,
        padding: EdgeInsets.symmetric(horizontal: scale.w(2)),
        separatorBuilder: (_, _) => SizedBox(width: scale.w(10)),
        itemBuilder: (_, index) {
          return Container(
            width: scale.w(170),
            decoration: BoxDecoration(
              color: _placeholder,
              borderRadius: BorderRadius.circular(scale.r(10)),
              boxShadow: [
                BoxShadow(
                  color: const Color(0x30000000),
                  blurRadius: scale.r(7),
                  offset: Offset(0, scale.h(3)),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPromoGrid(_HomeScale scale) {
    return Container(
      color: _cream,
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
              color: _placeholder,
              borderRadius: BorderRadius.circular(scale.r(10)),
              boxShadow: [
                BoxShadow(
                  color: const Color(0x30000000),
                  blurRadius: scale.r(7),
                  offset: Offset(0, scale.h(3)),
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
      backgroundColor: _cream,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildTopPanel(scale),
              Transform.translate(
                offset: Offset(0, -scale.h(8)),
                child: Container(
                  color: _cream,
                  padding: EdgeInsets.fromLTRB(
                    scale.w(10),
                    0,
                    scale.w(10),
                    scale.h(14),
                  ),
                  child: Row(
                    children: [
                      _buildQuickAction(scale, 'Reward'),
                      SizedBox(width: scale.w(10)),
                      _buildQuickAction(scale, 'Menu'),
                    ],
                  ),
                ),
              ),
              Transform.translate(
                offset: Offset(0, -scale.h(8)),
                child: Container(
                  color: _cream,
                  padding: EdgeInsets.fromLTRB(
                    scale.w(10),
                    scale.h(14),
                    scale.w(10),
                    0,
                  ),
                  child: Column(
                    children: [
                      _buildPlaceholder(scale, 200),
                      SizedBox(height: scale.h(18)),
                      Text(
                        'Recent Order',
                        style: TextStyle(
                          color: _primaryRed,
                          fontWeight: FontWeight.w700,
                          fontSize: scale.sp(40),
                        ),
                      ),
                      SizedBox(height: scale.h(12)),
                      _buildRecentOrder(scale),
                      SizedBox(height: scale.h(18)),
                      _buildPlaceholder(scale, 200),
                    ],
                  ),
                ),
              ),
              _buildPromoGrid(scale),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 0,
        selectedItemColor: _primaryRed,
        unselectedItemColor: _primaryRed,
        selectedFontSize: scale.sp(15),
        unselectedFontSize: scale.sp(15),
        showUnselectedLabels: true,
        onTap: (index) => _onNavTap(context, index),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: scale.sp(26)),
            label: 'หน้าหลัก',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book, size: scale.sp(26)),
            label: 'เมนู',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_events_outlined, size: scale.sp(26)),
            label: 'รีวอร์ด',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu, size: scale.sp(26)),
            label: 'เพิ่มเติม',
          ),
        ],
      ),
    );
  }
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
