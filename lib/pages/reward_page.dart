import 'package:flutter/material.dart';
import 'package:shakey/app_color.dart';
import 'package:shakey/models/menu.dart';
import 'package:shakey/pages/reward_detail_page.dart';
import 'package:shakey/services/reward_service.dart';
import 'package:shakey/services/auth_service.dart';
import 'package:shakey/services/user_service.dart';
import 'package:shakey/services/language_service.dart';
import 'package:shakey/models/user.dart';

class RewardPage extends StatefulWidget {
  const RewardPage({super.key});

  @override
  State<RewardPage> createState() => _RewardPageState();
}

class _RewardPageState extends State<RewardPage>
    with SingleTickerProviderStateMixin {
  final RewardService _rewardService = RewardService();
  final UserService _userService = UserService.instance;
  final _lang = LanguageService.instance;
  late TabController _tabController;

  List<Reward> _availableRewards = [];
  List<UserReward> _myRewards = [];
  bool _isLoading = true;
  User? _user;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _userService.addListener(_onUserChanged);
    _lang.addListener(_onLanguageChanged);
    _fetchData();
  }

  void _onLanguageChanged() {
    if (mounted) setState(() {});
  }

  void _onUserChanged() {
    if (mounted) {
      setState(() {
        _user = _userService.user;
      });
    }
  }

  @override
  void dispose() {
    _lang.removeListener(_onLanguageChanged);
    _userService.removeListener(_onUserChanged);
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _fetchData() async {
    setState(() => _isLoading = true);
    final auth = AuthService.instance;

    try {
      final available = await _rewardService.getRewardList();
      List<UserReward> myRewards = [];
      if (auth.isAuthenticated) {
        final allMyRewards = await _rewardService.getUserRewards();
        myRewards = allMyRewards
            .where((r) => r.status.toUpperCase() == 'ACTIVE')
            .toList();
      }

      if (mounted) {
        setState(() {
          _availableRewards = available;
          _myRewards = myRewards;
          _isLoading = false;
        });
      }

      // Fetch profile in the background so it doesn't block the UI
      if (auth.isAuthenticated) {
        _userService
            .getProfile()
            .then((profile) {
              if (mounted) setState(() => _user = profile);
            })
            .catchError((e) {
              print('Background profile fetch error: $e');
              return null;
            });
      }
    } catch (e) {
      print('Error in _fetchData: $e');
      if (mounted) setState(() => _isLoading = false);
    }
  }

  double _calculateProgress() {
    if (_user == null) return 0.0;
    final cups = _user!.totalCupsPurchased;
    switch (_user!.member) {
      case MemberLevel.Bronze:
        return (cups / 50).clamp(0.0, 1.0);
      case MemberLevel.Silver:
        return ((cups - 50) / 100).clamp(0.0, 1.0);
      case MemberLevel.Gold:
        return 1.0;
    }
  }

  String _getNextLevelText() {
    if (_user == null) return _lang.get('join_member_earn');
    final cups = _user!.totalCupsPurchased;
    switch (_user!.member) {
      case MemberLevel.Bronze:
        final remaining = 50 - cups;
        return '${_lang.get('another')} ${remaining > 0 ? remaining : 0} ${_lang.get('cups_to')} ${_lang.get('reach_silver')}';
      case MemberLevel.Silver:
        final remaining = 150 - cups;
        return '${_lang.get('another')} ${remaining > 0 ? remaining : 0} ${_lang.get('cups_to')} ${_lang.get('reach_gold')}';
      case MemberLevel.Gold:
        return _lang.get('max_level');
    }
  }

  Gradient _getMemberGradient() {
    if (_user == null) return AppColor.bronzeGradient;
    switch (_user!.member) {
      case MemberLevel.Bronze:
        return AppColor.bronzeGradient;
      case MemberLevel.Silver:
        return AppColor.silverGradient;
      case MemberLevel.Gold:
        return AppColor.goldGradient;
    }
  }

  String _getLocalizedMemberName(MemberLevel? level) {
    if (level == null) return _lang.get('bronze_member');
    switch (level) {
      case MemberLevel.Bronze:
        return _lang.get('bronze_member');
      case MemberLevel.Silver:
        return _lang.get('silver_member');
      case MemberLevel.Gold:
        return _lang.get('gold_member');
    }
  }

  void _showPrivilegeDialog() {
    showDialog<void>(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: _getMemberGradient(),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.star_rounded,
                  color: Colors.white,
                  size: 40,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '${_getLocalizedMemberName(_user?.member)} ${_lang.get('privilege')}',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              _buildPrivilegeRow(
                Icons.local_offer_rounded,
                _lang.get('privilege_discount'),
              ),
              const SizedBox(height: 16),
              _buildPrivilegeRow(
                Icons.cake_rounded,
                _lang.get('privilege_birthday'),
              ),
              const SizedBox(height: 16),
              _buildPrivilegeRow(
                Icons.auto_awesome_rounded,
                _lang.get('privilege_double_points'),
              ),
              const SizedBox(height: 16),
              _buildPrivilegeRow(
                Icons.fiber_new_rounded,
                _lang.get('privilege_early_access'),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primaryRed,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    elevation: 0,
                  ),
                  child: Text(
                    _lang.get('close'),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
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

  Widget _buildPrivilegeRow(IconData icon, String text) {
    final cleanText = text.startsWith('• ') ? text.substring(2) : text;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColor.primaryRed, size: 22),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            cleanText,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF7E6),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          _buildPointHeader(),
          _buildTabBar(),
        ],
        body: TabBarView(
          controller: _tabController,
          children: [_buildRewardCards(), _buildMyRewards()],
        ),
      ),
    );
  }

  Widget _buildPointHeader() {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 30),
        decoration: BoxDecoration(
          gradient: _getMemberGradient(),
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(36),
            bottomRight: Radius.circular(36),
          ),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getLocalizedMemberName(_user?.member),
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      '${_user?.point ?? 0} ${_lang.get('points')}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: _showPrivilegeDialog,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.2),
                    foregroundColor: Colors.white,
                    elevation: 0,
                  ),
                  child: Text(_lang.get('privilege')),
                ),
              ],
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: _calculateProgress(),
              backgroundColor: Colors.white.withOpacity(0.3),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                _getNextLevelText(),
                style: const TextStyle(color: Colors.white60, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _SliverAppBarDelegate(
        Container(
          color: const Color(0xFFFFF7E6),
          child: TabBar(
            controller: _tabController,
            labelColor: AppColor.primaryRed,
            unselectedLabelColor: Colors.grey,
            indicatorColor: AppColor.primaryRed,
            indicatorSize: TabBarIndicatorSize.label,
            tabs: [
              Tab(text: _lang.get('available')),
              Tab(text: _lang.get('my_rewards')),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRewardCards() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColor.primaryRed),
      );
    }
    if (_availableRewards.isEmpty) {
      return Center(child: Text(_lang.get('no_rewards_available')));
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 16,
        mainAxisExtent: 270,
      ),
      itemCount: _availableRewards.length,
      itemBuilder: (context, index) =>
          _buildRewardCard(_availableRewards[index]),
    );
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return _lang.get('no_expiry');
    try {
      // Handle standard ISO 8601 strings
      final dt = DateTime.parse(dateStr);
      return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
    } catch (e) {
      if (dateStr.length >= 10) {
        return dateStr.substring(0, 10);
      }
      return dateStr;
    }
  }

  Future<void> _handleRedeem(Reward reward) async {
    final auth = AuthService.instance;
    final userService = UserService.instance;
    final user = userService.user;

    if (!auth.isAuthenticated || user == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(_lang.get('login_redeem_error'))));
      return;
    }

    if (user.point < reward.points) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_lang.get('not_enough_points')),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final success = await _rewardService.redeemReward(reward.id);
    if (success && mounted) {
      // Sync points in global state
      await userService.getProfile();
      _fetchData();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_lang.get('redeemed_success')),
          backgroundColor: Colors.green,
        ),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(_lang.get('already_redeemed'))));
    }
  }

  Widget _buildRewardCard(Reward reward) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => CouponDetailPage(previewReward: reward),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: SizedBox(
                height: 130,
                width: double.infinity,
                child: reward.image != null && reward.image!.startsWith('http')
                    ? Image.network(
                        reward.image!,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                  : null,
                              strokeWidth: 2,
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          print('Error loading reward image: $error');
                          return const Center(
                            child: Icon(Icons.broken_image, color: Colors.grey),
                          );
                        },
                      )
                    : Image.asset(
                        'assets/images/Chocolate.png',
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            // Text info
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    reward.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: Color(0xFF2F2F34),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${_lang.get('valid_until')} ${_formatDate(reward.expDate)}',
                    style: const TextStyle(
                      color: Color(0xFF8A909C),
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${reward.points} ${_lang.get('pts')}',
                    style: const TextStyle(
                      color: AppColor.primaryRed,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            // Floating rounded Redeem button
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: SizedBox(
                height: 36,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _handleRedeem(reward),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primaryRed,
                    foregroundColor: Colors.white,
                    shape: const StadiumBorder(),
                    elevation: 0,
                  ),
                  child: Text(
                    _lang.get('redeem'),
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMyRewards() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColor.primaryRed),
      );
    }
    if (_myRewards.isEmpty) {
      return Center(child: Text(_lang.get('no_owned_rewards')));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: _myRewards.length,
      itemBuilder: (context, index) => _buildMyRewardCard(_myRewards[index]),
    );
  }

  Widget _buildMyRewardCard(UserReward userReward) {
    print('Building card for reward: ${userReward.id}');
    final reward = userReward.reward;
    if (reward == null) {
      print('Reward object is NULL for UserReward: ${userReward.id}');
      return const SizedBox();
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColor.primaryRed.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              width: 80,
              height: 80,
              child: reward.image != null && reward.image!.startsWith('http')
                  ? Image.network(
                      reward.image!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.broken_image, color: Colors.grey),
                    )
                  : Image.asset(
                      'assets/images/Chocolate.png',
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  reward.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${_lang.get('status')}: ${userReward.status}',
                  style: TextStyle(color: Colors.grey[600], fontSize: 11),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () => _useCoupon(userReward),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFAA8515),
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              minimumSize: const Size(0, 32),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Text(_lang.get('use'), style: const TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }

  void _useCoupon(UserReward userReward) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CouponDetailPage(
          userReward: userReward,
          onUsed: () async {
            await UserService.instance.getProfile();
            _fetchData();
          },
        ),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final Container _tabBar;

  @override
  double get minExtent => 48;
  @override
  double get maxExtent => 48;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return _tabBar;
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
