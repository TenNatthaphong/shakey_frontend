import 'package:flutter/material.dart';

class HomeScale {
  HomeScale(this.context)
    : _ratio = (MediaQuery.sizeOf(context).width / _designWidth).clamp(
        _minScale,
        _maxScale,
      );

  final BuildContext context;
  final double _ratio;

  static const double _designWidth = 390;
  static const double _maxScale = 1.25;
  static const double _minScale = 0.9;

  double w(double value) => value * _ratio;
  double h(double value) => value * _ratio;
  double r(double value) => value * _ratio;
  double sp(double value) => value * _ratio;
}

class PromoCoupon {
  factory PromoCoupon.fromJson(Map<String, dynamic> json) {
    return PromoCoupon(
      rewardId: json['reward_id'] as String? ?? '',
      imageAsset: json['image'] as String? ?? '',
      title: json['name'] as String? ?? 'Untitled',
      validUntil: json['exp_date'] as String? ?? '',
      points: json['require_point'] as int? ?? 0,
      condition: json['description'] as String? ?? '',
    );
  }

  const PromoCoupon({
    required this.rewardId,
    required this.imageAsset,
    required this.title,
    required this.validUntil,
    required this.points,
    required this.condition,
  });

  final String rewardId;
  final String imageAsset;
  final String title;
  final String validUntil;
  final int points;
  final String condition;
}

class TopBgClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    // Lower the curve so the dip aligns around Reward/Menu quick actions.
    path.lineTo(0, size.height * 0.80);

    path.cubicTo(
      size.width * 0.26,
      size.height * 0.55,
      size.width * 0.66,
      size.height * 1.18,
      size.width,
      size.height * 0.72,
    );

    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}
