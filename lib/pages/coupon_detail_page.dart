import 'package:flutter/material.dart';
import 'package:shakey/app_color.dart';

class CouponDetailPage extends StatelessWidget {
  // TODO(backend): This screen currently receives mock data from local UI state.
  // Switch to API-driven coupon detail model when backend endpoint is ready.
  // Expected backend fields on this page: image_url, promo_name, valid_until, point_cost, detail/usage_condition.
  const CouponDetailPage({
    super.key,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F3),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF3B3D42),
        surfaceTintColor: Colors.transparent,
        elevation: 1,
        title: const Text(
          'Coupon Detail',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      SizedBox(
                        height: 320,
                        width: double.infinity,
                        child: Image.asset(imageAsset, fit: BoxFit.cover),
                      ),
                      Positioned(
                        left: 16,
                        right: 16,
                        bottom: -118,
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(14, 18, 14, 14),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0F0F0),
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x1A000000),
                                blurRadius: 14,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 6,
                                ),
                                decoration: const BoxDecoration(
                                  color: AppColor.primaryRed,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(999),
                                  ),
                                ),
                                child: const Text(
                                  'Use at Store',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 11,
                                    height: 1,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                title,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Color(0xFF35373C),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                  height: 1.2,
                                ),
                              ),
                              const SizedBox(height: 18),
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      children: [
                                        const Text(
                                          'Use',
                                          style: TextStyle(
                                            color: Color(0xFF9DA1AA),
                                            fontSize: 12,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: 34,
                                              height: 34,
                                              decoration: const BoxDecoration(
                                                color: AppColor.primaryRed,
                                                shape: BoxShape.circle,
                                              ),
                                              child: const Icon(
                                                Icons.star_rounded,
                                                color: Colors.white,
                                                size: 22,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              '$points',
                                              style: const TextStyle(
                                                color: AppColor.primaryRed,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 24,
                                                height: 1,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: 1,
                                    height: 86,
                                    color: const Color(0xFFD3D3D3),
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        const Text(
                                          'Campaign valid until',
                                          style: TextStyle(
                                            color: Color(0xFF9DA1AA),
                                            fontSize: 12,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          validUntil,
                                          style: const TextStyle(
                                            color: Color(0xFF35373C),
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 136),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFEFEF),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // TODO(backend): Replace usage conditions with backend CMS/content payload.
                          Text(
                            'Usage Condition',
                            style: TextStyle(
                              color: Color(0xFF35373C),
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            condition,
                            style: TextStyle(
                              color: const Color(0xFF3F434A),
                              fontSize: 11,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          Container(
            color: const Color(0xFFE9E9E9),
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: SafeArea(
              top: false,
              child: SizedBox(
                width: double.infinity,
                height: 58,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD90032),
                    foregroundColor: Colors.white,
                    shape: const StadiumBorder(),
                  ),
                  child: const Text(
                    'Redeem Now',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
