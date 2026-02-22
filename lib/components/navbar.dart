import 'dart:ui';
import 'package:flutter/material.dart';
import '../app_color.dart';

class NavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int>? onTap;

  const NavBar({super.key, this.currentIndex = 0, this.onTap});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: true,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 16.0,
          right: 16.0,
          bottom: 24.0,
          top: 4.0,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(50.0),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
            child: Container(
              height: 70,
              decoration: BoxDecoration(
                color: Colors.white.withValues(
                  alpha: 0.8,
                ), // Liquid glass style
                borderRadius: BorderRadius.circular(50.0),
                border: Border.all(color: AppColor.primaryRed, width: 2.5),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildNavItem(0, Icons.home_filled, 'หน้าหลัก'),
                  _buildNavItem(1, Icons.menu_book, 'เมนู'),
                  _buildNavItem(2, Icons.military_tech, 'รีวอร์ด'),
                  _buildNavItem(3, Icons.menu, 'เพิ่มเติม'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = currentIndex == index;
    final color = isSelected
        ? AppColor.primaryRed
        : AppColor.primaryRed.withValues(alpha: 0.6);

    return GestureDetector(
      onTap: () => onTap?.call(index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 70, // Ensure wide enough for text
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
