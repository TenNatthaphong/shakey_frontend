import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shakey/app_color.dart';
import 'package:shakey/services/language_service.dart';

class NavBar extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int>? onTap;

  const NavBar({super.key, this.currentIndex = 0, this.onTap});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  final _lang = LanguageService.instance;
  int? _hoverIndex;

  @override
  void initState() {
    super.initState();
    _lang.addListener(_onLanguageChanged);
  }

  @override
  void dispose() {
    _lang.removeListener(_onLanguageChanged);
    super.dispose();
  }

  void _onLanguageChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    const borderRadius = BorderRadius.all(Radius.circular(40.0));

    return SafeArea(
      bottom: true,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 20.0,
          right: 20.0,
          bottom: 24.0,
          top: 8.0,
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 32,
                spreadRadius: 4,
                offset: const Offset(0, 12),
              ),
              BoxShadow(
                color: AppColor.primaryRed.withValues(alpha: 0.1),
                blurRadius: 24,
                spreadRadius: 0,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: borderRadius,
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 40.0,
                sigmaY: 40.0,
              ), // Deep, creamy blur
              child: Container(
                height: 74,
                padding: const EdgeInsets.all(1.2), // Glowing stroke width
                decoration: BoxDecoration(
                  borderRadius: borderRadius,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withValues(
                        alpha: 0.6,
                      ), // Top-left glass reflection
                      Colors.white.withValues(alpha: 0.0), // Center fades out
                      Colors.white.withValues(
                        alpha: 0.3,
                      ), // Bottom-right glass reflection
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
                child: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(38.8)),
                    color: Color.fromRGBO(
                      0,
                      0,
                      0,
                      0.65,
                    ), // Deep dark glass base
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10.0,
                    vertical: 6.0,
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned.fill(
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            const itemCount = 4;
                            final itemWidth = constraints.maxWidth / itemCount;
                            final selectedWidth = (itemWidth - 12)
                                .clamp(60.0, 84.0)
                                .toDouble();

                            final activeIndex =
                                _hoverIndex ?? widget.currentIndex;
                            final selectedLeft =
                                (itemWidth * activeIndex) +
                                (itemWidth - selectedWidth) / 2;

                            void updateHoverIndex(Offset localPosition) {
                              final x = localPosition.dx;
                              if (x >= 0 && x <= constraints.maxWidth) {
                                final index = (x / itemWidth).floor().clamp(
                                  0,
                                  itemCount - 1,
                                );
                                if (_hoverIndex != index) {
                                  HapticFeedback.selectionClick();
                                  setState(() {
                                    _hoverIndex = index;
                                  });
                                }
                              } else {
                                if (_hoverIndex != null) {
                                  setState(() {
                                    _hoverIndex = null;
                                  });
                                }
                              }
                            }

                            return Stack(
                              children: [
                                AnimatedPositioned(
                                  duration: const Duration(milliseconds: 250),
                                  curve: Curves.easeOutCubic,
                                  top: 4,
                                  bottom: 4,
                                  left: selectedLeft,
                                  width: selectedWidth,
                                  child: IgnorePointer(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: AppColor.primaryRed.withValues(
                                          alpha: 0.12,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          22.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Listener(
                                  behavior: HitTestBehavior.opaque,
                                  onPointerDown: (event) =>
                                      updateHoverIndex(event.localPosition),
                                  onPointerMove: (event) =>
                                      updateHoverIndex(event.localPosition),
                                  onPointerUp: (event) {
                                    if (_hoverIndex != null &&
                                        _hoverIndex != widget.currentIndex) {
                                      widget.onTap?.call(_hoverIndex!);
                                    }
                                    setState(() {
                                      _hoverIndex = null;
                                    });
                                  },
                                  onPointerCancel: (event) {
                                    setState(() {
                                      _hoverIndex = null;
                                    });
                                  },
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: _buildNavItem(
                                          0,
                                          Icons.home_filled,
                                          _lang.get('home'),
                                        ),
                                      ),
                                      Expanded(
                                        child: _buildNavItem(
                                          1,
                                          Icons.menu_book_rounded,
                                          _lang.get('menu'),
                                        ),
                                      ),
                                      Expanded(
                                        child: _buildNavItem(
                                          2,
                                          Icons.military_tech,
                                          _lang.get('rewards'),
                                        ),
                                      ),
                                      Expanded(
                                        child: _buildNavItem(
                                          3,
                                          Icons.menu,
                                          _lang.get('more'),
                                        ),
                                      ),
                                    ],
                                  ),
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
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = (_hoverIndex ?? widget.currentIndex) == index;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 86),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? AppColor.primaryRed : Colors.grey.shade400,
              size: 22,
            ),
            const SizedBox(height: 3), // Small spacing
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppColor.primaryRed : Colors.grey.shade400,
                fontSize: 10.0,
                height: 1.0,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                letterSpacing: -0.2,
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
