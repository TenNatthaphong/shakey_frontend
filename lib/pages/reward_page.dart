import 'package:flutter/material.dart';
import 'package:shakey/app_color.dart';

class RewardPage extends StatelessWidget {
  const RewardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF7E6),
      body: CustomScrollView(
        slivers: [
          // ─── Collapsing Gold Header ──────────────────────────────────────
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            // Solid dark gold color from app_color gradient tones when pinned
            backgroundColor: const Color(0xFFAA8515),
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            leading: const SizedBox.shrink(),
            title: const Text(
              'Reward',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            centerTitle: true,
            // Cream container cap attached to bottom
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(36),
              child: Container(
                height: 30,
                decoration: const BoxDecoration(
                  color: Color(0xFFFFF7E6),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(36),
                    topRight: Radius.circular(36),
                  ),
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: EdgeInsets.zero,
              background: Stack(
                children: [
                  // Use AppColor.goldGradient as requested
                  Positioned.fill(
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: AppColor.goldGradient,
                      ),
                    ),
                  ),
                  // Details anchored from the bottom
                  Positioned(
                    bottom: 48,
                    left: 24,
                    right: 24,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Gold',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                '60 Points',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  height: 1.2,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Point will be expired in\n30 Dec 2026',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            gradient: AppColor.couponGradient,
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.15),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Text(
                            'My Coupon',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ─── Grid Items ──────────────────────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 12,
                mainAxisExtent: 190,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) => Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                childCount: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
