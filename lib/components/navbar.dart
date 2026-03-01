import 'dart:ui';
import 'package:flutter/material.dart';
import '../app_color.dart';

class NavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int>? onTap;

  const NavBar({super.key, this.currentIndex = 0, this.onTap});

  @override
  Widget build(BuildContext context) {
    const borderRadius = BorderRadius.all(Radius.circular(36.0));

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
          borderRadius: borderRadius,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 16.0, sigmaY: 16.0),
            child: Container(
              height: 72,
              padding: const EdgeInsets.symmetric(
                horizontal: 10.0,
                vertical: 6.0,
              ),
              decoration: BoxDecoration(
                borderRadius: borderRadius,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withValues(alpha: 0.10),
                    Colors.white.withValues(alpha: 0.04),
                  ],
                ),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.22),
                  width: 0.9,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Main Content
                  Positioned.fill(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        const itemCount = 4;
                        final itemWidth = constraints.maxWidth / itemCount;
                        final selectedWidth = (itemWidth - 8)
                            .clamp(76.0, 92.0)
                            .toDouble();
                        final selectedLeft =
                            (itemWidth * currentIndex) +
                            (itemWidth - selectedWidth) / 2;

                        return Stack(
                          children: [
                            AnimatedPositioned(
                              duration: const Duration(milliseconds: 280),
                              curve: Curves.easeOutCubic,
                              top: 4,
                              left: selectedLeft,
                              width: selectedWidth,
                              height: constraints.maxHeight - 8,
                              child: IgnorePointer(
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: AppColor.primaryRed.withValues(
                                      alpha: 0.07,
                                    ),
                                    borderRadius: BorderRadius.circular(22.0),
                                    border: Border.all(
                                      color: AppColor.primaryRed.withValues(
                                        alpha: 0.20,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildNavItem(
                                    0,
                                    Icons.home_filled,
                                    'Home',
                                  ),
                                ),
                                Expanded(
                                  child: _buildNavItem(
                                    1,
                                    Icons.menu_book,
                                    'Menu',
                                  ),
                                ),
                                Expanded(
                                  child: _buildNavItem(
                                    2,
                                    Icons.military_tech,
                                    'Rewards',
                                  ),
                                ),
                                Expanded(
                                  child: _buildNavItem(3, Icons.menu, 'More'),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
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

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = currentIndex == index;
    final color = isSelected
        ? AppColor.primaryRed
        : Colors.white.withValues(alpha: 0.96);

    return GestureDetector(
      onTap: () => onTap?.call(index),
      behavior: HitTestBehavior.opaque,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 86),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 20),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 9.5,
                  height: 1.0,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
