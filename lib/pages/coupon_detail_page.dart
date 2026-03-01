import 'package:flutter/material.dart';
import 'package:shakey/app_color.dart';
import 'package:shakey/models/menu.dart';
import 'package:shakey/services/menu_service.dart';

class CouponDetailPage extends StatefulWidget {
  final UserReward? userReward;
  final MenuReward? previewReward;
  final VoidCallback? onUsed;

  const CouponDetailPage({
    super.key,
    this.userReward,
    this.previewReward,
    this.onUsed,
  });

  @override
  State<CouponDetailPage> createState() => _CouponDetailPageState();
}

class _CouponDetailPageState extends State<CouponDetailPage> {
  final MenuService _menuService = MenuService();
  bool _isProcessing = false;

  bool get isPreview => widget.userReward == null;

  Future<void> _handleAction() async {
    setState(() => _isProcessing = true);
    try {
      if (isPreview) {
        // Handle Redeem
        final success = await _menuService.redeemReward(
          '00000000-0000-0000-0000-000000000000', // Mock User ID
          widget.previewReward!.id,
        );
        if (success) {
          if (mounted) {
            _showSuccessDialog(
              'Redeem Successful!',
              'Your reward is now in "My Rewards"',
            );
          }
        } else {
          _showError('Failed to redeem reward.');
        }
      } else {
        // Handle Use
        final success = await _menuService.useReward(
          widget.userReward!.userId,
          widget.userReward!.id,
        );
        if (success) {
          if (mounted) {
            widget.onUsed?.call();
            _showSuccessDialog(
              'Reward Used!',
              'Thank you for using your reward.',
              popTwice: true,
            );
          }
        } else {
          _showError('Failed to use reward.');
        }
      }
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void _showSuccessDialog(
    String title,
    String message, {
    bool popTwice = false,
  }) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context);
              if (popTwice) {
                // Already handled by Navigator.pop(context) above if it's just one level
              }
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final reward = widget.userReward?.reward ?? widget.previewReward;
    if (reward == null)
      return const Scaffold(body: Center(child: Text('Invalid Reward')));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(isPreview ? 'Reward Detail' : 'Voucher Detail'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 250,
              decoration: BoxDecoration(
                color: AppColor.cream,
                image: reward.image != null && reward.image!.startsWith('http')
                    ? DecorationImage(
                        image: NetworkImage(reward.image!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: reward.image == null || !reward.image!.startsWith('http')
                  ? const Center(
                      child: Icon(
                        Icons.card_giftcard,
                        size: 80,
                        color: AppColor.primaryRed,
                      ),
                    )
                  : null,
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    reward.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Valid until ${reward.expDate ?? 'Unlimited'}',
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                  if (isPreview) ...[
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          color: AppColor.primaryRed,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${reward.points} Points required',
                          style: const TextStyle(
                            color: AppColor.primaryRed,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                  const Divider(height: 48),
                  const Text(
                    'Conditions',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    reward.description ?? 'No specific conditions.',
                    style: const TextStyle(fontSize: 15, height: 1.5),
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isProcessing ? null : _handleAction,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isPreview
                            ? const Color(0xFFAA8515)
                            : AppColor.primaryRed,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isProcessing
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(
                              isPreview ? 'Redeem Now' : 'Use Reward Now',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Text(
                      isPreview
                          ? 'Points will be deducted from your account.'
                          : 'Please show this screen to the staff when ordering.',
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
