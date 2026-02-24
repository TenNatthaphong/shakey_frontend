import 'package:flutter/material.dart';
import 'package:shakey/components/navbar.dart';
import 'package:shakey/pages/home_page.dart';
import 'package:shakey/pages/menu_page.dart';
import 'package:shakey/pages/reward_page.dart';
import 'package:shakey/pages/more_page.dart';

class MainLayout extends StatefulWidget {
  final int initialIndex;

  const MainLayout({super.key, this.initialIndex = 0});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  late int _currentIndex;
  late final List<Widget> _pages;
  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pages = [
      HomePage(onTabSelected: _onNavTap),
      const MenuPage(),
      const RewardPage(),
      const MorePage(),
    ];
  }

  void _onNavTap(int index) {
    if (index == _currentIndex) return;

    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        extendBody: true,
        body: IndexedStack(index: _currentIndex, children: _pages),
        bottomNavigationBar: NavBar(
          currentIndex: _currentIndex,
          onTap: _onNavTap,
        ),
      ),
    );
  }
}
