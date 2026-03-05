import 'package:flutter/material.dart';
import 'package:shakey/app_color.dart';
import 'package:shakey/models/menu.dart';
import 'package:shakey/services/reward_service.dart';
import 'package:shakey/services/user_service.dart';
import 'package:shakey/services/language_service.dart';

class CouponDetailPage extends StatefulWidget {
  final UserReward? userReward;
  final Reward? previewReward;
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
  final RewardService _rewardService = RewardService();
  bool _isProcessing = false;
  final _lang = LanguageService.instance;

  @override
  void initState() {
    super.initState();
    _lang.addListener(_onLanguageChanged);
  }

  void _onLanguageChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _lang.removeListener(_onLanguageChanged);
    super.dispose();
  }

  bool get isPreview => widget.userReward == null;

  Future<void> _handleAction() async {
    final userService = UserService.instance;
    final user = userService.user;

    if (isPreview) {
      if (user == null) {
        _showError('Please login to redeem rewards.');
        return;
      }
      if (user.point < widget.previewReward!.points) {
        _showError(
          '${_lang.get('not_enough_points_msg')} ${widget.previewReward!.points} Pts.',
        );
        return;
      }
    }

    setState(() => _isProcessing = true);
    try {
      if (isPreview) {
        // Handle Redeem
        final success = await _rewardService.redeemReward(
          widget.previewReward!.id,
        );
        if (success) {
          // Sync points after successful redeem
          await userService.getProfile();
          if (mounted) {
            _showSuccessDialog(
              _lang.get('redeem_success_title'),
              _lang.get('redeem_success_msg'),
            );
          }
        } else {
          _showError(_lang.get('failed_redeem'));
        }
      } else {
        // Handle Use
        final success = await _rewardService.useReward(widget.userReward!.id);
        if (success) {
          if (mounted) {
            widget.onUsed?.call();
            _showSuccessDialog(
              _lang.get('reward_used_title'),
              _lang.get('reward_used_msg'),
              popTwice: true,
            );
          }
        } else {
          _showError(_lang.get('failed_use'));
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
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: const BoxDecoration(
                  color: Color(0xFFE8F5E9),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  color: Color(0xFF4CAF50),
                  size: 50,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2F2F34),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                message,
                style: const TextStyle(
                  fontSize: 15,
                  color: Color(0xFF8A909C),
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primaryRed,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    _lang.get('ok'),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final reward = widget.userReward?.reward ?? widget.previewReward;
    if (reward == null)
      return Scaffold(body: Center(child: Text(_lang.get('invalid_reward'))));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          isPreview ? _lang.get('reward_detail') : _lang.get('voucher_detail'),
        ),
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
                    '${_lang.get('valid_until')} ${reward.expDate ?? 'Unlimited'}',
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
                          '${reward.points}${_lang.get('points_required')}',
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
                  Text(
                    _lang.get('conditions'),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    reward.description ?? _lang.get('no_conditions'),
                    style: const TextStyle(fontSize: 15, height: 1.5),
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isProcessing ? null : _handleAction,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.primaryRed,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isProcessing
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(
                              isPreview
                                  ? _lang.get('redeem_now')
                                  : _lang.get('use_reward_now'),
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
                          ? _lang.get('points_deducted_msg')
                          : _lang.get('show_to_staff_msg'),
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
