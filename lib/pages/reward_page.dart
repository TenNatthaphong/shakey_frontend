import 'package:flutter/material.dart';
import 'package:shakey/app_color.dart';
import 'package:shakey/pages/coupon_detail_page.dart';

class RewardPage extends StatefulWidget {
  const RewardPage({super.key});

  @override
  State<RewardPage> createState() => _RewardPageState();
}

class _RewardPageState extends State<RewardPage> {
  static const int _extraRewardBoxes = 6;
  // TODO(backend): Replace with reward/coupon list from database/API.
  // Expected fields: title (promo_name), imageAsset (image_url), validUntil (valid_until), points (point_cost), detail/description.
  static const List<_RewardCoupon> _rewardCoupons = [
    _RewardCoupon(
      rewardId: 'rw-001',
      imageAsset: 'assets/images/shakewow banner.png',
      title: 'Get 35 THB Topping San Pa Tong Sticky Rice Coupon',
      validUntil: '04 May 2026',
      points: 5,
      condition:
          '• This coupon is only for Shakey App Members.\n• This coupon is valid from 18 Feb 2026 - 4 May 2026 only.\n• This coupon is valid for 15 minutes after using coupon.\n• This coupon can be used for Dine-in only.',
      invoke: false,
    ),
    _RewardCoupon(
      rewardId: 'rw-002',
      imageAsset: 'assets/images/shakewow banner2.png',
      title: 'Get 129 THB Cloudy Rocky Road Coupon',
      validUntil: '31 Mar 2026',
      points: 9,
      condition:
          '• Valid for Cloudy Rocky Road only.\n• Cannot be combined with other promotions.\n• Valid until 31 Mar 2026.',
      invoke: false,
    ),
    _RewardCoupon(
      rewardId: 'rw-003',
      imageAsset: 'assets/images/shakewow banner3.png',
      title: 'Get 149 THB Mango Boat Coupon',
      validUntil: '04 May 2026',
      points: 9,
      condition:
          '• Valid for Mango Boat only.\n• Limited to 1 redemption per member.\n• Valid until 04 May 2026.',
      invoke: false,
    ),
    _RewardCoupon(
      rewardId: 'rw-004',
      imageAsset: 'assets/images/shakewow banner4.png',
      title: '50% off Iced Lemonade & Iced Lemon Tea',
      validUntil: '31 Jan 2027',
      points: 40,
      condition:
          '• 50% discount on Iced Lemonade or Iced Lemon Tea.\n• Valid at all Shakey branches.\n• Valid until 31 Jan 2027.',
      invoke: false,
    ),
  ];

  void _showRedeemVoucherOverlay() {
    // TODO(backend): Send this code to redeem API when backend is ready.
    final voucherController = TextEditingController();

    showDialog<void>(
      context: context,
      barrierColor: Colors.black54,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 26),
          child: Container(
            padding: const EdgeInsets.fromLTRB(14, 16, 14, 16),
            decoration: BoxDecoration(
              color: const Color(0xFFF8EFD8),
              border: Border.all(color: Colors.black, width: 2),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Redeem voucher',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColor.primaryRed,
                    fontSize: 44,
                    fontWeight: FontWeight.w700,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 18),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x3D000000),
                        blurRadius: 8,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: voucherController,
                    style: const TextStyle(fontSize: 16, color: Colors.black87),
                    decoration: InputDecoration(
                      hintText: 'Enter code here...',
                      hintStyle: const TextStyle(
                        color: Color(0xFFB1B1B1),
                        fontSize: 12,
                      ),
                      isDense: true,
                      filled: true,
                      fillColor: const Color(0xFFDDDDDD),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: const BorderSide(color: Color(0xFF9D9D9D)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: const BorderSide(color: Color(0xFF9D9D9D)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: const BorderSide(
                          color: AppColor.primaryRed,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 24,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(dialogContext).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.primaryRed,
                      foregroundColor: Colors.white,
                      shape: const StadiumBorder(),
                      elevation: 8,
                      shadowColor: const Color(0x61000000),
                      textStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    child: const Text('Redeem'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ).then((_) => voucherController.dispose());
  }

  void _openCouponDetail(_RewardCoupon coupon) {
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

  Widget _buildRewardCard(_RewardCoupon coupon) {
    return GestureDetector(
      onTap: () => _openCouponDetail(coupon),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [
            BoxShadow(
              color: Color(0x17000000),
              blurRadius: 12,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(14),
              ),
              child: SizedBox(
                height: 128,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(coupon.imageAsset, fit: BoxFit.cover),
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColor.primaryRed.withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: const Text(
                          'Use at Store',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 10,
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
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      coupon.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF2F2F34),
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                        height: 1.2,
                      ),
                    ),
                    const Spacer(),
                    const Text(
                      'Valid until',
                      style: TextStyle(
                        color: Color(0xFF8A909C),
                        fontWeight: FontWeight.w500,
                        fontSize: 10,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            coupon.validUntil,
                            style: const TextStyle(
                              color: Color(0xFF656D7B),
                              fontWeight: FontWeight.w500,
                              fontSize: 11,
                            ),
                          ),
                        ),
                        _buildCouponPointChip(coupon.points),
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
  }

  Widget _buildCouponPointChip(int points) {
    return Row(
      children: [
        Container(
          width: 18,
          height: 18,
          decoration: const BoxDecoration(
            color: AppColor.primaryRed,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.star_rounded, color: Colors.white, size: 12),
        ),
        const SizedBox(width: 4),
        Text(
          '$points',
          style: const TextStyle(
            color: AppColor.primaryRed,
            fontWeight: FontWeight.w700,
            fontSize: 16,
            height: 1,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF7E6),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
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
                  Positioned.fill(
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: AppColor.goldGradient,
                      ),
                    ),
                  ),
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
                              // TODO(backend): Replace reward summary data with API response.
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
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: _showRedeemVoucherOverlay,
                            borderRadius: BorderRadius.circular(25),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                gradient: AppColor.couponGradient,
                                borderRadius: BorderRadius.circular(25),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.15),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: const Text(
                                'Redeem Voucher',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
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
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 14,
                mainAxisExtent: 252,
              ),
              delegate: SliverChildBuilderDelegate((context, index) {
                final coupon = _rewardCoupons[index % _rewardCoupons.length];
                return _buildRewardCard(coupon);
              }, childCount: _rewardCoupons.length + _extraRewardBoxes),
            ),
          ),
        ],
      ),
    );
  }
}

class _RewardCoupon {
  const _RewardCoupon({
    required this.rewardId,
    required this.imageAsset,
    required this.title,
    required this.validUntil,
    required this.points,
    required this.condition,
    required this.invoke,
  });

  final String rewardId; // Map to reward_id
  final String imageAsset; // Map to image
  final String title; // Map to header
  final String validUntil; // Map to exp_date
  final int points; // Map to require_point
  final String condition; // Map to condition
  final bool invoke; // Map to invoke
}
